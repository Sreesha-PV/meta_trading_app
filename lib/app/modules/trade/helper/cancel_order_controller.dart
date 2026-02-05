
import 'package:get/get.dart';
import 'package:netdania/app/getX/cancel_order_getx.dart';
import 'package:netdania/app/models/order_cancle.dart';
import 'package:netdania/app/models/order_get_model.dart';

class PendingOrderController extends GetxController {
  var pendingOrders = <PendingOrder>[].obs;
  var isLoading = false.obs;
  final CancelOrderController cancelController = Get.put(CancelOrderController());

  // fetch pending orders for a specific account
  Future<void> fetchPendingOrders(int accountId) async {
    isLoading.value = true;
    try {

    } finally {
      isLoading.value = false;
    }
  }

  // cancel a pending order
  Future<void> cancelOrder(PendingOrder order) async {
    isLoading.value = true;
    try {
      final cancelRequest = CancelOrderModel(
        accountId: order.accountId,
        refPendingOrderId: order.pendingOrderId,
        cancelledQty: order.remainingQty,
      );

      final response = await cancelController.cancelOrder(cancelRequest);

        // Remove the cancelled order from the list
        pendingOrders.removeWhere((po) => po.pendingOrderId == order.pendingOrderId);
        Get.snackbar('Success', 'Order cancelled successfully!');

    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // optional: clear all
  void clearOrders() => pendingOrders.clear();
}
