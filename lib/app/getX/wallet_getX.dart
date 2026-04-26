import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:netdania/app/models/wallet_model.dart';
import 'package:netdania/app/services/wallet_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletController extends GetxController {
  final WalletService _walletService = WalletService();

  final Rx<WalletModel?> wallet = Rx<WalletModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs; // Separate state for background refresh
  final RxString error = ''.obs;
  final RxString successMessage = ''.obs;

  // Cache previous values for smooth transitions
  final RxDouble _cachedBalance = 0.0.obs;
  final RxDouble _cachedUsedMargin = 0.0.obs;
  final RxDouble _cachedEquity = 0.0.obs;

  double get balance => wallet.value?.balance ?? _cachedBalance.value;
  double get usedMargin => wallet.value?.usedAmount ?? _cachedUsedMargin.value;
  double get availableAmount => wallet.value?.availableAmount ?? 0.0;
  double get equity => wallet.value?.equity ?? _cachedEquity.value;
  double get unrealisedPl => wallet.value?.unrealisedPl ?? 0.0;
  double get unclearedBalance => wallet.value?.unclearedBalance ?? 0.0;
  String get currencyCode => wallet.value?.currencyCode ?? 'USD';
  String get walletUuid => wallet.value?.walletUuid ?? '';
  int get walletId => wallet.value?.walletId ?? 0;

  @override
  void onInit() {
    super.onInit();
    fetchWalletDetails();
  }

  Future<void> fetchWalletDetails({
    int currencyId = 1,
    bool showLoading = true,
  }) async {
    try {
      // Only show loading indicator on initial load
      if (showLoading && wallet.value == null) {
        isLoading.value = true;
      } else {
        isRefreshing.value = true;
      }
      
      error.value = '';
      successMessage.value = '';

      final token = await _getAuthToken();
      final clientIdStr = await _getUser();
      if (clientIdStr == null || clientIdStr.isEmpty) {
        error.value = 'User ID not found';
        isLoading.value = false;
        isRefreshing.value = false;
        return;
      }

      final clientId = int.tryParse(clientIdStr);
      if (clientId == null) {
        error.value = 'Invalid User ID';
        isLoading.value = false;
        isRefreshing.value = false;
        return;
      }

      if (token == null || token.isEmpty) {
        error.value = 'Authentication token not found';
        isLoading.value = false;
        isRefreshing.value = false;
        return;
      }

      final response = await _walletService.getWalletDetails(
        token: token,
        clientId: clientId,
        currencyId: currencyId,
      );

      if (response != null) {
        if (response.success && response.data != null) {
          // Cache old values before updating
          if (wallet.value != null) {
            _cachedBalance.value = wallet.value!.balance;
            _cachedUsedMargin.value = wallet.value!.usedAmount;
            _cachedEquity.value = wallet.value!.equity;
          }
          
          // Update wallet data
          wallet.value = response.data;
          successMessage.value = response.message;
          
          print(
            '✅ Wallet updated: Balance=\$$balance, Used Margin=\$$usedMargin',
          );
        } else {
          error.value = response.message;
        }
      } else {
        error.value = 'Failed to fetch wallet details';
      }
    } catch (e) {
      error.value = 'Error: $e';
      print('💥 Error in fetchWalletDetails: $e');
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
    }
  }

  void handleWebSocketUpdate(Map<String, dynamic> data) {
    try {
      final field = data['field'] as String?;
      print(
        '💰 Wallet ${field ?? 'update'} notification received - silent refresh',
      );

      // Silent refresh without showing loading indicator
      fetchWalletDetails(showLoading: false);
    } catch (e) {
      print('✗ Error handling wallet WebSocket update → $e');
    }
  }

  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<String?> _getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<void> refreshWallet() async {
    await fetchWalletDetails();
  }

  bool get isWalletHealthy {
    if (wallet.value == null) return false;
    return equity > 0 && usedMargin <= balance;
  }

  double get marginLevel {
    if (usedMargin <= 0) return 0.0;
    return (equity / usedMargin) * 100;
  }

  double get freeMargin {
    return equity - usedMargin;
  }

  Color get marginLevelColor {
    if (marginLevel >= 100) return Colors.green;
    if (marginLevel >= 50) return Colors.orange;
    return Colors.red;
  }

  void clearError() {
    error.value = '';
  }
}