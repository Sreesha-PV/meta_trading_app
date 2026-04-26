import 'package:get/get.dart';
import 'package:netdania/app/models/order_cancle.dart';
import 'package:netdania/app/services/cancel_order_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CancelOrderController extends GetxController {
  final CancelOrderServices _service = CancelOrderServices();

  var isLoading = false.obs;

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> cancelOrder(CancelOrderModel request) async {
    isLoading.value = true;

    final token = await getToken();
    if (token == null) {
      Get.snackbar('Error', 'No auth token found. Please login again.');
      return;
    }
    try {
      // final authController = Get.find<AuthController>();
      // final token = authController.token.value;

      if (token.isEmpty) {
        Get.snackbar('Error', 'Token not found');
        return;
      }

      final response = await _service.cancelOrder(request, token);

      if (response['code'] == 5000) {
        final cancelledQty = response['data']['cancelled_qty'];
        Get.snackbar('Success', 'Order cancelled ($cancelledQty)');
      } else {
        Get.snackbar('Failed', response['message'] ?? 'Failed to cancel');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
