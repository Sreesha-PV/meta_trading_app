// import 'package:get/get.dart';
// import 'package:netdania/screens/services/authservices.dart';

// class UserController extends GetxController {

//   var userDetails = <String, dynamic>{}.obs;

//   // Fetch user details and update the reactive map
//   Future<void> fetchUserDetails(String userId) async {
//     final authService = AuthService();
//     final details = await authService.getUserDetails(userId);
//     // final details = await authService.getClientDetails();
//     userDetails.value = details ?? {};
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netdania/app/models/client_model.dart';
import 'package:netdania/app/services/authservices.dart';

class UserController extends GetxController {
  var userDetails = Rx<UserProfileData?>(null);
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  String get userName => userDetails.value?.name ?? 'User';
  String get userEmail => userDetails.value?.email ?? '';
  int get userId => userDetails.value?.userId ?? 0;
  List<Account> get accounts => userDetails.value?.accounts ?? [];

  Account? get primaryAccount => accounts.isNotEmpty ? accounts.first : null;
  int get primaryAccountId => primaryAccount?.accountId ?? 0;

  @override
  void onInit() {
    super.onInit();
    debugPrint('👤 UserController initialized');
  }

  Future<void> fetchUserDetails() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      debugPrint('📥 Fetching user details...');

      final authService = AuthService();
      final data = await authService.getUserDetails();

      if (data != null) {
        userDetails.value = data;
        debugPrint('✅ User details loaded successfully');
        debugPrint('👤 User: ${data.email} (${data.name ?? "No name"})');
        debugPrint('🆔 User ID: ${data.userId}');
        debugPrint('📊 Accounts: ${data.accounts.length}');

        // Log account details
        for (var i = 0; i < data.accounts.length; i++) {
          final account = data.accounts[i];
          debugPrint(
            '   Account $i: ${account.name ?? "Unnamed"} (ID: ${account.accountId})',
          );
        }
      } else {
        errorMessage.value = 'Failed to fetch user details';
        debugPrint('⚠️ User details returned null');
      }
    } catch (e, stackTrace) {
      errorMessage.value = 'Error: $e';
      debugPrint('❌ Error in UserController.fetchUserDetails: $e');
      debugPrint('Stack trace: $stackTrace');
    } finally {
      isLoading.value = false;
    }
  }

  void clearUserData() {
    userDetails.value = null;
    errorMessage.value = '';
    isLoading.value = false;
    debugPrint('🗑️ User data cleared');
  }

  bool get hasUserData => userDetails.value != null;

  Account? getAccountById(int accountId) {
    try {
      return accounts.firstWhere((account) => account.accountId == accountId);
    } catch (e) {
      debugPrint('⚠️ Account with ID $accountId not found');
      return null;
    }
  }

  // Helper method to refresh user data
  Future<void> refreshUserDetails() async {
    debugPrint('🔄 Refreshing user details...');
    await fetchUserDetails();
  }
}
