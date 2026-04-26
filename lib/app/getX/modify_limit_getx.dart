// // import 'dart:convert';

// import 'package:flutter/rendering.dart';
// import 'package:get/get.dart';
// import 'package:netdania/app/getX/trading_getX.dart';
// // import 'package:netdania/app/getX/order_getX.dart';
// // import 'package:netdania/app/getX/position_getx.dart';
// import 'package:netdania/app/models/limit_modify_model.dart';
// import 'package:netdania/app/models/order_modify_model.dart';
// import 'package:netdania/app/modules/main_tab/view/main_tab_view.dart';
// import 'package:netdania/screens/services/modify_position_services.dart';
// import 'package:netdania/screens/services/order_services.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:netdania/app/models/order_model.dart';
// import 'package:flutter/foundation.dart';

// // class ModifyLimitController extends GetxController {
// //   final ModifyPositionServices _service = ModifyPositionServices();
// //   var isLoading = false.obs;

// // Future<String?> getToken() async {
// //   final prefs = await SharedPreferences.getInstance();
// //   return prefs.getString('auth_token');
// // }
// //   Future<void> modifyLimit({
// //     required int accountId,
// //     required int positionId,
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
// //       final body = ModifyLimitModel(
// //         accountId: accountId,
// //         positionId: positionId,
// //         orderPrice: orderPrice,
// //         stopPrice: stopPrice,
// //         limitPrice: limitPrice,
// //         timeInForceId: timeInForceId,
// //       );

// //       final result = await _service.modifyLimit(body,token);

// //       Get.snackbar("Success", "Order modified successfully");

// //       print("Modify success → $result");

// //     } catch (e) {
// //       Get.snackbar("Error", "Failed to modify order: $e");
// //     } finally {
// //       isLoading.value = false;
// //     }
// //   }
// // }

// class ModifyLimitController extends GetxController {
//   final ModifyPositionServices _service = ModifyPositionServices();
//   var isLoading = false.obs;
//   final symbol = ''.obs;
//   late TradingChartController tradingController;

//   Future<String?> getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('auth_token');
//   }

//   Future<void> modifyLimit({
//     required int accountId,
//     required int side,
//     required int instrumentId,
//     required double positionQty,
//     required int positionId,
//     required double orderPrice,
//     required double stopPrice,
//     required double limitPrice,
//     required int timeInForceId,
//     // required bool isBuy,
//   }) async {
//     final token = await getToken();
//     if (token == null) {
//       Get.snackbar('Error', 'No auth token found. Please login again.');
//       return;
//     }

//     try {
//       isLoading.value = true;

//       final body = ModifyLimitModel(
//         accountId: accountId,
//         positionId: positionId,
//         orderPrice: orderPrice,
//         stopPrice: stopPrice,
//         limitPrice: limitPrice,
//         timeInForceId: timeInForceId,
//       );

//       // print("Payload for Modify Limit: ${body.toJson()}");

//       final filteredOrders = await OrderService.fetchOrdersByRelatedPositionId(
//         accountId,
//         positionId,
//       );

//       print("Filtered Orders Count: ${filteredOrders.length}");
//       print("Filtered Orders: ${filteredOrders}");

//       bool limitOrderFound = false;
//       bool stopOrderFound = false;

//       for (final order in filteredOrders) {
//         if (order.orderType == 2) {
//           print("Limit Order → ID: ${order.pendingOrderId}");
//           if (limitPrice == orderPrice) {
//             continue;
//           }

//           final body = ModifyOrderModel(
//             accountId: accountId,
//             pendingOrderId: order.pendingOrderId,
//             orderPrice: limitPrice,
//             stopPrice: 0,
//             limitPrice: 0,
//             timeInForceId: timeInForceId,
//           );

//           final result = await _service.modifyOrder(body, token);
//           print(
//             "Modified Limit Order → ID: $order.pendingOrderId, Result: $result",
//           );
//           break;
//         } else if (order.orderType == 3) {
//           print("Stop Order → ID: ${order.pendingOrderId}");
//           if (stopPrice == orderPrice) {
//             continue;
//           }

//           final body = ModifyOrderModel(
//             accountId: accountId,
//             pendingOrderId: order.pendingOrderId,
//             orderPrice: stopPrice,
//             stopPrice: 0,
//             limitPrice: 0,
//             timeInForceId: timeInForceId,
//           );

