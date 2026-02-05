import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountController extends GetxController {
  final selectedAccountId = 0.obs;
  late Future<void> ready;

  @override
  void onInit() {
    super.onInit();
    ready = _loadAccountFromStorage();
  }

  Future<void> _loadAccountFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    print("Username $userId");

    if (userId != null && userId.isNotEmpty) {
      selectedAccountId.value = int.tryParse(userId) ?? 0;
    }
  }

  void setAccount(int id) {
    selectedAccountId.value = id;
  }
}
