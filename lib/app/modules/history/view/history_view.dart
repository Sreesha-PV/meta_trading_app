import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netdania/app/config/theme/app_color.dart';
import 'package:netdania/app/config/theme/app_textstyle.dart';
import 'package:netdania/app/getX/order_getX.dart';
import 'package:netdania/app/getX/trading_getX.dart';
import 'package:netdania/app/models/instrument_model.dart';
import 'package:netdania/app/models/order_get_model.dart';
import 'package:netdania/app/models/settlement_get_model.dart';
import 'package:netdania/app/modules/home/widgets/app_drawer.dart';
import 'package:netdania/app/models/order_model.dart';
import 'package:netdania/app/getX/account_getx.dart';

class HistoryPage extends StatelessWidget {
  final InstrumentModel instrument;
  // final bool isExpanded;
  // final VoidCallback onToggleExpand;

  HistoryPage({
    super.key,
    required this.instrument,
    //  required this.isExpanded,
    //  required this.onToggleExpand
  });

  final TradingChartController tradingController =
  //  Get.put(TradingChartController());
  Get.put(TradingChartController());

  @override
  Widget build(BuildContext context) {
    // final orderController = Get.put(OrderController());
    final orderController = Get.find<OrderController>();
    // final tradingController = Get.put(TradingChartController());
    final tradingController = Get.put(TradingChartController());

    return Scaffold(
      // backgroundColor: Colors.white,
      backgroundColor: AppColors.background(context),
      appBar: _buildHistoryAppbar(context),
      drawer: CommonDrawer(),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
             TabBar(
              indicatorColor: AppColors.info,
              dividerColor: AppColors.divider,
              labelColor: AppColors.textPrimary(context),
              unselectedLabelColor: AppColors.textSecondary(context),
              tabs: [
                Tab(text: 'POSITIONS'),
                Tab(text: 'ORDERS'),
                Tab(text: 'DEAL'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildClosedPositionsTab(tradingController, orderController),
                  _buildOrdersTab(orderController),
                  _buildDealsTab(orderController),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildHistoryAppbar(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return AppBar(
      // backgroundColor: Colors.white,
      backgroundColor: AppColors.background(context),
      elevation: 0,
      title: Row(
        children: [
          // CommonMenuIcon(scaffoldKey: scaffoldKey),
          const SizedBox(width: 8),
           Text(
            "History",
            style: TextStyle(
              // color: Colors.black
              color: AppColors.textPrimary(context),
            ),
          ),
          const Spacer(),
          PopupMenuButton<String>(
            icon: const Icon(Icons.refresh),
            onSelected: (value) {
              if (value == 'refresh_all') {
                print('Refreshing all...');
              }
            },
            itemBuilder:
                (context) => const [
                  PopupMenuItem(
                    value: 'All symbols',
                    child: Text('All symbol'),
                  ),
                  PopupMenuItem(value: 'Symbol', child: Text('Symbol')),
                ],
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.swap_vert),
            itemBuilder:
                (context) => const [
                  PopupMenuItem(value: 'Symbol', child: Text('Symbol')),
                  PopupMenuItem(value: 'Order', child: Text('Order')),
                  PopupMenuItem(value: 'Volume', child: Text('Volume')),
                  PopupMenuItem(value: 'Open Time', child: Text('Open Time')),
                  PopupMenuItem(value: 'Close Time', child: Text('Close time')),
                  PopupMenuItem(value: 'State', child: Text('State')),
                ],
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.calendar_month_rounded),
            onSelected: (value) async {
              if (value == 'pick_range') {
                final range = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2022),
                  lastDate: DateTime.now(),
                );
                if (range != null) {
                  print('Picked range: ${range.start} - ${range.end}');
                }
              }
            },
            itemBuilder:
                (context) => const [
                  PopupMenuItem(value: 'today', child: Text('Today')),
                  PopupMenuItem(value: 'Last Week', child: Text('Last Week')),
                  PopupMenuItem(value: 'Last Month', child: Text('Last Month')),
                  PopupMenuItem(
                    value: 'Last 3 Month',
                    child: Text('Last 3 Month'),
                  ),
                  PopupMenuItem(
                    value: 'Custome Period',
                    child: Text('Custome Period'),
                  ),
                ],
          ),
        ],
      ),
    );
  }
  Widget _buildClosedPositionsTab(
    TradingChartController tradingController,
    OrderController orderController,
  ) {
    // Fetch closed orders when building the tab
    final accountController = Get.find<AccountController>();
    final accountId = accountController.selectedAccountId.value;

    // Fetch closed orders if not already loaded
    if (orderController.closedOrders.isEmpty) {
      // orderController.fetchClosedPosition(accountId);
      orderController.fetchClosedOrders(accountId);
    }

    return Obx(() {
      final closedOrders = orderController.closedOrders;

      closedOrders.sort((a, b) {
        final dateA =
            DateTime.tryParse(a.settlementDate ?? '') ?? DateTime(1970);
        final dateB =
            DateTime.tryParse(b.settlementDate ?? '') ?? DateTime(1970);
        return dateB.compareTo(dateA);
      });
      if (closedOrders.isEmpty) {
        return _buildEmptyState('No closed positions yet');
      }

      return Column(
        children: [
          _buildSummarySection(closedOrders),
          const Divider(height: 0),
          Expanded(
            child: ListView.builder(
              itemCount: closedOrders.length,
              itemBuilder: (context, index) {
                final order = closedOrders[index];
                // final volume = order.orderQty;
                // final qty = order.settledQty;
                // final isBuy =
                //     order.side == 'Buy' || order.side == 2;
                print("Closed order details: ${order.instrumentId}");
                final instrument =
                    tradingController.getInstrument(order.instrumentId) ??
                    InstrumentModel(
                      instrumentId: order.instrumentId,
                      name: 'UNKNOWN',
                      code: 'UNKNOWN',
                      decimalPlaces: 0,
                    );

                final symbolKey = instrument.code.toUpperCase();
                final ticker = tradingController.tickers[symbolKey];

                final profit = order.settledPl;
                final profitColor =
                    profit > 0
                        ? AppColors.bullish
                        : profit < 0
                        ? AppColors.bearish
                        : AppColors.neutral;

                return ListTile(
                  title: Text(
                    '${instrument.code} - ${order.settledQty.toStringAsFixed(2)}',
                    // - ${_getSideLabel(order.side)}',
                    // style: const TextStyle(
                    //   fontSize: 14,
                    //   color: AppColors.textPrimary,
                    //   fontWeight: FontWeight.bold,
                    // ),
                  style: AppTextStyle.medium_700.textPrimary(context),

                  ),

                  subtitle: Text(
                    _formatSettlementDate(order.settlementDate),
                    // style: TextStyle(
                    //   fontWeight: FontWeight.bold,
                    //   fontSize: 14,
                    //   color: AppColors.textPrimary,
                    // ),
                  style: AppTextStyle.medium_700.textPrimary(context),

                  ),

                  trailing: Text(
                    '${profit.toStringAsFixed(2)}',
                    // style: TextStyle(
                    //   fontWeight: FontWeight.bold,
                    //   fontSize: 14,
                    //   color: profitColor,
                    // ),
                    style: AppTextStyle.medium_700.textPrimary(context),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  // //  ORDERS TAB
  // Widget _buildOrdersTab(OrderController orderController) {
  //   final accountController = Get.find<AccountController>();
  //   final accountId = accountController.selectedAccountId.value;

  //   return Obx(() {
  //     final orderHistory = orderController.orderHistory;
  //     if (orderHistory.isEmpty) {
  //       return _buildEmptyState('No orders yet');
  //     }

  //     return Column(
  //       children: [
  //         _buildOrderSummarySection(orderHistory),
  //         const Divider(height: 0),
  //         Expanded(
  //           child: ListView.builder(
  //             // itemCount: orders.length,
  //             itemCount: orderHistory.length,
  //             itemBuilder: (context, index) {
  //               // final order = orders[index];
  //               final order = orderHistory[index];
  //               final isBuy = order.side == 1;

  //               // final instrumentName = SymbolUtils.getInstrumentName(
  //               //   order.instrumentId,
  //               // );

  //               // final instrument =
  //               //     tradingController.getInstrument(order.instrumentId) ??
  //               //     InstrumentModel(
  //               //       instrumentId: order.instrumentId,
  //               //       name: instrumentName,
  //               //       code: instrumentName,
  //               //     );

  //               final instrument =
  //                   tradingController.getInstrument(order.instrumentId) ??
  //                   InstrumentModel(
  //                     instrumentId: order.instrumentId,
  //                     name: 'UNKNOWN',
  //                     code: 'UNKNOWN',
  //                     decimalPlaces: 0,
  //                   );

  //               return Column(
  //                 children: [
  //                   ListTile(
  //                     title: RichText(
  //                       text: TextSpan(
  //                         children: [
  //                           TextSpan(
  //                             text: instrument.code,
  //                             // style: const TextStyle(
  //                             //   color: AppColors.textPrimary,
  //                             //   fontWeight: FontWeight.bold,
  //                             // ),
  //                             style: AppTextStyle.body_700.textPrimary(context),
  //                           ),
  //                           TextSpan(
  //                             // text: _getSideLabel(order.side),
  //                             text: _getTypeLabel(order.orderType, order.side),

  //                             style: TextStyle(
  //                               color: isBuy ? AppColors.bullish : AppColors.bearish,
  //                               fontWeight: FontWeight.bold,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     subtitle: Text(
  //                       // '${order.volume}/${order.volume} at market',
  //                       '${order.orderQty}/${order.orderQty} at ${order.orderPrice}',
  //                       // style: const TextStyle(
  //                       //   fontSize: 14,
  //                       //   // color: Colors.grey,
  //                       //   color: AppColors.textSecondary,
  //                       //   fontWeight: FontWeight.bold,
  //                       // ),
  //                        style: AppTextStyle.medium_700.textSecondary(context),
  //                     ),

  //                     // trailing: Text(_formatSettlementDate(order.createdAt)),
  //                   ),
  //                 ],
  //               );
  //             },
  //           ),
  //         ),
  //       ],
  //     );
  //   });
  // }



Widget _buildOrdersTab(OrderController orderController) {
  return Obx(() {
    final closedOrders = orderController.closedOrders;
    if (closedOrders.isEmpty) {
      return _buildEmptyState('No closed orders yet');
    }

    return Column(
      children: [
        // _buildOrderSummarySection(closedOrders), // Optional summary for closed orders
        const Divider(height: 0),
        Expanded(
          child: ListView.builder(
            itemCount: closedOrders.length,
            itemBuilder: (context, index) {
              final order = closedOrders[index];

              final instrument = tradingController.getInstrument(order.instrumentId) ??
                  InstrumentModel(
                    instrumentId: order.instrumentId,
                    name: 'UNKNOWN',
                    code: 'UNKNOWN',
                    decimalPlaces: 0,
                  );

              final isBuy = order.side == 1;
              final profit = order.settledPl;
              final profitColor =
                  profit > 0 ? AppColors.bullish : profit < 0 ? AppColors.bearish : AppColors.neutral;

              return ListTile(
                title: Text(
                  '${instrument.code} - ${order.settledQty.toStringAsFixed(2)}',
                  style: AppTextStyle.medium_700.textPrimary(context),
                ),
                subtitle: Text(
                  _formatSettlementDate(order.settlementDate),
                  style: AppTextStyle.medium_700.textSecondary(context),
                ),
                trailing: Text(
                  '${profit.toStringAsFixed(2)}',
                  style: AppTextStyle.medium_700.copyWith(
                    color: profitColor,
                  ).textPrimary(context),
                ),
              );
            },
          ),
        ),
      ],
    );
  });
}
  //  DEALS TAB
  Widget _buildDealsTab(OrderController orderController) {
    return Obx(() {
      final closedOrders = orderController.closedOrders;
      // final closeOrders = orderController.closedOrdersList;
      final orders = orderController.orders;

      if (orders.isEmpty) {
        return _buildEmptyState("No orders yet");
      }

      return Column(
        children: [
          _buildSummarySection(closedOrders),
          const Divider(height: 0),
          Expanded(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return ListTile(
                  // title: Text('${order.symbolCode} - ${_getSideLabel(order.side)}'),
                  title: Text(
                    '${instrument.code} - ${_getSideLabel(order.side)}',
                  ),

                  subtitle: Text(
                    // '${order.volume}/${order.volume} at market',
                    '${order.orderQty} at market',

                    // style: const TextStyle(
                    //   color: AppColors.textSecondary,
                    //   fontWeight: FontWeight.bold,
                    // ),
                     style: AppTextStyle.medium_700.textPrimary(context),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  // SUMMARIES + HELPERS
  Widget _buildSummarySection(List<ClosedOrder> closedOrders) {
    double profit = 0.0;
    double deposit = 500.00;
    double swap = -1.23;
    double commission = -3.50;

    for (final o in closedOrders) {
      profit += o.settledPl;
      commission += o.commissionPaid ?? 0;
      swap += o.accumulatingStorage ?? 0;
    }

    double balance = deposit + profit + swap + commission;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _summaryRow("Profit: ", profit),
          _summaryRow("Deposit: ", deposit),
          _summaryRow("Swap: ", swap),
          _summaryRow("Commission: ", commission),
          _summaryRow("Balance:  ", balance),
        ],
      ),
    );
  }

  // // Widget _buildOrderSummarySection(List<OrderRequestModel> orders) {
  // Widget _buildOrderSummarySection(List<PendingOrder> orders) {
  //   double totalVolume = 0.0;
  //   double deposit = 500.00;
  //   double swap = -2.0;
  //   double commission = -4.5;

  //   for (var order in orders) {
  //     // totalVolume += order.volume;
  //     totalVolume += order.orderQty;
  //   }
  //   double balance = deposit + swap + commission;

  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         // _summaryRow("Total Orders: ", orders.length.toDouble()),
  //         // _summaryRow("Total Volume: ", totalVolume),
  //         // _summaryRow("Net Change: ", balance),
  //         _summaryRow('Filled', orders.length.toDouble()),
  //         _summaryRow('Cancelled', 0),
  //         _summaryRow('Total', orders.length.toDouble()),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildOrderSummarySection(List<PendingOrder> orders) {
  // Only consider closed orders (orderStatus == 0)
  final closedOrders = orders.where((o) => o.orderStatus == 0).toList();

  // Sum up settled profit if you have it in PendingOrder (else 0)
  // double totalProfit = closedOrders.fold(0, (sum, o) => sum + (o.settledPl ?? 0));

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _summaryRow('Total Closed Orders', closedOrders.length.toDouble()),
        // _summaryRow('Total Profit', totalProfit),
      ],
    ),
  );
}

  Widget _summaryRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(label, 
          // style: const TextStyle(fontWeight: FontWeight.bold)
           style: AppTextStyle.body_700.textPrimary(Get.context!),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final dotCount = (constraints.maxWidth / 3).floor();
                return Text(
                  List.generate(dotCount, (_) => '.').join(),
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style:  TextStyle(
                    // color: Colors.grey
                    color: AppColors.textSecondary(context),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value >= 0
                ? '+${value.toStringAsFixed(2)}'
                : value.toStringAsFixed(2),
            style: TextStyle(
              color:
                  value > 0
                      // ? Colors.blue
                      // : value < 0
                      //     ? Colors.red
                      //     : Colors.grey,
                      ? AppColors.bullish
                      : value < 0
                      ? AppColors.bearish
                      : AppColors.neutral,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String text) {
    return  Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 48,
            //  color: Colors.grey
            color: AppColors.textSecondary(Get.context!),
          ),
          SizedBox(height: 12),
          Text(
            'Empty history',
            // style: TextStyle(
            //   fontSize: 16,
            //   //  color: Colors.grey
            //   color: AppColors.textSecondary,
            // ),
            style: AppTextStyle.body2_700.textPrimary(Get.context!),

          ),
        ],
      ),
    );
  }

  String _getSideLabel(dynamic side) {
    if (side is int) {
      switch (side) {
        case 1:
          return 'Buy';
        case 2:
          return 'Sell';
      }
    } else if (side is String) {
      if (side.toLowerCase() == 'buy') return 'Buy';
      if (side.toLowerCase() == 'sell') return 'Sell';
    }
    return 'Unknown';
  }

  String _getTypeLabel(int type, int side) {
    String sideLabel;
    String typeLabel;

    switch (side) {
      case 1:
        sideLabel = 'buy';
        break;
      case 2:
        sideLabel = 'sell';
        break;
      default:
        sideLabel = 'Unknown';
    }

    switch (type) {
      case 2:
        typeLabel = 'limit';
        break;
      case 3:
        typeLabel = 'stop';
        break;
      default:
        typeLabel = 'Unknown';
    }

    return '$sideLabel $typeLabel';
  }

  // String _getOrderTypeLabel(dynamic type) {
  //   if (type is int) {
  //     switch (type) {
  //       case 1:
  //         return 'Market';
  //       case 2:
  //         return 'Limit';
  //       case 3:
  //         return 'Stop';
  //       default:
  //         return 'Unknown';
  //     }
  //   } else if (type is String) {
  //     return type;
  //   }
  //   return 'Unknown';
  // }

  String _formatSettlementDate(String? date) {
    if (date == null || date.isEmpty) return '';

    final dt = DateTime.tryParse(date);
    if (dt == null) return date;

    String two(int v) => v.toString().padLeft(2, '0');

    final local = dt.toLocal();

    return '${local.year}-${two(local.month)}-${two(local.day)} '
        '${two(local.hour)}:${two(local.minute)}';
  }
}