//           final result = await _service.modifyOrder(body, token);
//           print(
//             "Modified Limit Order → ID: $order.pendingOrderId, Result: $result",
//           );
//           break;
//         } else {
//           print(
//             "Other Order Type (${order.orderType}) → ID: ${order.pendingOrderId}",
//           );
//         }
//       }

//       if (!limitOrderFound && limitPrice != orderPrice) {
//         print("No Limit Order found. Creating new Limit Order...");
//         final order = OrderRequestModel(
//           accountId: accountId,
//           // accountUuid: 'string',
//           // instrumentId: 1001,
//           instrumentId: instrumentId,
//           side: (side == 1) ? 2 : 1,
//           orderType: 2,
//           orderQty: positionQty,
//           timeInForceId: 1,
//           orderPrice: limitPrice,
//           stopPrice: 0,
//           limitPrice: 0,
//           related_position_id: positionId,
//           expiryDateTime: '',
//         );
//         //             final instrument = tradingController.getInstrumentByCode(symbol.value);
//         //     if (instrument == null) {
//         //       Get.snackbar('Error', 'Instrument not found for ${symbol.value}');
//         //       return;
//         //     }
//         //        final ticker = tradingController.tickers[symbol.value.toUpperCase()];

//         // final price =
//         //         isBuy
//         //             ? double.tryParse(ticker?['ask']?.toString() ?? '0') ?? 0
//         //             : double.tryParse(ticker?['bid']?.toString() ?? '0') ?? 0;

//         //  final instrumentId = instrument.instrumentId;
//         //     final orderType = mapDropdownToOrderType(selectedOrderType.value);

//         //       final order = OrderRequestModel(
//         //       accountId: accountId,
//         //       // accountUuid: accountController.selectedAccountUuid.value,
//         //       instrumentId: instrumentId,
//         //       side: isBuy ? 1 : 2,
//         //       orderType: orderType.index,
//         //       orderQty: volume.value,
//         //       timeInForceId: selectedFillPolicy.value == 'Fill or Kill' ? 1 : 2,
//         //       orderPrice: price,
//         //       stopPrice: stopPrice,
//         //       limitPrice: limitPrice,
//         //     );

//         final result = await OrderService.placeOrder(order);
//         print("Created New Limit Order → Result: $result");
//       }

//       if (!stopOrderFound && stopPrice != orderPrice) {
//         print("No Stop Order found. Creating new Stop Order...");
//         final order = OrderRequestModel(
//           accountId: accountId,
//           // accountUuid: 'string',
//           // instrumentId: 1001,
//           instrumentId: instrumentId,
//           side: (side == 1) ? 2 : 1,
//           orderType: 3,
//           orderQty: positionQty,
//           timeInForceId: 1,
//           orderPrice: stopPrice,
//           stopPrice: 0,
//           limitPrice: 0,
//           related_position_id: positionId,
//           expiryDateTime: '',
//         );

//         final result = await OrderService.placeOrder(order);
//         print("Created New Stop Order → Result: $result");
//       }

//       // // final result = await _service.modifyLimit(body, token);

//       // // print("Modify success → $result");
//       Get.snackbar("Success", "Limit modified successfully");
//             Get.until((route) => route.isFirst);
//       MainTabView.selectedIndexNotifier.value = 2;
//       // //  Refresh pending orders
//       // final orderController = Get.find<OrderController>();
//       // await orderController.fetchPendingOrders(accountId);
//       // // orderController.pendingOrders.refresh();

//       // //  Refresh positions (this updates SL/TP in OrderTile)
//       // final positionsController = Get.find<PositionsController>();
//       // await positionsController.loadPositions();
//     } catch (e) {
//       Get.snackbar("Error", "Failed to modify order: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<Map<String, double?>> findTpAndSl({
//     required int accountId,
//     required int positionId,
//   }) async {
//     double? stopLoss;
//     double? takeProfit;
//     try {
//       debugPrint('Fetched Position of: $positionId');

//       final filteredOrders = await OrderService.fetchOrdersByRelatedPositionId(
//         accountId,
//         positionId,
//       );

//       final remainingOrders =
//           filteredOrders.where((order) => order.orderQty > 0).toList();

//       print("Found Remianing pending order: ${remainingOrders}");

//       for (var order in remainingOrders) {
//         if (order.orderType == 2) {
//           takeProfit = order.orderPrice;
//         } else if (order.orderType == 3) {
//           stopLoss = order.orderPrice;
//         }
//       }

//       // debugPrint('Stop Loss: $stopLoss');
//       // debugPrint('Take Profit: $takeProfit');

