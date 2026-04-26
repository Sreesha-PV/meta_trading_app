// import 'package:get/get.dart';
// import 'package:netdania/app/getX/order_getX.dart';
// import 'package:netdania/app/getX/position_getx.dart';
// import 'package:netdania/app/models/order_modify_model.dart';
// import 'package:netdania/screens/services/modify_position_services.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// // class ModifyOrderController extends GetxController {
// //   final ModifyPositionServices _service = ModifyPositionServices();
// //   var isLoading = false.obs;

// // Future<String?> getToken() async {
// //   final prefs = await SharedPreferences.getInstance();
// //   return prefs.getString('auth_token');
// // }
// //   Future<void> modifyOrder({
// //     required int accountId,
// //     required int pendingOrderId,
// //     required double orderPrice,
// //     required double stopPrice,
// //     required double limitPrice,
// //     required int timeInForceId,
// //     // required String token,
// //   }) async {
// //      final token = await getToken();
// //   if (token == null) {
// //     Get.snackbar('Error', 'No auth token found. Please login again.');
// //     return;
// //   }
// //     try {
// //       isLoading.value = true;
// //       final body = ModifyOrderModel(
// //         accountId: accountId,
// //         pendingOrderId: pendingOrderId,
// //         orderPrice: orderPrice,
// //         stopPrice: stopPrice,
// //         limitPrice: limitPrice,
// //         timeInForceId: timeInForceId,
// //       );

// //       final result = await _service.modifyOrder(body,token);

// //       Get.snackbar("Success", "Order modified successfully");

// //       print("Modify success → $result");

// //     } catch (e) {
// //       Get.snackbar("Error", "Failed to modify order: $e");
// //     } finally {
// //       isLoading.value = false;
// //     }
// //   }
// // }
// class ModifyOrderController extends GetxController {
//   final ModifyPositionServices _service = ModifyPositionServices();
//   var isLoading = false.obs;

//   Future<String?> getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('auth_token');
//   }

//   Future<void> modifyOrder({
//     required int accountId,
//     required int pendingOrderId,
//     required double orderPrice,
//     required double stopPrice,
//     required double limitPrice,
//     required int timeInForceId,
//   }) async {
//     final token = await getToken();
//     if (token == null) {
//       Get.snackbar('Error', 'No auth token found. Please login again.');
//       return;
//     }
//     try {
//       isLoading.value = true;

//       final body = ModifyOrderModel(
//         accountId: accountId,
//         pendingOrderId: pendingOrderId,
//         orderPrice: orderPrice,
//         stopPrice: stopPrice,
//         limitPrice: limitPrice,
//         timeInForceId: timeInForceId,
//       );

//       final result = await _service.modifyOrder(body, token);

//       print("Modify success → $result");
//       Get.snackbar("Success", "Order modified successfully");

//       //  Refresh pending orders
//       final orderController = Get.find<OrderController>();
//       await orderController.fetchPendingOrders(accountId);
//       // orderController.pendingOrders.refresh();
//       //  Refresh positions (this updates SL/TP in OrderTile)
//       final positionsController = Get.find<PositionsController>();
//       await positionsController.loadPositions();
//     } catch (e) {
//       Get.snackbar("Error", "Failed to modify order: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }




import 'package:get/get.dart';
import 'package:netdania/app/getX/order_getX.dart';
import 'package:netdania/app/getX/position_getx.dart';
import 'package:netdania/app/models/order_modify_model.dart';
import 'package:netdania/app/services/modify_position_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModifyOrderController extends GetxController {
  final ModifyPositionServices _service = ModifyPositionServices();
  var isLoading = false.obs;
  // final selectedExpiration = 'GTC'.obs;
  var expirationDate = Rxn<DateTime>();
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }


Future<void> modifyOrder({
  required int accountId,
  required int status,
  required int pendingOrderId,
  required double orderPrice,
  required double stopPrice,
  required double limitPrice,
  required int timeInForceId,
  DateTime? expiryDateTime,
}) async {
  final token = await getToken();
  if (token == null) {
    Get.snackbar('Error', 'No auth token found. Please login again.');
    return;
  }

  try {
    isLoading.value = true;

    String? expiryIso;

    if (timeInForceId == 3 || timeInForceId == 4) {
      if (expiryDateTime == null) {
        Get.snackbar(
          'Validation error',
          'Expiration date is required',
        );
        return;
      }

      if (timeInForceId == 3) {
        // GTD → end of day
        expiryIso = DateTime(
          expiryDateTime.year,
          expiryDateTime.month,
          expiryDateTime.day,
          23,
          59,
          59,
        ).toUtc().toIso8601String();
      } else {
        // GTDT → exact datetime
        expiryIso = expiryDateTime.toUtc().toIso8601String();
      }
    }

    final body = ModifyOrderModel(
      accountId: accountId,
      pendingOrderId: pendingOrderId,
      orderPrice: orderPrice,
      stopPrice: stopPrice,
      limitPrice: limitPrice,
      timeInForceId: timeInForceId,
      expiryDateTime: expiryIso,
    );

    final result = await _service.modifyOrder(body, token);

    Get.snackbar("Success", "Order modified successfully");

    await Get.find<OrderController>().fetchPendingOrders(accountId);
    await Get.find<PositionsController>().loadPositions();

  } catch (e) {
    Get.snackbar("Error", "Failed to modify order: $e");
  } finally {
    isLoading.value = false;
  }
}

}