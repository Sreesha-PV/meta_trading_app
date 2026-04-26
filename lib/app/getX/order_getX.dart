import 'package:get/get.dart';
import 'package:netdania/app/enum/ordertype_enum.dart';
import 'package:netdania/app/getX/account_getx.dart';
import 'package:netdania/app/getX/trading_getX.dart';
import 'package:netdania/app/models/order_get_model.dart';
import 'package:netdania/app/models/positions_model.dart';
import 'package:netdania/app/models/settlement_get_model.dart';
import 'package:netdania/app/modules/trade/helper/symbol_utils.dart';
import 'package:netdania/app/models/order_model.dart';
import 'package:netdania/app/services/order_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:netdania/app/config/theme/app_color.dart';

class OrderController extends GetxController {
  var activeOrders = <OrderRequestModel>[].obs;
  // var orderHistory = <OrderRequestModel>[].obs;
  var orderHistory = <PendingOrder>[].obs;
  // var closedOrders = <OrderRequestModel>[].obs;
  var closedOrders = <ClosedOrder>[].obs;

  var positionOrders = <Position>[].obs;
  // var pendingOrders = <PendingOrder>[].obs;
  final RxList<PendingOrder> pendingOrders = <PendingOrder>[].obs;
  var isLoaded = false.obs;

  var expandedPositionIndex = Rxn<int>();
  var expandedPendingIndex = Rxn<int>();

  final selectedOrderType = 'Market Execution'.obs;
  final selectedFillPolicy = 'Fill or Kill'.obs;

  final selectedExpiration = 'GTC'.obs;
  var expirationDate = Rxn<DateTime>();

  final selectedFilter = 1.obs;

  final RxnInt expandedOrderIndex = RxnInt();

  List<OrderRequestModel> get orders => activeOrders;
  // List<OrderRequestModel> get orderHistoryList => orderHistory;
  List<PendingOrder> get orderHistoryList => orderHistory;
  // List<OrderRequestModel> get closedOrdersList => closedOrders;
  List<ClosedOrder> get closedOrderList => closedOrders;

  RxList<Position> get orderFetchList => positionOrders;
  String _getOrderKeyFromSettlement(ClosedOrder settlement) {
    return '${settlement.accountId}_${settlement.settlementId}_${settlement.instrumentId}';
  }
  // void fetchOrders(int accountId) async {
  //   try {
  //     final fetchedOrders = await OrderService.fetchOrders(accountId);
  //     orders.assignAll(fetchedOrders);
  //   } catch (e) {
  //     print('Failed to fetch orders: $e');
  //   }
  // }

  Future<void> fetchOrders(int accountId, bool isBuy) async {
    try {
      await loadRemovedOrders();

      final fetched = await OrderService.fetchOrders(accountId);
      // final fetched = await OrderService.fetchOrders(accountId,status: 1);
      // final posi = await OrderService.positionOrders(accountId);
      // print("Fetched Orders: $fetched");
      pendingOrders.assignAll(fetched);

      final convertedOrders =
          fetched
              .where(
                (fetch) =>
                    !removedOrderIds.contains(_getOrderKeyFromFetched(fetch)),
              )
              .map((fetch) {
                final tradingController = Get.find<TradingChartController>();
                final instrument = tradingController.getInstrument(
                  fetch.instrumentId,
                );

                if (instrument == null) {
                  print('Instrument not found for ID: ${fetch.instrumentId}');
                  return null; // skip this order
                }

                final accountController = Get.find<AccountController>();
                final accountId = accountController.selectedAccountId.value;
                // final orderType = mapDropdownToOrderType(selectedOrderType.value);
                final orderType = mapDropdownToOrderType(
                  selectedOrderType.value,
                );

                final int timeInForceId =
                    orderType == OrderType.Market
                        ? mapFillPolicyToTIF(selectedFillPolicy.value)
                        : mapExpirationToTIF(selectedExpiration.value);

                String? expiryDateTime;

                if (timeInForceId == 4) {
                  final exp = expirationDate.value;
                  if (exp == null) {
                    Get.snackbar(
                      'Expiration required',
                      'Please select expiration date & time',
                    );
                    return null;
                  }
                  expiryDateTime = exp.toUtc().toIso8601String();
                }

                return OrderRequestModel(
                  accountId: fetch.accountId,
                  instrumentId: instrument.instrumentId,
                  // side: fetch.side,
                  side: isBuy ? 1 : 2,
                  orderType: orderType.index,
                  orderQty: fetch.orderQty,
                  timeInForceId: timeInForceId,
                  orderPrice: fetch.orderPrice,
                  stopPrice: 0.0,
                  limitPrice: 0.0,
                  // stopPrice: fetch.stopPrice,
                  // limitPrice: fetch.limitPrice,
                  expiryDateTime: expiryDateTime,
                );
              })
              .whereType<OrderRequestModel>()
              .toList();

      activeOrders.assignAll(convertedOrders);
    } catch (e) {
      print(" Failed to fetch orders: $e");
    }
  }