//       return {'stopLoss': stopLoss, 'takeProfit': takeProfit};
//     } catch (e, s) {
//       print("Error in findTpAndSl: $e");
//       print(s);
//       return {'stopLoss': null, 'takeProfit': null};
//     }
//   }

// }

// // test

// // import 'dart:convert';

// import 'package:flutter/rendering.dart';
// import 'package:get/get.dart';
// import 'package:netdania/app/getX/trading_getX.dart';
// // import 'package:netdania/app/getX/order_getX.dart';
// // import 'package:netdania/app/getX/position_getx.dart';
// import 'package:netdania/app/models/limit_modify_model.dart';
// import 'package:netdania/app/models/order_modify_model.dart';
// import 'package:netdania/app/modules/main_tab/view/main_tab_view.dart';
// import 'package:netdania/screens/services/modify_position_services.dart';
// import 'package:netdania/screens/services/order_services.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:netdania/app/models/order_model.dart';
// import 'package:flutter/foundation.dart';

// // class ModifyLimitController extends GetxController {
// //   final ModifyPositionServices _service = ModifyPositionServices();
// //   var isLoading = false.obs;

// // Future<String?> getToken() async {
// //   final prefs = await SharedPreferences.getInstance();
// //   return prefs.getString('auth_token');
// // }
// //   Future<void> modifyLimit({
// //     required int accountId,
// //     required int positionId,
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
// //       final body = ModifyLimitModel(
// //         accountId: accountId,
// //         positionId: positionId,
// //         orderPrice: orderPrice,
// //         stopPrice: stopPrice,
// //         limitPrice: limitPrice,
// //         timeInForceId: timeInForceId,
// //       );

// //       final result = await _service.modifyLimit(body,token);

// //       Get.snackbar("Success", "Order modified successfully");

// //       print("Modify success → $result");

// //     } catch (e) {
// //       Get.snackbar("Error", "Failed to modify order: $e");
// //     } finally {
// //       isLoading.value = false;
// //     }
// //   }
// // }

// class ModifyLimitController extends GetxController {
//   final ModifyPositionServices _service = ModifyPositionServices();
//   var isLoading = false.obs;
//   final symbol = ''.obs;
//   final selectedExpiration = 'GTC'.obs;
//   var expirationDate = Rxn<DateTime>();
//   late TradingChartController tradingController;

//   Future<String?> getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('auth_token');
//   }

//   Future<void> modifyLimit({
//     required int accountId,
//     // required int status,
//     required int side,
//     required int instrumentId,
//     required double positionQty,
//     required int positionId,
//     required double orderPrice,
//     required double stopPrice,
//     required double limitPrice,
//     required int timeInForceId,
//     // required bool isBuy,
//   }) async {
//     final token = await getToken();
//     if (token == null) {
//       Get.snackbar('Error', 'No auth token found. Please login again.');
//       return;
//     }

//     try {
//       isLoading.value = true;

//       final body = ModifyLimitModel(
//         accountId: accountId,
//         positionId: positionId,
//         orderPrice: orderPrice,
//         stopPrice: stopPrice,
//         limitPrice: limitPrice,
//         timeInForceId: timeInForceId,
//       );

//       // print("Payload for Modify Limit: ${body.toJson()}");

//       final filteredOrders = await OrderService.fetchOrdersByRelatedPositionId(
//         accountId,
//         // status,
//         positionId,
//       );

//       print("Filtered Orders Count: ${filteredOrders.length}");
//       print("Filtered Orders: ${filteredOrders}");

//       bool limitOrderFound = false;
//       bool stopOrderFound = false;

//       for (final order in filteredOrders) {
//         if (order.orderType == 2) {
//           print("Limit Order → ID: ${order.pendingOrderId}");
//           if (limitPrice == orderPrice) {
//             continue;
//           }

// String? expiryDateTime;

// final tif = timeInForceId;
// final exp = expirationDate.value;

// if (tif == 3 || tif == 4) {
//   if (exp == null) {
//     Get.snackbar(
//       'Validation error',
//       'Expiration date is required',
//     );
//     return;
//   }

//   if (tif == 3) {
//     // GTD → end of day
//     expiryDateTime = DateTime(
//       exp.year,
//       exp.month,
//       exp.day,
//       23,
//       59,
//       59,
//     ).toUtc().toIso8601String();
//   } else {
//     // GTDT → exact datetime
//     expiryDateTime = exp.toUtc().toIso8601String();
//   }
// }

