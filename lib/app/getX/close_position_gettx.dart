import 'package:get/get.dart';
import 'package:netdania/app/getX/order_getX.dart';
import 'package:netdania/app/getX/position_getx.dart';
import 'package:netdania/app/models/close_order_model.dart';
import 'package:netdania/app/models/positions_model.dart';
import 'package:netdania/app/modules/main_tab/view/main_tab_view.dart';
import 'package:netdania/app/services/close_position_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CloseController extends GetxController {
  final ClosePositionService _service = ClosePositionService();
  var isLoading = false.obs;

  // Store closed positions
  var closedPositions = <Position>[].obs;

  // Add selected order type
  var selectedOrderType = 1.obs; // default to 1 (Market)
   final selectedFillPolicy = 'Fill or Kill'.obs;
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> closePosition({
    required int instrumentId,
    required int side,
    required double orderQty,
    required double orderPrice,
    required int accountId,

    required int relatedPositionId,
  }) async {
    final token = await getToken();
    if (token == null) {
      Get.snackbar('Error', 'No auth token found. Please login again.');
      return;
    }

    try {
      isLoading.value = true;
      final request = ClosePositionModel(
        instrumentId: instrumentId,
        side: side,
        orderType: selectedOrderType.value, 
        orderQty: orderQty,
        orderPrice: orderPrice,
        accountId: accountId,
        relatedPositionId: relatedPositionId,
      );

      final result = await _service.closePosition(request, token);

      final bool isSuccess =
          result["success"] == true || result["code"] == 200 || result["code"] == 5000;

      if (isSuccess) {
        Get.snackbar(
          'Success',
          result["message"] ?? 'Position closed successfully',
          snackPosition: SnackPosition.BOTTOM,
       
        );
        
       Get.until((route) => route.isFirst);
      MainTabView.selectedIndexNotifier.value = 2;

        final positionsController = Get.find<PositionsController>();
        final orderController = Get.find<OrderController>();
        final pos = positionsController.positionOrders.firstWhereOrNull(
          (p) => p.positionId == relatedPositionId,
        );

    //     if (pos != null) {
    //       positionsController.positionOrders.remove(pos);
    //       // closedPositions.insert(0, pos);
    //        orderController.closedOrders.insert(0,
    //   OrderRequestModel(
        
    //     instrumentId: pos.instrumentId,
    //     side: pos.side,
    //     orderQty: pos.positionQty,
    //     orderPrice: pos.orderPrice,
    //     // relatedPositionId: pos.positionId,
    //     accountId: pos.accountId,
    //     orderType: selectedOrderType.value,
    //     // accountUuid: 'string', 
    //     timeInForceId: selectedFillPolicy.value == 'Fill or Kill' ? 1 : 2, 
    //     expiryDateTime: ''
    //     // timeInForceId: 1
    //   ),
    // );
    //     }

// 
//     if (pos != null) {
//   final bool isFullClose = orderQty >= pos.positionQty;

//   // Add closed order (ONLY closed quantity)
//   orderController.closedOrders.insert(
//     0,
//     OrderRequestModel(
//       instrumentId: pos.instrumentId,
//       side: pos.side,
//       orderQty: orderQty,
//       orderPrice: pos.orderPrice,
//       accountId: pos.accountId,
//       orderType: selectedOrderType.value,
//       timeInForceId:
//           selectedFillPolicy.value == 'Fill or Kill' ? 1 : 2,
//       expiryDateTime: '',
//     ),
//   );

//   if (isFullClose) {
//     // FULL CLOSE → remove position
//     positionsController.positionOrders.remove(pos);
//   } else {
//     // PARTIAL CLOSE → replace position with reduced quantity
//     final int index =
//         positionsController.positionOrders.indexOf(pos);

//     if (index != -1) {
//       positionsController.positionOrders[index] =
//           pos.copyWith(
//             positionQty: pos.positionQty - orderQty,
//           );
//     }
//   }
// }


if (pos != null) {
  final bool isFullClose = orderQty >= pos.positionQty;

  if (isFullClose) {
    // FULL CLOSE → remove position
    positionsController.positionOrders.remove(pos);
  } else {
    // PARTIALY CLOSE → reduce quantity
    final index =
        positionsController.positionOrders.indexOf(pos);

    if (index != -1) {
      positionsController.positionOrders[index] =
          pos.copyWith(
            positionQty: pos.positionQty - orderQty,
          );
    }
  }

  //  history comes later from backend
  orderController.fetchClosedOrders(accountId);
}

     } else {
        final msg = result["message"] ?? result["error"] ?? result["msg"] ?? "Something went wrong.";
        Get.snackbar('Error', msg, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to close position: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}


// import 'package:get/get.dart';
// import 'package:netdania/app/getX/position_getx.dart';
// import 'package:netdania/app/models/close_order_model.dart';
// import 'package:netdania/app/models/positions_model.dart';
// import 'package:netdania/screens/services/close_position_services.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class CloseController extends GetxController {
//   final ClosePositionService _service = ClosePositionService();

//   var isLoading = false.obs;

//   /// Stores successfully closed positions
//   var closedPositions = <Position>[].obs;

//   /// 1 = Market, 2 = Limit, 3 = Stop
//   var selectedOrderType = 1.obs;



//   // ---------------------------------------------------------------------------
//   // TOKEN
//   // ---------------------------------------------------------------------------
//   Future<String?> getToken() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       return prefs.getString('auth_token');
//     } catch (e) {
//       print("ERROR reading token: $e");
//       return null;
//     }
//   }



//   // ---------------------------------------------------------------------------
//   // CLOSE POSITION
//   // ---------------------------------------------------------------------------
//   Future<void> closePosition({
//     required int instrumentId,
//     required int side,
//     required double orderQty,
//     required double orderPrice,
//     required int accountId,
//     required int relatedPositionId,
//   }) async {

//     final token = await getToken();
//     if (token == null) {
//       Get.snackbar('Error', 'Authentication expired. Please login again.');
//       return;
//     }

//     isLoading.value = true;

//     try {
//       final request = ClosePositionModel(
//         instrumentId: instrumentId,
//         side: side,
//         orderType: selectedOrderType.value,
//         orderQty: orderQty,
//         orderPrice: orderPrice,
//         accountId: accountId,
//         relatedPositionId: relatedPositionId,
//       );

//       print("[CloseController] Sending close request: $request");

//       final result = await _service.closePosition(request, token);

//       print("[CloseController] Response: $result");

//       final isSuccess = 
//           result["success"] == true ||
//           result["code"] == 200 ||
//           result["code"] == 5000;

//       if (!isSuccess) {
//         final msg =
//             result["message"] ??
//             result["error"] ??
//             result["msg"] ??
//             "Unknown error occurred.";

//         Get.snackbar('Error', msg, snackPosition: SnackPosition.BOTTOM);
//         return;
//       }

//       // ---------------------------------------------------------------------
//       // SUCCESS
//       // ---------------------------------------------------------------------
//       Get.snackbar(
//         'Success',
//         result["message"] ?? 'Position closed successfully',
//         snackPosition: SnackPosition.BOTTOM,
//       );

//       // Remove position from active list
//       if (Get.isRegistered<PositionsController>()) {
//         final positionsController = Get.find<PositionsController>();

//         final pos = positionsController.positionOrders.firstWhereOrNull(
//           (p) => p.positionId == relatedPositionId,
//         );

//         if (pos != null) {
//           positionsController.positionOrders.remove(pos);
//           closedPositions.insert(0, pos);
//         }
//       } else {
//         print("⚠️ PositionsController not registered — cannot update list");
//       }
//     } catch (e) {
//       print("❌ ERROR closing position: $e");
//       Get.snackbar(
//         'Error',
//         'Failed to close position: $e',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }

