import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:netdania/screens/services/authservices.dart';
import 'package:netdania/app/getX/user_getX.dart';
import 'package:netdania/app/getX/account_getx.dart';
import 'package:netdania/utils/websocket_web.dart';
import 'package:netdania/app/modules/main_tab/view/main_tab_view.dart';
import 'package:netdania/app/getX/trading_getX.dart' as tradingControllerLib;
import 'package:netdania/app/getX/trade_getX.dart';
import 'package:netdania/app/getX/position_getx.dart';
import 'package:netdania/app/getX/wallet_getX.dart';
import 'package:netdania/app/getX/order_getX.dart';
import 'package:netdania/app/getX/symbol_filter_controller.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _initializeControllers() async {
    try {
      final userId = await _authService.getUserId();

      if (userId == null || userId.isEmpty) {
        debugPrint('❌ User ID is null or empty');
        throw Exception('User ID not found in storage');
      }
      // debugPrint('👤 Found User ID: $userId');

      final userController = Get.put(UserController());

      try {
        await userController.fetchUserDetails();
        debugPrint('✅ User details fetched successfully');
      } catch (e) {
        debugPrint('⚠️ Error fetching user details: $e');
      }

      final accountController = Get.put(AccountController(), permanent: true);
      await accountController.ready;

      Get.put(PositionsController(), permanent: true);

      Get.put(OrderController(), permanent: true);

      Get.put(WalletController(), permanent: true);

      Get.put(TradePageController(), permanent: true);

      final tradingController = Get.put(
        tradingControllerLib.TradingChartController(),
        permanent: true,
      );
      // debugPrint('✅ TradingChartController initialized');

      // debugPrint('⏳ Waiting for instruments to load...');
      int attempts = 0;
      while (tradingController.instruments.isEmpty && attempts < 50) {
        await Future.delayed(const Duration(milliseconds: 100));
        attempts++;
      }

      if (tradingController.instruments.isEmpty) {
        debugPrint(
          '⚠️ Instruments not loaded after 5 seconds, continuing anyway',
        );
      } else {
        debugPrint(
          '✅ Instruments loaded: ${tradingController.instruments.length} instruments',
        );

        final symbols =
            tradingController.instruments.values.map((e) => e.code).toList();
        debugPrint('📋 Available symbols: $symbols');
      }

      final symbolFilterController = Get.put(
        SymbolFilterController(),
        permanent: true,
      );

      int symbolAttempts = 0;
      while (symbolFilterController.isLoading.value && symbolAttempts < 30) {
        await Future.delayed(const Duration(milliseconds: 100));
        symbolAttempts++;
      }
      debugPrint(
        '✅ SymbolFilterController initialized with ${symbolFilterController.selectedCount} symbols',
      );
      tradingController.onLoginSuccess();
      debugPrint('🔔 TradingChartController notified of login success');
      final token = await _authService.getToken();
      if (token == null || token.isEmpty) {
        debugPrint('⚠️ Token is null or empty');
        throw Exception('Token not found after initialization');
      }
      if (Get.isRegistered<WebSocketService>()) {
        Get.delete<WebSocketService>(force: true);
        debugPrint('🗑️ Deleted existing WebSocket instance');
      }

      final webSocket = Get.put(WebSocketService(), permanent: true);
      debugPrint('🔌 Connecting WebSocket with token');
      webSocket.connect(token);
      debugPrint('✅ WebSocket connection initiated');
    } catch (e, stackTrace) {
      debugPrint('❌ Error initializing controllers: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> _checkAuthentication() async {
    try {
      debugPrint('🔍 Starting authentication check...');
      final token = await _authService.getToken();
      await Future.delayed(const Duration(milliseconds: 300));
      if (token == null || token.isEmpty) {
        debugPrint('🔐 No token found, redirecting to login');
        Get.offAllNamed('/login');
        return;
      }
      if (JwtDecoder.isExpired(token)) {
        debugPrint('⏰ Token expired, redirecting to login');
        await _authService.clearToken();
        Get.offAllNamed('/login');
        return;
      }

      debugPrint('✅ Valid token found');

      final decodedToken = JwtDecoder.decode(token);

      final userId = decodedToken['user_id']?.toString();

      if (userId != null && userId.isNotEmpty) {
        await _authService.storeUserId(userId);
        debugPrint('✅ User ID stored: $userId (from user_id field)');
      } else {
        debugPrint('⚠️ No user_id found in token');
        throw Exception('user_id not found in JWT token');
      }

      await _initializeControllers();

      debugPrint('✅ All controllers initialized successfully');
      debugPrint('🏠 Redirecting to MainTabView...');

      Get.offAll(() => const MainTabView());
    } catch (e, stackTrace) {
      debugPrint('❌ Auth check error: $e');
      debugPrint('Stack trace: $stackTrace');

      await _authService.clearToken();
      Get.offAllNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              strokeWidth: 3,
            ),
            const SizedBox(height: 24),
            const Text(
              'Ax1 Trading',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Initializing your account...',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