  Future<void> fetchClosedOrders(int accountId) async {
    try {
      await loadRemovedOrders();

      final fetched = await OrderService.fetchClosedOrders(accountId);

      final filtered =
          fetched
              .where(
                (co) =>
                    !removedOrderIds.contains(_getOrderKeyFromSettlement(co)),
              )
              .toList();

      closedOrders.assignAll(filtered);
    } catch (e) {
      print("Failed to fetch closed orders: $e");
    }
  }

  final _fetchedAccounts = <int>{};

  Future<void> fetchPendingOrders(int accountId) async {
    if (_fetchedAccounts.contains(accountId)) return;
    _fetchedAccounts.add(accountId);

    try {
      // final pending = await OrderService.fetchOrders(accountId,status: 1);
      final pending = await OrderService.fetchOrders(accountId);

      print("pending $pending");
      pendingOrders.assignAll(pending);
    } catch (e) {
      print("Failed to fetch pending orders: $e");
    }
  }






  Future<void> closePendingOrder(
    int pendingOrderId,
    int accountId,
    double orderQty,
  ) async {
    try {
      Get.dialog(
        Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Call your API to close the order
      // final response = await OrderService.closePendingOrder(pendingOrderId);
      final success = await OrderService.closePendingOrder(
        pendingOrderId,
        accountId,
        orderQty,
      );
      // Close loading dialog
      Get.back();


          if (success) {
            final closedOrder = pendingOrders.firstWhereOrNull(
              (order) => order.pendingOrderId == pendingOrderId,
            );

            if (closedOrder != null) {
              // Remove from pending
              pendingOrders.removeWhere(
                (order) => order.pendingOrderId == pendingOrderId,
              );

          
              orderHistory.insert(0, closedOrder);
            }

            Get.snackbar(
              'Success',
              'Order Cancelled',
              backgroundColor: AppColors.success,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
            );
          } else {
        // Show error message
        Get.snackbar(
          'Error',
          // response.message ??
          'Failed to close order',
          backgroundColor: AppColors.bearish,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3),
        );
      }
    } catch (e) {
      // Close loading dialog if still open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // Show error message
      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        backgroundColor: AppColors.bearish,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );

      print('Error closing order: $e');
    }
  }

  void addOrUpdatePendingOrder(PendingOrder order) {
    final index = pendingOrders.indexWhere(
      (o) => o.pendingOrderId == order.pendingOrderId,
    );
    if (order.orderQty == 0) {
      removePendingOrderById(order.pendingOrderId);
      return;
    }

    if (order.relatedPositionId != 0) {
      return;
    }

    if (index != -1) {
      pendingOrders[index] = order;
      print("✓ Pending order updated: ID ${order.pendingOrderId}");
    } else {
      pendingOrders.add(order);
      print("✓ Pending order added: ID ${order.pendingOrderId}");
    }
  }

  void removePendingOrderById(int pendingOrderId) {
    final initialLength = pendingOrders.length;
    pendingOrders.removeWhere((o) => o.pendingOrderId == pendingOrderId);
    if (pendingOrders.length < initialLength) {
      print("✓ Pending order removed: ID $pendingOrderId");
    }
  }

  void handleWebSocketUpdate(Map<String, dynamic> data) {
    try {
      final action = data['action'] as String?;

      switch (action) {
        case 'add':
          final orderData = data['order'];
          if (orderData != null) {
            final order = PendingOrder.fromJson(orderData);
            addOrUpdatePendingOrder(order);
          }
          break;

        case 'update':
          final pendingOrderId =
              data['pendingOrderId'] as int? ??
              data['order']?['pending_order_id'] as int?;
          if (pendingOrderId != null) {
            removePendingOrderById(pendingOrderId);
          }
          final orderData = data['order'];
          if (orderData != null) {
            final order = PendingOrder.fromJson(orderData);
            addOrUpdatePendingOrder(order);
          }
          break;

        case 'remove':
          final pendingOrderId =
              data['pendingOrderId'] as int? ??
              data['order']?['pending_order_id'] as int?;
          if (pendingOrderId != null) {
            removePendingOrderById(pendingOrderId);
          }
          break;

        default:
          print("⚠ Unknown WebSocket action: $action");
      }
    } catch (e) {
      print("✗ Error handling WebSocket update → $e");
    }
  }

  void handleBulkWebSocketUpdate(List<Map<String, dynamic>> updates) {
    for (var update in updates) {
      handleWebSocketUpdate(update);
    }
  }

  Future<void> refreshOrders(int accountId) async {
    await fetchOrders(accountId, true);
    // await loadPendingOrders(accountId,true);
  }

  //   Future<void> refreshOrders(int accountId, int status) async {

  //   await OrderService.fetchOrders(accountId, status: status);
  // }

  void clearOrdersCache() {
    pendingOrders.clear();
    activeOrders.clear();
    isLoaded.value = false;
    print("✓ Orders cache cleared");
  }

  String _getOrderKeyFromFetched(PendingOrder order) {
    return '${order.instrumentId}_${order.accountId}_${order.pendingOrderId}_${order.side}';
  }

  void addOrder(OrderRequestModel order) {
    activeOrders.add(order);
    // orderHistory.add(order);
    update();
  }

  List<PendingOrder> getPendingOrdersForPosition(Position position) {
    return pendingOrders
        .where(
          (po) =>
              po.instrumentId == position.instrumentId &&
              po.side == position.side &&
              (po.relatedPositionId == 0 ||
                  po.relatedPositionId == position.positionId),
        )
        .toList();
  }

  // void executePendingOrder(PendingOrder po, double executedQty) {
  //   pendingOrders.remove(po);

  //   positionOrders.add(
  //     Position(
  //       accountId: po.accountId,
  //       instrumentId: po.instrumentId,
  //       side: po.side,
  //       positionId: DateTime.now().millisecondsSinceEpoch,
  //       positionQty: executedQty,
  //       positionInitialQty: executedQty,
  //       orderPrice: po.orderPrice,
  //       refPendingOrderId: po.pendingOrderId,
  //       stopPrice: po.stopPrice,
  //       limitPrice: po.limitPrice,
  //       positionDate: po.createdAt
  //     ),
  //   );
  // }

  Set<String> removedOrderIds = {};

  void closeOrder(OrderRequestModel order) {
    activeOrders.remove(order);
    // closedOrders.add(order);

    final orderKey = _getOrderKey(order);
    removedOrderIds.add(orderKey);
    saveRemovedOrders();
  }

  void closePositionOrder(OrderRequestModel order) {
    if (orders.contains(order)) {
      orders.remove(order);
      // closedOrders.add(order);
    }
  }

  String _getOrderKey(OrderRequestModel order) {
    return '${order.instrumentId}_${order.accountId}_${order.orderQty}_${order.orderPrice}';
  }

  /// ---------------- PERSISTENCE ----------------
  Future<void> saveRemovedOrders() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('removed_orders', removedOrderIds.toList());
  }

  Future<void> loadRemovedOrders() async {
    final prefs = await SharedPreferences.getInstance();
    removedOrderIds = prefs.getStringList('removed_orders')?.toSet() ?? {};
  }

  /// ---------------- ORDER CLEANUP ----------------
  void removeProfitableActiveOrders(Map<String, Map<String, dynamic>> tickers) {
    final List<OrderRequestModel> toClose = [];

    for (var order in activeOrders) {
      final isBuy = order.side == 2; // side 2 = Buy
      final entryPrice = order.orderPrice;
      final qty = order.orderQty;

      final tradingController = Get.find<TradingChartController>();
      final instrument = tradingController.getInstrument(order.instrumentId);
      final symbol = instrument?.code ?? 'UNKNOWN';
      // final symbol = SymbolUtils.reverseInstrument(order.instrumentId);
      final symbolKey = PriceHelper.normalizeSymbol(symbol.toUpperCase());
      final ticker = tickers[symbolKey];
      if (ticker == null) continue;

      final currentPrice =
          double.tryParse(
            isBuy ? (ticker['a'] ?? '0.0') : (ticker['b'] ?? '0.0'),
          ) ??
          0.0;

      final profit = (currentPrice - entryPrice) * qty * (isBuy ? 1 : -1);

      if (profit > 0) {
        toClose.add(order);
      }
    }

    activeOrders.removeWhere((order) => toClose.contains(order));
    // closedOrders.addAll(toClose);
  }

  //   PendingOrder? getRelatedPendingOrder(Position position, List<PendingOrder> fetchOrder) {
  //   return fetchOrder.firstWhereOrNull((po) => po.relatedPositionId == position.positionId);
  // }

  PendingOrder? getRelatedPendingOrder(Position position) {
    
    if (pendingOrders.isEmpty) return null;

    final linkedOrder = pendingOrders.firstWhereOrNull(
      (po) =>
          po.relatedPositionId != 0 &&
          po.relatedPositionId == position.positionId,
    );
    if (linkedOrder != null) return linkedOrder;

    final fallbackOrder = pendingOrders.firstWhereOrNull(
      (po) =>
          po.instrumentId == position.instrumentId && po.side == position.side,
    );

    return fallbackOrder;
  }



  void removeLosingActiveOrders(Map<String, Map<String, dynamic>> tickers) {
    final List<OrderRequestModel> toClose = [];

    for (var order in activeOrders) {
      final isBuy = order.side == 1;
      final entryPrice = order.orderPrice;
      final qty = order.orderQty;

      // final symbol = SymbolUtils.reverseInstrument(order.instrumentId);
      // final symbolKey = PriceHelper.normalizeSymbol(symbol.toUpperCase());

      final tradingController = Get.find<TradingChartController>();
      final instrument = tradingController.getInstrument(order.instrumentId);
      final symbolKey = PriceHelper.normalizeSymbol(
        instrument?.code.toUpperCase() ?? '',
      );
      final ticker = tickers[symbolKey];
      if (ticker == null) continue;

      final currentPrice =
          double.tryParse(
            isBuy ? (ticker['a'] ?? '0.0') : (ticker['b'] ?? '0.0'),
          ) ??
          0.0;

      final profit = (currentPrice - entryPrice) * qty * (isBuy ? 1 : -1);

      if (profit < 0) {
        toClose.add(order);
      }
    }

    activeOrders.removeWhere((order) => toClose.contains(order));
    // closedOrders.addAll(toClose);
  }

  void clearOrders() {
    // closedOrders.addAll(activeOrders);
    activeOrders.clear();
  }

  void removeOrder(OrderRequestModel order) {
    activeOrders.remove(order);
  }

  OrderType mapDropdownToOrderType(String? dropdownValue) {
    switch (dropdownValue) {
      case 'Market Execution':
        return OrderType.Market;
      case 'Buy Limit':
      case 'Sell Limit':
        return OrderType.Limit;
      case 'Buy Stop':
      case 'Sell Stop':
        return OrderType.Stop;
      default:
        return OrderType.Market; // safe default
    }
  }

  int mapFillPolicyToTIF(String? policy) {
    switch (policy) {
      case 'Fill or Kill':
        return 11;
      case 'Immediate or Cancel':
        return 12;
      default:
        return 11;
    }
  }

  int mapExpirationToTIF(String? expiration) {
    switch (expiration) {
      case 'GTC':
        return 1;
      case 'GTF':
        return 2;
      case 'Today':
        return 5;
      case 'Specified day':
        return 3;
      case 'Specified':
        return 4;
      default:
        return 1;
    }
  }
}