//           final body = ModifyOrderModel(
//             accountId: accountId,
//             pendingOrderId: order.pendingOrderId,
//             orderPrice: limitPrice,
//             stopPrice: 0,
//             limitPrice: 0,
//             timeInForceId: timeInForceId,
//             expiryDateTime: expiryDateTime,
//           );

//           final result = await _service.modifyOrder(body, token);
//           print(
//             "Modified Limit Order → ID: $order.pendingOrderId, Result: $result",
//           );
//           break;
//         } else if (order.orderType == 3) {
//           print("Stop Order → ID: ${order.pendingOrderId}");
//           if (stopPrice == orderPrice) {
//             continue;
//           }

// String? expiryDateTime;
//           final body = ModifyOrderModel(
//             accountId: accountId,
//             pendingOrderId: order.pendingOrderId,
//             orderPrice: stopPrice,
//             stopPrice: 0,
//             limitPrice: 0,
//             timeInForceId: timeInForceId,
//             expiryDateTime: expiryDateTime,
//           );

//           final result = await _service.modifyOrder(body, token);
//           print(
//             "Modified Limit Order → ID: $order.pendingOrderId, Result: $result",
//           );
//           break;
//         } else {
//           print(
//             "Other Order Type (${order.orderType}) → ID: ${order.pendingOrderId}",
//           );
//         }
//       }

//       if (!limitOrderFound && limitPrice != orderPrice) {
//         print("No Limit Order found. Creating new Limit Order...");
//         final order = OrderRequestModel(
//           accountId: accountId,
//           // accountUuid: 'string',
//           // instrumentId: 1001,
//           instrumentId: instrumentId,
//           side: (side == 1) ? 2 : 1,
//           orderType: 2,
//           orderQty: positionQty,
//           timeInForceId: 1,
//           orderPrice: limitPrice,
//           stopPrice: 0,
//           limitPrice: 0,
//           related_position_id: positionId,
//           expiryDateTime: '',
//         );
//         //             final instrument = tradingController.getInstrumentByCode(symbol.value);
//         //     if (instrument == null) {
//         //       Get.snackbar('Error', 'Instrument not found for ${symbol.value}');
//         //       return;
//         //     }
//         //        final ticker = tradingController.tickers[symbol.value.toUpperCase()];

//         // final price =
//         //         isBuy
//         //             ? double.tryParse(ticker?['ask']?.toString() ?? '0') ?? 0
//         //             : double.tryParse(ticker?['bid']?.toString() ?? '0') ?? 0;

//         //  final instrumentId = instrument.instrumentId;
//         //     final orderType = mapDropdownToOrderType(selectedOrderType.value);

//         //       final order = OrderRequestModel(
//         //       accountId: accountId,
//         //       // accountUuid: accountController.selectedAccountUuid.value,
//         //       instrumentId: instrumentId,
//         //       side: isBuy ? 1 : 2,
//         //       orderType: orderType.index,
//         //       orderQty: volume.value,
//         //       timeInForceId: selectedFillPolicy.value == 'Fill or Kill' ? 1 : 2,
//         //       orderPrice: price,
//         //       stopPrice: stopPrice,
//         //       limitPrice: limitPrice,
//         //     );

//         final result = await OrderService.placeOrder(order);
//         print("Created New Limit Order → Result: $result");
//       }

//       if (!stopOrderFound && stopPrice != orderPrice) {
//         print("No Stop Order found. Creating new Stop Order...");
//         final order = OrderRequestModel(
//           accountId: accountId,
//           // accountUuid: 'string',
//           // instrumentId: 1001,
//           instrumentId: instrumentId,
//           side: (side == 1) ? 2 : 1,
//           orderType: 3,
//           orderQty: positionQty,
//           timeInForceId: 1,
//           orderPrice: stopPrice,
//           stopPrice: 0,
//           limitPrice: 0,
//           related_position_id: positionId,
//           expiryDateTime: '',
//         );

//         final result = await OrderService.placeOrder(order);
//         print("Created New Stop Order → Result: $result");
//       }

//       // // final result = await _service.modifyLimit(body, token);

//       // // print("Modify success → $result");
//       Get.snackbar("Success", "Limit modified successfully");
//             Get.until((route) => route.isFirst);
//       MainTabView.selectedIndexNotifier.value = 2;
//       // //  Refresh pending orders
//       // final orderController = Get.find<OrderController>();
//       // await orderController.fetchPendingOrders(accountId);
//       // // orderController.pendingOrders.refresh();

