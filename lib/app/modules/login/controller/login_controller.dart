// controllers/auth_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netdania/app/getX/trading_getX.dart';
import 'package:netdania/app/getX/user_getX.dart';
import 'package:netdania/app/modules/main_tab/view/main_tab_view.dart';
import 'package:netdania/app/services/authservices.dart';
import 'package:netdania/app/getX/account_getx.dart';
import 'package:netdania/utils/websocket_web.dart';
import 'package:netdania/app/getX/trade_getX.dart';
import 'package:netdania/app/getX/position_getx.dart';
import 'package:netdania/app/getX/wallet_getX.dart';
import 'package:netdania/app/getX/order_getX.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final accountTypeController = TextEditingController();

  final isLogin = true.obs;
  final isLoading = false.obs;

  final AuthService _authService = AuthService();

  void toggleForm() {
    isLogin.value = !isLogin.value;
    emailController.clear();
    passwordController.clear();
    firstNameController.clear();
    lastNameController.clear();
    accountTypeController.clear();
  }

  Future<void> submit(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Missing Fields", "Please enter both email and password");
      return;
    }
    isLoading.value = true;

    bool success = false;

    if (isLogin.value) {
      final token = await _authService.login(email, password);

      if (token != null && token.isNotEmpty) {
        await _authService.saveToken(token);

        final userController = Get.put(UserController(), permanent: true);
        await userController.fetchUserDetails();

        final accountController = Get.put(AccountController(), permanent: true);
        await accountController.ready;
        Get.put(PositionsController(), permanent: true);
        Get.put(OrderController(), permanent: true);
        Get.put(WalletController(), permanent: true);
        Get.put(TradePageController(), permanent: true);

        final tradingController = Get.put(
          TradingChartController(),
          permanent: true,
        );
        tradingController.onLoginSuccess();

        // WebSocket
        if (Get.isRegistered<WebSocketService>()) {
          Get.delete<WebSocketService>(force: true);
        }
        final webSocket = Get.put(WebSocketService(), permanent: true);
        debugPrint("🔌 Connecting WebSocket with token");
        webSocket.connect(token);

        success = true;
        debugPrint('✅ Login successful and controllers initialized');
      } else {
        success = false;
      }
    } else {
      // Sign up flow
      final firstName = firstNameController.text.trim();
      final lastName = lastNameController.text.trim();
      final accountType = accountTypeController.text.trim();

      if (firstName.isEmpty || lastName.isEmpty || accountType.isEmpty) {
        Get.snackbar("Missing Fields", "Please fill all fields");
        isLoading.value = false;
        return;
      }

      success = await _authService.signUp(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        accountType: accountType,
      );
    }

    if (success) {
      Get.offAll(() => MainTabView());
    } else {
      Get.snackbar("Error", "Failed. Try again.");
    }

    isLoading.value = false;
  }
}