//       // //  Refresh positions (this updates SL/TP in OrderTile)
//       // final positionsController = Get.find<PositionsController>();
//       // await positionsController.loadPositions();
//     } catch (e) {
//       Get.snackbar("Error", "Failed to modify order: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<Map<String, double?>> findTpAndSl({
//     required int accountId,
//     // required int status,
//     required int positionId,
//   }) async {
//     double? stopLoss;
//     double? takeProfit;
//     try {
//       debugPrint('Fetched Position of: $positionId');

//       final filteredOrders = await OrderService.fetchOrdersByRelatedPositionId(
//         accountId,
//         // status,
//         positionId,
//       );

//       final remainingOrders =
//           filteredOrders.where((order) => order.orderQty > 0).toList();

//       print("Found Remianing pending order: ${remainingOrders}");

//       for (var order in remainingOrders) {
//         if (order.orderType == 2) {
//           takeProfit = order.orderPrice;
//         } else if (order.orderType == 3) {
//           stopLoss = order.orderPrice;
//         }
//       }

//       // debugPrint('Stop Loss: $stopLoss');
//       // debugPrint('Take Profit: $takeProfit');

//       return {'stopLoss': stopLoss, 'takeProfit': takeProfit};
//     } catch (e, s) {
//       print("Error in findTpAndSl: $e");
//       print(s);
//       return {'stopLoss': null, 'takeProfit': null};
//     }
//   }

// }

// import 'dart:convert';

import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:netdania/app/getX/trading_getX.dart';
// import 'package:netdania/app/getX/order_getX.dart';
// import 'package:netdania/app/getX/position_getx.dart';
import 'package:netdania/app/models/limit_modify_model.dart';
import 'package:netdania/app/models/order_modify_model.dart';
import 'package:netdania/app/modules/main_tab/view/main_tab_view.dart';
import 'package:netdania/app/services/modify_position_services.dart';
import 'package:netdania/app/services/order_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:netdania/app/models/order_model.dart';
import 'package:flutter/foundation.dart';

class ModifyLimitController extends GetxController {
  final ModifyPositionServices _service = ModifyPositionServices();
  var isLoading = false.obs;
  final symbol = ''.obs;
  late TradingChartController tradingController;

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> modifyLimit({
    required int accountId,
    required int side,
    required int instrumentId,
    required double positionQty,
    required int positionId,
    required double orderPrice,
    required double stopPrice,
    required double limitPrice,
    required int timeInForceId,
    // required bool isBuy,
  }) async {
    final token = await getToken();
    if (token == null) {
      Get.snackbar('Error', 'No auth token found. Please login again.');
      return;
    }

    try {
      isLoading.value = true;

      final body = ModifyLimitModel(
        accountId: accountId,
        positionId: positionId,
        orderPrice: orderPrice,
        stopPrice: stopPrice,
        limitPrice: limitPrice,
        timeInForceId: timeInForceId,
      );
      // print("Payload for Modify Limit: ${body.toJson()}");

      final filteredOrders = await OrderService.fetchOrdersByRelatedPositionId(
        accountId,
        positionId,
      );

      print("Filtered Orders Count: ${filteredOrders.length}");
      print("Filtered Orders: $filteredOrders");

      bool limitOrderFound = false;
      bool stopOrderFound = false;

      for (final order in filteredOrders) {
        if (order.orderType == 2) {
          print("Limit Order → ID: ${order.pendingOrderId}");
          if (limitPrice == orderPrice) {
            continue;
          }
          String? expiryIso;
          final body = ModifyOrderModel(
            accountId: accountId,
            pendingOrderId: order.pendingOrderId,
            orderPrice: limitPrice,
            stopPrice: 0,
            limitPrice: 0,
            timeInForceId: timeInForceId,
            expiryDateTime: expiryIso,
          );

          final result = await _service.modifyOrder(body, token);
          print(
            "Modified Limit Order → ID: $order.pendingOrderId, Result: $result",
          );
          break;
        } else if (order.orderType == 3) {
          print("Stop Order → ID: ${order.pendingOrderId}");
          if (stopPrice == orderPrice) {
            continue;
          }
          String? expiryIso;
          final body = ModifyOrderModel(
            accountId: accountId,
            pendingOrderId: order.pendingOrderId,
            orderPrice: stopPrice,
            stopPrice: 0,
            limitPrice: 0,
            timeInForceId: timeInForceId,
            expiryDateTime: expiryIso,
          );

          final result = await _service.modifyOrder(body, token);
          print(
            "Modified Limit Order → ID: $order.pendingOrderId, Result: $result",
          );
          break;
        } else {
          print(
            "Other Order Type (${order.orderType}) → ID: ${order.pendingOrderId}",
          );
        }
      }
      String? expiryDateTime;
      if (!limitOrderFound && limitPrice != orderPrice) {
        print("No Limit Order found. Creating new Limit Order...");
        final order = OrderRequestModel(
          accountId: accountId,
          // accountUuid: 'string',
          // instrumentId: 1001,
          instrumentId: instrumentId,
          side: (side == 1) ? 2 : 1,
          orderType: 2,
          orderQty: positionQty,
          timeInForceId: 1,
          orderPrice: limitPrice,
          stopPrice: 0,
          limitPrice: 0,
          related_position_id: positionId,
          expiryDateTime: expiryDateTime,
        );
        //             final instrument = tradingController.getInstrumentByCode(symbol.value);
        //     if (instrument == null) {
        //       Get.snackbar('Error', 'Instrument not found for ${symbol.value}');
        //       return;
        //     }
        //        final ticker = tradingController.tickers[symbol.value.toUpperCase()];

        // final price =
        //         isBuy
        //             ? double.tryParse(ticker?['ask']?.toString() ?? '0') ?? 0
        //             : double.tryParse(ticker?['bid']?.toString() ?? '0') ?? 0;

        //  final instrumentId = instrument.instrumentId;
        //     final orderType = mapDropdownToOrderType(selectedOrderType.value);

        //       final order = OrderRequestModel(
        //       accountId: accountId,
        //       // accountUuid: accountController.selectedAccountUuid.value,
        //       instrumentId: instrumentId,
        //       side: isBuy ? 1 : 2,
        //       orderType: orderType.index,
        //       orderQty: volume.value,
        //       timeInForceId: selectedFillPolicy.value == 'Fill or Kill' ? 1 : 2,
        //       orderPrice: price,
        //       stopPrice: stopPrice,
        //       limitPrice: limitPrice,
        //     );

        final result = await OrderService.placeOrder(order);
        print("Created New Limit Order → Result: $result");
      }


      if (!stopOrderFound && stopPrice != orderPrice) {
        print("No Stop Order found. Creating new Stop Order...");
        final order = OrderRequestModel(
          accountId: accountId,

          instrumentId: instrumentId,
          side: (side == 1) ? 2 : 1,
          orderType: 3,
          orderQty: positionQty,
          timeInForceId: 1,
          orderPrice: stopPrice,
          stopPrice: 0,
          limitPrice: 0,
          related_position_id: positionId,
          expiryDateTime: expiryDateTime,
        );

        final result = await OrderService.placeOrder(order);
        print("Created New Stop Order → Result: $result");
      }

      // // final result = await _service.modifyLimit(body, token);

      // // print("Modify success → $result");
      Get.snackbar("Success", "Limit modified successfully");
      Get.until((route) => route.isFirst);
      MainTabView.selectedIndexNotifier.value = 2;
      // //  Refresh pending orders
      // final orderController = Get.find<OrderController>();
      // await orderController.fetchPendingOrders(accountId);
      // // orderController.pendingOrders.refresh();

      // //  Refresh positions (this updates SL/TP in OrderTile)
      // final positionsController = Get.find<PositionsController>();
      // await positionsController.loadPositions();
    } catch (e) {
      Get.snackbar("Error", "Failed to modify order: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, double?>> findTpAndSl({
    required int accountId,
    required int positionId,
  }) async {
    double? stopLoss;
    double? takeProfit;
    try {
      debugPrint('Fetched Position of: $positionId');

      final filteredOrders = await OrderService.fetchOrdersByRelatedPositionId(
        accountId,
        positionId,
      );

      final remainingOrders =
          filteredOrders.where((order) => order.orderQty > 0).toList();

      print("Found Remianing pending order: $remainingOrders");

      for (var order in remainingOrders) {
        if (order.orderType == 2) {
          takeProfit = order.orderPrice;
        } else if (order.orderType == 3) {
          stopLoss = order.orderPrice;
        }
      }

      // debugPrint('Stop Loss: $stopLoss');
      // debugPrint('Take Profit: $takeProfit');

      return {'stopLoss': stopLoss, 'takeProfit': takeProfit};
    } catch (e, s) {
      print("Error in findTpAndSl: $e");
      print(s);
      return {'stopLoss': null, 'takeProfit': null};
    }
  }
}