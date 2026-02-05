// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:netdania/app/config/theme/app_color.dart';
// import 'package:netdania/app/getX/order_getX.dart';
// import 'package:netdania/app/getX/trading_getX.dart';
// import 'package:netdania/app/models/instrument_model.dart';
// import 'package:netdania/app/modules/home/widgets/app_drawer.dart';
// import 'package:netdania/app/models/order_model.dart';

// class HistoryPage extends StatelessWidget {
//   final InstrumentModel instrument;
//   // final bool isExpanded;
//   // final VoidCallback onToggleExpand;

//   HistoryPage({
//     super.key,
//     required this.instrument,
//     //  required this.isExpanded,
//     //  required this.onToggleExpand
//   });
//   final TradingChartController tradingController =
//   //  Get.put(TradingChartController());
//   Get.put(TradingChartController());
//   @override
//   Widget build(BuildContext context) {
//     // final orderController = Get.put(OrderController());
//     final orderController = Get.find<OrderController>();
//     // final tradingController = Get.put(TradingChartController());
//     final tradingController = Get.put(TradingChartController());

//     return Scaffold(
//       // backgroundColor: Colors.white,
//       backgroundColor: AppColors.background,
//       appBar: _buildHistoryAppbar(context),
//       drawer: CommonDrawer(),
//       body: DefaultTabController(
//         length: 3,
//         child: Column(
//           children: [
//             const TabBar(
//               // indicatorColor: Colors.blue,
//               // dividerColor: Colors.transparent,
//               // labelColor: Colors.black,
//               // unselectedLabelColor: Colors.grey,
//               indicatorColor: AppColors.info,
//               dividerColor: AppColors.divider,
//               labelColor: AppColors.textPrimary,
//               unselectedLabelColor: AppColors.textSecondary,
//               tabs: [
//                 Tab(text: 'POSITIONS'),
//                 Tab(text: 'ORDERS'),
//                 Tab(text: 'DEAL'),
//               ],
//             ),
//             Expanded(
//               child: TabBarView(
//                 children: [
//                   _buildClosedPositionsTab(tradingController, orderController),
//                   _buildOrdersTab(orderController),
//                   _buildDealsTab(orderController),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   PreferredSizeWidget _buildHistoryAppbar(BuildContext context) {
//     final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
//     return AppBar(
//       // backgroundColor: Colors.white,
//       backgroundColor: AppColors.background,
//       elevation: 0,
//       title: Row(
//         children: [
//           // CommonMenuIcon(scaffoldKey: scaffoldKey),
//           const SizedBox(width: 8),
//           const Text(
//             "History",
//             style: TextStyle(
//               // color: Colors.black
//               color: AppColors.textPrimary,
//             ),
//           ),
//           const Spacer(),
//           PopupMenuButton<String>(
//             icon: const Icon(Icons.refresh),
//             onSelected: (value) {
//               if (value == 'refresh_all') {
//                 print('Refreshing all...');
//               }
//             },
//             itemBuilder:
//                 (context) => const [
//                   PopupMenuItem(
//                     value: 'All symbols',
//                     child: Text('All symbol'),
//                   ),
//                   PopupMenuItem(value: 'Symbol', child: Text('Symbol')),
//                 ],
//           ),
//           PopupMenuButton<String>(
//             icon: const Icon(Icons.swap_vert),
//             itemBuilder:
//                 (context) => const [
//                   PopupMenuItem(value: 'Symbol', child: Text('Symbol')),
//                   PopupMenuItem(value: 'Order', child: Text('Order')),
//                   PopupMenuItem(value: 'Volume', child: Text('Volume')),
//                   PopupMenuItem(value: 'Open Time', child: Text('Open Time')),
//                   PopupMenuItem(value: 'Close Time', child: Text('Close time')),
//                   PopupMenuItem(value: 'State', child: Text('State')),
//                 ],
//           ),
//           PopupMenuButton<String>(
//             icon: const Icon(Icons.calendar_month_rounded),
//             onSelected: (value) async {
//               if (value == 'pick_range') {
//                 final range = await showDateRangePicker(
//                   context: context,
//                   firstDate: DateTime(2022),
//                   lastDate: DateTime.now(),
//                 );
//                 if (range != null) {
//                   print('Picked range: ${range.start} - ${range.end}');
//                 }
//               }
//             },
//             itemBuilder:
//                 (context) => const [
//                   PopupMenuItem(value: 'today', child: Text('Today')),
//                   PopupMenuItem(value: 'Last Week', child: Text('Last Week')),
//                   PopupMenuItem(value: 'Last Month', child: Text('Last Month')),
//                   PopupMenuItem(
//                     value: 'Last 3 Month',
//                     child: Text('Last 3 Month'),
//                   ),
//                   PopupMenuItem(
//                     value: 'Custome Period',
//                     child: Text('Custome Period'),
//                   ),
//                 ],
//           ),
//         ],
//       ),
//     );
//   }

//   // CLOSED POSITIONS TAB
//   Widget _buildClosedPositionsTab(
//     TradingChartController tradingController,
//     OrderController orderController,
//   ) {
//     return Obx(() {
//       final closedOrders = orderController.closedOrders;

//       if (closedOrders.isEmpty) {
//         return _buildEmptyState('No positions yet');
//       }

//       return Column(
//         children: [
//           _buildSummarySection(closedOrders),
//           const Divider(height: 0),
//           Expanded(
//             child: ListView.builder(
//               itemCount: closedOrders.length,
//               itemBuilder: (context, index) {
//                 final order = closedOrders[index];
//                 // final entryPrice = order.price;
//                 final entryPrice = order.orderPrice;
//                 // final volume = order.volume;
//                 final volume = order.orderQty;
//                 final isBuy = order.side == 1;
//                 // final ticker =
//                 //     // tradingController.tickers[order.symbolCode.toUpperCase()];
//                 //     tradingController.tickers[order.instrumentId];
//                 // final ticker = tradingController.tickers[order.instrumentId.toString()];



//                 // final instrumentName = SymbolUtils.getInstrumentName(
//                 //   order.instrumentId,
//                 // );
//                 // final symbolKey = instrumentName.toUpperCase();
// final instrument = tradingController.getInstrument(order.instrumentId) ??
//                    InstrumentModel(
//                      instrumentId: order.instrumentId,
//                      name: 'UNKNOWN',
//                      code: 'UNKNOWN',
//                    );

// final symbolKey = instrument.code.toUpperCase();
//                 final ticker = tradingController.tickers[symbolKey];

//                 final currentPrice =
//                     double.tryParse(
//                       isBuy
//                           ? (ticker?['a']?.toString() ?? '0.0')
//                           : (ticker?['b']?.toString() ?? '0.0'),
//                     ) ??
//                     0.0;

//                 final profit =
//                     (currentPrice - entryPrice) * volume * (isBuy ? 1 : -1);
//                 final profitColor =
//                     profit > 0
//                         // ? Colors.blue
//                         // : profit < 0
//                         //     ? Colors.red
//                         //     : Colors.grey;
//                         ? AppColors.up
//                         : profit < 0
//                         ? AppColors.down
//                         : AppColors.neutral;

//                 return ListTile(
//                   // title: Text('${order.symbolCode} - ${_getSideLabel(order.side)}'),
//                   title: Text(
//                     instrument.code,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       // color: Colors.grey,
//                       color: AppColors.textSecondary,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   subtitle: Text(
//                     // '${order.volume} at ${order.price.toStringAsFixed(4)}',
//                     '${order.orderQty} at ${order.orderPrice.toStringAsFixed(4)}',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       // color: Colors.grey,
//                       color: AppColors.textSecondary,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   trailing: Text(
//                     '${profit >= 0 ? '+' : ''}${profit.toStringAsFixed(2)}',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                       color: profitColor,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       );
//     });
//   }

//   // // CLOSED POSITIONS TAB
//   // Widget _buildClosedPositionsTab(
//   //     TradingChartController tradingController,
//   //     OrderController orderController) {

//   //   final closeController = Get.find<CloseController>();

//   //   return Obx(() {
//   //     final closedPositions = closeController.closedPositions;

//   //     if (closedPositions.isEmpty) {
//   //       return _buildEmptyState('No closed positions yet');
//   //     }

//   //     return Column(
//   //       children: [
//   //         _buildSummarySection(closedPositions),
//   //         const Divider(height: 0),

//   //         Expanded(
//   //           child: ListView.builder(
//   //             itemCount: closedPositions.length,
//   //             itemBuilder: (context, index) {
//   //               final pos = closedPositions[index];

//   //               final isBuy = pos.side == 1 ? false : true; // your model: 1 = Sell, 2 = Buy
//   //               final entryPrice = pos.orderPrice;
//   //               final volume = pos.positionQty;

//   //               // Get ticker
//   //               final instrumentName =
//   //                   SymbolUtils.getInstrumentName(pos.instrumentId);

//   //               final symbolKey =
//   //                   PriceHelper.normalizeSymbol(instrumentName.toUpperCase());

//   //               final ticker = tradingController.tickers[symbolKey];

//   //               final currentPrice = ticker != null
//   //                   ? PriceHelper.getCurrentPrice(ticker, pos.side)
//   //                   : entryPrice;

//   //               final profit =
//   //                   (currentPrice - entryPrice) * volume * (isBuy ? 1 : -1);

//   //               final profitColor = profit > 0
//   //                   ? AppColors.up
//   //                   : profit < 0
//   //                       ? AppColors.down
//   //                       : AppColors.neutral;

//   //               return ListTile(
//   //                 title: Text(
//   //                   instrumentName,
//   //                   style: const TextStyle(
//   //                     color: AppColors.textPrimary,
//   //                     fontWeight: FontWeight.bold,
//   //                   ),
//   //                 ),
//   //                 subtitle: Text(
//   //                   '${pos.positionQty} at ${pos.orderPrice.toStringAsFixed(5)}',
//   //                   style: const TextStyle(
//   //                     color: AppColors.textSecondary,
//   //                     fontWeight: FontWeight.w500,
//   //                   ),
//   //                 ),
//   //                 trailing: Text(
//   //                   '${profit >= 0 ? '+' : ''}${profit.toStringAsFixed(2)}',
//   //                   style: TextStyle(
//   //                     fontSize: 16,
//   //                     fontWeight: FontWeight.bold,
//   //                     color: profitColor,
//   //                   ),
//   //                 ),
//   //               );
//   //             },
//   //           ),
//   //         ),
//   //       ],
//   //     );
//   //   });
//   // }

//   //  ORDERS TAB
//   Widget _buildOrdersTab(OrderController orderController) {
//     return Obx(() {
//       final orders = orderController.orderHistory;
//       if (orders.isEmpty) {
//         return _buildEmptyState('No orders yet');
//       }

//       return Column(
//         children: [
//           _buildOrderSummarySection(orders),
//           const Divider(height: 0),
//           Expanded(
//             child: ListView.builder(
//               itemCount: orders.length,
//               itemBuilder: (context, index) {
//                 final order = orders[index];
//                 final isBuy = order.side == 1;

//                 // final instrumentName = SymbolUtils.getInstrumentName(
//                 //   order.instrumentId,
//                 // );

//                 // final instrument =
//                 //     tradingController.getInstrument(order.instrumentId) ??
//                 //     InstrumentModel(
//                 //       instrumentId: order.instrumentId,
//                 //       name: instrumentName,
//                 //       code: instrumentName,
//                 //     );

//                 final instrument = tradingController.getInstrument(order.instrumentId) ??
//                    InstrumentModel(
//                      instrumentId: order.instrumentId,
//                      name: 'UNKNOWN',
//                      code: 'UNKNOWN',
//                    );

//                 return Column(
//                   children: [
//                     ListTile(
//                       // title: Text('${order.symbolCode} - ${order.orderType}'),
//                       // title: Text('${instrument.code} -${_getSideLabel(order.side)}'),
//                       title: RichText(
//                         text: TextSpan(
//                           children: [
//                             TextSpan(
//                               text: instrument.code,
//                               style: const TextStyle(
//                                 color: AppColors.textPrimary,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             TextSpan(
//                               // text: _getSideLabel(order.side),
//                               text: _getSideLabel(order.side),

//                               style: TextStyle(
//                                 color: isBuy ? AppColors.up : AppColors.down,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       subtitle: Row(
//                         children: [
//                           Text(
//                             // '${order.volume}/${order.volume} at market',
//                             '${order.orderQty}/${order.orderQty}, ${_getOrderTypeLabel(order.orderType)}',
//                             style: const TextStyle(
//                               fontSize: 14,
//                               // color: Colors.grey,
//                               color: AppColors.textSecondary,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     //  if (isExpanded)
//                     // Padding(
//                     //   padding: const EdgeInsets.symmetric(
//                     //     horizontal: 16.0,
//                     //     vertical: 8,
//                     //   ),
//                     //   child: Column(
//                     //     crossAxisAlignment: CrossAxisAlignment.start,
//                     //     children: [
//                     //       // Text('T/P: ${order.stopPrice.toStringAsFixed(4)}'),
//                     //       // Text('S/L: ${order.limitPrice.toStringAsFixed(4)}'),

//                     //       // Text('T/P: ${position.stopPrice.toStringAsFixed(4)}'),
//                     //       // Text('S/L: ${position.limitPrice.toStringAsFixed(4)}'),
//                     //     ],
//                     //   ),
//                     // ),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ],
//       );
//     });
//   }

//   //  DEALS TAB
//   Widget _buildDealsTab(OrderController orderController) {
//     return Obx(() {
//       final closedOrders = orderController.closedOrders;
//       // final closeOrders = orderController.closedOrdersList;
//       final orders = orderController.orders;

//       if (orders.isEmpty) {
//         return _buildEmptyState("No orders yet");
//       }

//       return Column(
//         children: [
//           _buildSummarySection(closedOrders),
//           const Divider(height: 0),
//           Expanded(
//             child: ListView.builder(
//               itemCount: orders.length,
//               itemBuilder: (context, index) {
//                 final order = orders[index];
//                 return ListTile(
//                   // title: Text('${order.symbolCode} - ${_getSideLabel(order.side)}'),
//                   title: Text(
//                     '${instrument.code} - ${_getSideLabel(order.side)}',
//                   ),

//                   subtitle: Text(
//                     // '${order.volume}/${order.volume} at market',
//                     '${order.orderQty} at market',

//                     style: const TextStyle(
//                       color: AppColors.textSecondary,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       );
//     });
//   }

//   // SUMMARIES + HELPERS
//   Widget _buildSummarySection(List<OrderRequestModel> closedOrders) {
//     double profit = 0.0;
//     double deposit = 500.00;
//     double swap = -1.23;
//     double commission = -3.50;

//     for (var order in closedOrders) {
//       // final entryPrice = order.price;
//       final entryPrice = order.orderPrice;

//       // final volume = order.volume;
//       final volume = order.orderQty;

//       final isBuy = order.side == 2;
//       final currentPrice = entryPrice + (isBuy ? 0.01 : -0.01);
//       profit += (currentPrice - entryPrice) * volume * (isBuy ? 1 : -1);
//     }

//     double balance = deposit + profit + swap + commission;

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _summaryRow("Profit: ", profit),
//           _summaryRow("Deposit: ", deposit),
//           _summaryRow("Swap: ", swap),
//           _summaryRow("Commission: ", commission),
//           _summaryRow("Balance:  ", balance),
//         ],
//       ),
//     );
//   }

//   Widget _buildOrderSummarySection(List<OrderRequestModel> orders) {
//     double totalVolume = 0.0;
//     double deposit = 500.00;
//     double swap = -2.0;
//     double commission = -4.5;

//     for (var order in orders) {
//       // totalVolume += order.volume;
//       totalVolume += order.orderQty;
//     }
//     double balance = deposit + swap + commission;

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _summaryRow("Total Orders: ", orders.length.toDouble()),
//           _summaryRow("Total Volume: ", totalVolume),
//           _summaryRow("Net Change: ", balance),
//         ],
//       ),
//     );
//   }

//   Widget _summaryRow(String label, double value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         children: [
//           Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
//           const SizedBox(width: 4),
//           Expanded(
//             child: LayoutBuilder(
//               builder: (context, constraints) {
//                 final dotCount = (constraints.maxWidth / 3).floor();
//                 return Text(
//                   List.generate(dotCount, (_) => '.').join(),
//                   maxLines: 1,
//                   overflow: TextOverflow.clip,
//                   style: const TextStyle(
//                     // color: Colors.grey
//                     color: AppColors.textSecondary,
//                   ),
//                 );
//               },
//             ),
//           ),
//           const SizedBox(width: 8),
//           Text(
//             value >= 0
//                 ? '+${value.toStringAsFixed(2)}'
//                 : value.toStringAsFixed(2),
//             style: TextStyle(
//               color:
//                   value > 0
//                       // ? Colors.blue
//                       // : value < 0
//                       //     ? Colors.red
//                       //     : Colors.grey,
//                       ? AppColors.up
//                       : value < 0
//                       ? AppColors.down
//                       : AppColors.neutral,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEmptyState(String text) {
//     return const Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.history,
//             size: 48,
//             //  color: Colors.grey
//             color: AppColors.textSecondary,
//           ),
//           SizedBox(height: 12),
//           Text(
//             'Empty history',
//             style: TextStyle(
//               fontSize: 16,
//               //  color: Colors.grey
//               color: AppColors.textSecondary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _getSideLabel(dynamic side) {
//     if (side is int) {
//       switch (side) {
//         case 1:
//           return 'Buy';
//         case 2:
//           return 'Zero';
//       }
//     } else if (side is String) {
//       if (side.toLowerCase() == 'buy') return 'Buy';
//       if (side.toLowerCase() == 'sell') return 'Sell';
//     }
//     return 'Unknown';
//   }

//   String _getOrderTypeLabel(dynamic type) {
//     if (type is int) {
//       switch (type) {
//         case 1:
//           return 'Market';
//         case 2:
//           return 'Limit';
//         case 3:
//           return 'Stop';
//         default:
//           return 'Unknown';
//       }
//     } else if (type is String) {
//       return type; 
//     }
//     return 'Unknown';
//   }
// }




// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_connect/sockets/src/socket_notifier.dart';
// import 'package:netdania/app/config/theme/app_color.dart';
// import 'package:netdania/app/getX/close_position_gettx.dart';
// import 'package:netdania/app/getX/order_getX.dart';
// import 'package:netdania/app/getX/trading_getX.dart';
// import 'package:netdania/app/models/instrument_model.dart';
// import 'package:netdania/app/modules/home/widgets/app_drawer.dart';
// import 'package:netdania/app/models/order_model.dart';
// import 'package:netdania/app/getX/account_getx.dart';

// class HistoryPage extends StatelessWidget {
//   final InstrumentModel instrument;
//   // final bool isExpanded;
//   // final VoidCallback onToggleExpand;

//   HistoryPage({
//     super.key,
//     required this.instrument,
//     //  required this.isExpanded,
//     //  required this.onToggleExpand
//   });
//   final TradingChartController tradingController =
//   //  Get.put(TradingChartController());
//   Get.put(TradingChartController());
//   @override
//   Widget build(BuildContext context) {
//     // final orderController = Get.put(OrderController());
//     final orderController = Get.find<OrderController>();
//     // final tradingController = Get.put(TradingChartController());
//     final tradingController = Get.put(TradingChartController());

//     return Scaffold(
//       // backgroundColor: Colors.white,
//       backgroundColor: AppColors.background,
//       appBar: _buildHistoryAppbar(context),
//       drawer: CommonDrawer(),
//       body: DefaultTabController(
//         length: 3,
//         child: Column(
//           children: [
//             const TabBar(
//               // indicatorColor: Colors.blue,
//               // dividerColor: Colors.transparent,
//               // labelColor: Colors.black,
//               // unselectedLabelColor: Colors.grey,
//               indicatorColor: AppColors.info,
//               dividerColor: AppColors.divider,
//               labelColor: AppColors.textPrimary,
//               unselectedLabelColor: AppColors.textSecondary,
//               tabs: [
//                 Tab(text: 'POSITIONS'),
//                 Tab(text: 'ORDERS'),
//                 Tab(text: 'DEAL'),
//               ],
//             ),
//             Expanded(
//               child: TabBarView(
//                 children: [
//                   _buildClosedPositionsTab(tradingController, orderController),
//                   _buildOrdersTab(orderController),
//                   _buildDealsTab(orderController),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   PreferredSizeWidget _buildHistoryAppbar(BuildContext context) {
//     final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
//     return AppBar(
//       // backgroundColor: Colors.white,
//       backgroundColor: AppColors.background,
//       elevation: 0,
//       title: Row(
//         children: [
//           // CommonMenuIcon(scaffoldKey: scaffoldKey),
//           const SizedBox(width: 8),
//           const Text(
//             "History",
//             style: TextStyle(
//               // color: Colors.black
//               color: AppColors.textPrimary,
//             ),
//           ),
//           const Spacer(),
//           PopupMenuButton<String>(
//             icon: const Icon(Icons.refresh),
//             onSelected: (value) {
//               if (value == 'refresh_all') {
//                 print('Refreshing all...');
//               }
//             },
//             itemBuilder:
//                 (context) => const [
//                   PopupMenuItem(
//                     value: 'All symbols',
//                     child: Text('All symbol'),
//                   ),
//                   PopupMenuItem(value: 'Symbol', child: Text('Symbol')),
//                 ],
//           ),
//           PopupMenuButton<String>(
//             icon: const Icon(Icons.swap_vert),
//             itemBuilder:
//                 (context) => const [
//                   PopupMenuItem(value: 'Symbol', child: Text('Symbol')),
//                   PopupMenuItem(value: 'Order', child: Text('Order')),
//                   PopupMenuItem(value: 'Volume', child: Text('Volume')),
//                   PopupMenuItem(value: 'Open Time', child: Text('Open Time')),
//                   PopupMenuItem(value: 'Close Time', child: Text('Close time')),
//                   PopupMenuItem(value: 'State', child: Text('State')),
//                 ],
//           ),
//           PopupMenuButton<String>(
//             icon: const Icon(Icons.calendar_month_rounded),
//             onSelected: (value) async {
//               if (value == 'pick_range') {
//                 final range = await showDateRangePicker(
//                   context: context,
//                   firstDate: DateTime(2022),
//                   lastDate: DateTime.now(),
//                 );
//                 if (range != null) {
//                   print('Picked range: ${range.start} - ${range.end}');
//                 }
//               }
//             },
//             itemBuilder:
//                 (context) => const [
//                   PopupMenuItem(value: 'today', child: Text('Today')),
//                   PopupMenuItem(value: 'Last Week', child: Text('Last Week')),
//                   PopupMenuItem(value: 'Last Month', child: Text('Last Month')),
//                   PopupMenuItem(
//                     value: 'Last 3 Month',
//                     child: Text('Last 3 Month'),
//                   ),
//                   PopupMenuItem(
//                     value: 'Custome Period',
//                     child: Text('Custome Period'),
//                   ),
//                 ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildClosedPositionsTab(
//     TradingChartController tradingController,
//     OrderController orderController,

//   ) {
//     // Fetch closed orders when building the tab
//     final accountController = Get.find<AccountController>();
//     final accountId = accountController.selectedAccountId.value;

//     // Fetch closed orders if not already loaded
//     if (orderController.closedOrders.isEmpty) {
//       orderController.fetchClosedOrders(accountId);
//     }

//     return Obx(() {
//       final closedOrders = orderController.closedOrders;

//       if (closedOrders.isEmpty) {
//         return _buildEmptyState('No closed positions yet');
//       }

//       return Column(
//         children: [
//           _buildSummarySection(closedOrders),
//           const Divider(height: 0),
//           Expanded(
//             child: ListView.builder(
//               itemCount: closedOrders.length,
//               itemBuilder: (context, index) {
//                 final order = closedOrders[index];
//                 final volume = order.orderQty;
//                 final isBuy =
//                     order.side == 'Buy' || order.side == 2; 
//                 print("Closed order details: ${order.instrumentId}");
//                 final instrument =
//                     tradingController.getInstrument(order.instrumentId) ??
//                     InstrumentModel(
//                       instrumentId: order.instrumentId,
//                       name: 'UNKNOWN',
//                       code: 'UNKNOWN',
//                     );

//                 final symbolKey = instrument.code.toUpperCase();
//                 final ticker = tradingController.tickers[symbolKey];

//                 final currentPrice =
//                     double.tryParse(
//                       isBuy
//                           ? (ticker?['a']?.toString() ?? '0.0')
//                           : (ticker?['b']?.toString() ?? '0.0'),
//                     ) ??
//                     0.0;

//                 // For closed orders, calculate profit based on settled P&L if available
//                 // Otherwise use the price difference calculation
//                 final profit =
//                     order.orderPrice > 0
//                         ? (currentPrice - order.orderPrice) *
//                             volume *
//                             (isBuy ? 1 : -1)
//                         : 0.0;

//                 final profitColor =
//                     profit > 0
//                         ? AppColors.up
//                         : profit < 0
//                         ? AppColors.down
//                         : AppColors.neutral;

//                 return ListTile(
//                   title: Text(
//                     '${instrument.code} - ${_getSideLabel(order.side)}',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       color: AppColors.textSecondary,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   subtitle: Text(
//                     order.orderPrice > 0
//                         ? '${order.orderQty} at ${order.orderPrice.toStringAsFixed(4)}'
//                         : '${order.orderQty} - Settled',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       color: AppColors.textSecondary,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   trailing: Text(
//                     '${profit >= 0 ? '+' : ''}${order.orderPrice.toStringAsFixed(2)}',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                       color: profitColor,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       );
//     });
//   }

//   // // CLOSED POSITIONS TAB
//   // Widget _buildClosedPositionsTab(
//   //     TradingChartController tradingController,
//   //     OrderController orderController) {

//   //   final closeController = Get.find<CloseController>();

//   //   return Obx(() {
//   //     final closedPositions = closeController.closedPositions;

//   //     if (closedPositions.isEmpty) {
//   //       return _buildEmptyState('No closed positions yet');
//   //     }

//   //     return Column(
//   //       children: [
//   //         _buildSummarySection(closedPositions),
//   //         const Divider(height: 0),

//   //         Expanded(
//   //           child: ListView.builder(
//   //             itemCount: closedPositions.length,
//   //             itemBuilder: (context, index) {
//   //               final pos = closedPositions[index];

//   //               final isBuy = pos.side == 1 ? false : true; // your model: 1 = Sell, 2 = Buy
//   //               final entryPrice = pos.orderPrice;
//   //               final volume = pos.positionQty;

//   //               // Get ticker
//   //               final instrumentName =
//   //                   SymbolUtils.getInstrumentName(pos.instrumentId);

//   //               final symbolKey =
//   //                   PriceHelper.normalizeSymbol(instrumentName.toUpperCase());

//   //               final ticker = tradingController.tickers[symbolKey];

//   //               final currentPrice = ticker != null
//   //                   ? PriceHelper.getCurrentPrice(ticker, pos.side)
//   //                   : entryPrice;

//   //               final profit =
//   //                   (currentPrice - entryPrice) * volume * (isBuy ? 1 : -1);

//   //               final profitColor = profit > 0
//   //                   ? AppColors.up
//   //                   : profit < 0
//   //                       ? AppColors.down
//   //                       : AppColors.neutral;

//   //               return ListTile(
//   //                 title: Text(
//   //                   instrumentName,
//   //                   style: const TextStyle(
//   //                     color: AppColors.textPrimary,
//   //                     fontWeight: FontWeight.bold,
//   //                   ),
//   //                 ),
//   //                 subtitle: Text(
//   //                   '${pos.positionQty} at ${pos.orderPrice.toStringAsFixed(5)}',
//   //                   style: const TextStyle(
//   //                     color: AppColors.textSecondary,
//   //                     fontWeight: FontWeight.w500,
//   //                   ),
//   //                 ),
//   //                 trailing: Text(
//   //                   '${profit >= 0 ? '+' : ''}${profit.toStringAsFixed(2)}',
//   //                   style: TextStyle(
//   //                     fontSize: 16,
//   //                     fontWeight: FontWeight.bold,
//   //                     color: profitColor,
//   //                   ),
//   //                 ),
//   //               );
//   //             },
//   //           ),
//   //         ),
//   //       ],
//   //     );
//   //   });
//   // }

//   //  ORDERS TAB
//   Widget _buildOrdersTab(OrderController orderController) {
//     return Obx(() {
//       final orders = orderController.orderHistory;
//       if (orders.isEmpty) {
//         return _buildEmptyState('No orders yet');
//       }

//       return Column(
//         children: [
//           _buildOrderSummarySection(orders),
//           const Divider(height: 0),
//           Expanded(
//             child: ListView.builder(
//               itemCount: orders.length,
//               itemBuilder: (context, index) {
//                 final order = orders[index];
//                 final isBuy = order.side == 1;

//                 // final instrumentName = SymbolUtils.getInstrumentName(
//                 //   order.instrumentId,
//                 // );

//                 // final instrument =
//                 //     tradingController.getInstrument(order.instrumentId) ??
//                 //     InstrumentModel(
//                 //       instrumentId: order.instrumentId,
//                 //       name: instrumentName,
//                 //       code: instrumentName,
//                 //     );

//                 final instrument =
//                     tradingController.getInstrument(order.instrumentId) ??
//                     InstrumentModel(
//                       instrumentId: order.instrumentId,
//                       name: 'UNKNOWN',
//                       code: 'UNKNOWN',
//                     );

//                 return Column(
//                   children: [
//                     ListTile(
//                       // title: Text('${order.symbolCode} - ${order.orderType}'),
//                       // title: Text('${instrument.code} -${_getSideLabel(order.side)}'),
//                       title: RichText(
//                         text: TextSpan(
//                           children: [
//                             TextSpan(
//                               text: instrument.code,
//                               style: const TextStyle(
//                                 color: AppColors.divider,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             TextSpan(
//                               // text: _getSideLabel(order.side),
//                               text: _getSideLabel(order.side),

//                               style: TextStyle(
//                                 color: isBuy ? AppColors.up : AppColors.down,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       subtitle: Row(
//                         children: [
//                           Text(
//                             // '${order.volume}/${order.volume} at market',
//                             '${order.orderQty}/${order.orderQty}, ${_getOrderTypeLabel(order.orderType)}',
//                             style: const TextStyle(
//                               fontSize: 14,
//                               // color: Colors.grey,
//                               color: AppColors.textSecondary,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     //  if (isExpanded)
//                     // Padding(
//                     //   padding: const EdgeInsets.symmetric(
//                     //     horizontal: 16.0,
//                     //     vertical: 8,
//                     //   ),
//                     //   child: Column(
//                     //     crossAxisAlignment: CrossAxisAlignment.start,
//                     //     children: [
//                     //       // Text('T/P: ${order.stopPrice.toStringAsFixed(4)}'),
//                     //       // Text('S/L: ${order.limitPrice.toStringAsFixed(4)}'),

//                     //       // Text('T/P: ${position.stopPrice.toStringAsFixed(4)}'),
//                     //       // Text('S/L: ${position.limitPrice.toStringAsFixed(4)}'),
//                     //     ],
//                     //   ),
//                     // ),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ],
//       );
//     });
//   }

//   //  DEALS TAB
//   Widget _buildDealsTab(OrderController orderController) {
//     return Obx(() {
//       final closedOrders = orderController.closedOrders;
//       // final closeOrders = orderController.closedOrdersList;
//       final orders = orderController.orders;

//       if (orders.isEmpty) {
//         return _buildEmptyState("No orders yet");
//       }

//       return Column(
//         children: [
//           _buildSummarySection(closedOrders),
//           const Divider(height: 0),
//           Expanded(
//             child: ListView.builder(
//               itemCount: orders.length,
//               itemBuilder: (context, index) {
//                 final order = orders[index];
//                 return ListTile(
//                   // title: Text('${order.symbolCode} - ${_getSideLabel(order.side)}'),
//                   title: Text(
//                     '${instrument.code} - ${_getSideLabel(order.side)}',
//                   ),

//                   subtitle: Text(
//                     // '${order.volume}/${order.volume} at market',
//                     '${order.orderQty} at market',

//                     style: const TextStyle(
//                       color: AppColors.textSecondary,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       );
//     });
//   }

//   // SUMMARIES + HELPERS
//   Widget _buildSummarySection(List<OrderRequestModel> closedOrders) {
//     double profit = 0.0;
//     double deposit = 500.00;
//     double swap = -1.23;
//     double commission = -3.50;

//     for (var order in closedOrders) {
//       // final entryPrice = order.price;
//       final entryPrice = order.orderPrice;

//       // final volume = order.volume;
//       final volume = order.orderQty;

//       final isBuy = order.side == 2;
//       final currentPrice = entryPrice + (isBuy ? 0.01 : -0.01);
//       profit += (currentPrice - entryPrice) * volume * (isBuy ? 1 : -1);
//     }

//     double balance = deposit + profit + swap + commission;

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _summaryRow("Profit: ", profit),
//           _summaryRow("Deposit: ", deposit),
//           _summaryRow("Swap: ", swap),
//           _summaryRow("Commission: ", commission),
//           _summaryRow("Balance:  ", balance),
//         ],
//       ),
//     );
//   }

//   Widget _buildOrderSummarySection(List<OrderRequestModel> orders) {
//     double totalVolume = 0.0;
//     double deposit = 500.00;
//     double swap = -2.0;
//     double commission = -4.5;

//     for (var order in orders) {
//       // totalVolume += order.volume;
//       totalVolume += order.orderQty;
//     }
//     double balance = deposit + swap + commission;

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _summaryRow("Total Orders: ", orders.length.toDouble()),
//           _summaryRow("Total Volume: ", totalVolume),
//           _summaryRow("Net Change: ", balance),
//         ],
//       ),
//     );
//   }

//   Widget _summaryRow(String label, double value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         children: [
//           Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
//           const SizedBox(width: 4),
//           Expanded(
//             child: LayoutBuilder(
//               builder: (context, constraints) {
//                 final dotCount = (constraints.maxWidth / 3).floor();
//                 return Text(
//                   List.generate(dotCount, (_) => '.').join(),
//                   maxLines: 1,
//                   overflow: TextOverflow.clip,
//                   style: const TextStyle(
//                     // color: Colors.grey
//                     color: AppColors.textSecondary,
//                   ),
//                 );
//               },
//             ),
//           ),
//           const SizedBox(width: 8),
//           Text(
//             value >= 0
//                 ? '+${value.toStringAsFixed(2)}'
//                 : value.toStringAsFixed(2),
//             style: TextStyle(
//               color:
//                   value > 0
//                       // ? Colors.blue
//                       // : value < 0
//                       //     ? Colors.red
//                       //     : Colors.grey,
//                       ? AppColors.up
//                       : value < 0
//                       ? AppColors.down
//                       : AppColors.neutral,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEmptyState(String text) {
//     return const Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.history,
//             size: 48,
//             //  color: Colors.grey
//             color: AppColors.textSecondary,
//           ),
//           SizedBox(height: 12),
//           Text(
//             'Empty history',
//             style: TextStyle(
//               fontSize: 16,
//               //  color: Colors.grey
//               color: AppColors.textSecondary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _getSideLabel(dynamic side) {
//     if (side is int) {
//       switch (side) {
//         case 1:
//           return 'Buy';
//         case 2:
//           return 'Zero';
//       }
//     } else if (side is String) {
//       if (side.toLowerCase() == 'buy') return 'Buy';
//       if (side.toLowerCase() == 'sell') return 'Sell';
//     }
//     return 'Unknown';
//   }

//   String _getOrderTypeLabel(dynamic type) {
//     if (type is int) {
//       switch (type) {
//         case 1:
//           return 'Market';
//         case 2:
//           return 'Limit';
//         case 3:
//           return 'Stop';
//         default:
//           return 'Unknown';
//       }
//     } else if (type is String) {
//       return type; 
//     }
//     return 'Unknown';
//   }
// }



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netdania/app/config/theme/app_color.dart';
import 'package:netdania/app/getX/order_getX.dart';
import 'package:netdania/app/getX/trading_getX.dart';
import 'package:netdania/app/models/instrument_model.dart';
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
      backgroundColor: AppColors.background,
      appBar: _buildHistoryAppbar(context),
      drawer: CommonDrawer(),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const TabBar(
              // indicatorColor: Colors.blue,
              // dividerColor: Colors.transparent,
              // labelColor: Colors.black,
              // unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.info,
              dividerColor: AppColors.divider,
              labelColor: AppColors.textPrimary,
              unselectedLabelColor: AppColors.textSecondary,
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
      backgroundColor: AppColors.background,
      elevation: 0,
      title: Row(
        children: [
          // CommonMenuIcon(scaffoldKey: scaffoldKey),
          const SizedBox(width: 8),
          const Text(
            "History",
            style: TextStyle(
              // color: Colors.black
              color: AppColors.textPrimary,
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
      orderController.fetchClosedOrders(accountId);
    }

    return Obx(() {
      final closedOrders = orderController.closedOrders;

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
                final qty = order.settledQty;
                // final isBuy =
                //     order.side == 'Buy' || order.side == 2; 
                // print("Closed order details: ${order.instrumentId}");
                final instrument =
                    tradingController.getInstrument(order.instrumentId) ??
                    InstrumentModel(
                      instrumentId: order.instrumentId,
                      name: 'UNKNOWN',
                      code: 'UNKNOWN',
                    );

                final symbolKey = instrument.code.toUpperCase();
                final ticker = tradingController.tickers[symbolKey];

                // final currentPrice =
                //     double.tryParse(
                //       isBuy
                //           ? (ticker?['a']?.toString() ?? '0.0')
                //           : (ticker?['b']?.toString() ?? '0.0'),
                //     ) ??
                //     0.0;

                // For closed orders, calculate profit based on settled P&L if available
                // Otherwise use the price difference calculation
                // final profit =
                //     order.orderPrice > 0
                //         ? (currentPrice - order.orderPrice) *
                //             volume *
                //             (isBuy ? 1 : -1)
                //         : 0.0;
                  final profit =order.settledPl;
                final profitColor =
                    profit > 0
                        ? AppColors.up
                        : profit < 0
                        ? AppColors.down
                        : AppColors.neutral;

                return ListTile(
                  title: Text(
                    '${instrument.code} - ${order.settledQty}',
                    // - ${_getSideLabel(order.side)}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // subtitle: Text(
                  //   order.orderPrice > 0
                  //       // ? '${order.orderQty} at ${order.orderPrice.toStringAsFixed(4)}'
                  //       // : '${order.orderQty} - Settled',
                  //       ? '${order.settledQty} at ${order.orderPrice.toStringAsFixed(4)}'
                  //       : '${order.settledQty} - Settled',
                  //   style: const TextStyle(
                  //     fontSize: 16,
                  //     color: AppColors.textSecondary,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  subtitle: Text(order.settlementDate,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),),
                  // trailing: Text(
                  //   '${profit >= 0 ? '+' : ''}${order.orderPrice.toStringAsFixed(2)}',
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 16,
                  //     color: profitColor,
                  //   ),
                  // ),
                trailing: Text('${order.settledPl}',
                   style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: profitColor,
                    ),),
                );
                
              },
            ),
          ),
          Divider(height: 1, thickness: 1, color: Colors.grey[300])
        ],
      );
    } );
  }

  // // CLOSED POSITIONS TAB
  // Widget _buildClosedPositionsTab(
  //     TradingChartController tradingController,
  //     OrderController orderController) {

  //   final closeController = Get.find<CloseController>();

  //   return Obx(() {
  //     final closedPositions = closeController.closedPositions;

  //     if (closedPositions.isEmpty) {
  //       return _buildEmptyState('No closed positions yet');
  //     }

  //     return Column(
  //       children: [
  //         _buildSummarySection(closedPositions),
  //         const Divider(height: 0),

  //         Expanded(
  //           child: ListView.builder(
  //             itemCount: closedPositions.length,
  //             itemBuilder: (context, index) {
  //               final pos = closedPositions[index];

  //               final isBuy = pos.side == 1 ? false : true; // your model: 1 = Sell, 2 = Buy
  //               final entryPrice = pos.orderPrice;
  //               final volume = pos.positionQty;

  //               // Get ticker
  //               final instrumentName =
  //                   SymbolUtils.getInstrumentName(pos.instrumentId);

  //               final symbolKey =
  //                   PriceHelper.normalizeSymbol(instrumentName.toUpperCase());

  //               final ticker = tradingController.tickers[symbolKey];

  //               final currentPrice = ticker != null
  //                   ? PriceHelper.getCurrentPrice(ticker, pos.side)
  //                   : entryPrice;

  //               final profit =
  //                   (currentPrice - entryPrice) * volume * (isBuy ? 1 : -1);

  //               final profitColor = profit > 0
  //                   ? AppColors.up
  //                   : profit < 0
  //                       ? AppColors.down
  //                       : AppColors.neutral;

  //               return ListTile(
  //                 title: Text(
  //                   instrumentName,
  //                   style: const TextStyle(
  //                     color: AppColors.textPrimary,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //                 subtitle: Text(
  //                   '${pos.positionQty} at ${pos.orderPrice.toStringAsFixed(5)}',
  //                   style: const TextStyle(
  //                     color: AppColors.textSecondary,
  //                     fontWeight: FontWeight.w500,
  //                   ),
  //                 ),
  //                 trailing: Text(
  //                   '${profit >= 0 ? '+' : ''}${profit.toStringAsFixed(2)}',
  //                   style: TextStyle(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.bold,
  //                     color: profitColor,
  //                   ),
  //                 ),
  //               );
  //             },
  //           ),
  //         ),
  //       ],
  //     );
  //   });
  // }

  //  ORDERS TAB
  Widget _buildOrdersTab(OrderController orderController) {
    return Obx(() {
      final orders = orderController.orderHistory;
      if (orders.isEmpty) {
        return _buildEmptyState('No orders yet');
      }

      return Column(
        children: [
          _buildOrderSummarySection(orders),
          const Divider(height: 0),
          Expanded(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final isBuy = order.side == 1;

                // final instrumentName = SymbolUtils.getInstrumentName(
                //   order.instrumentId,
                // );

                // final instrument =
                //     tradingController.getInstrument(order.instrumentId) ??
                //     InstrumentModel(
                //       instrumentId: order.instrumentId,
                //       name: instrumentName,
                //       code: instrumentName,
                //     );

                final instrument =
                    tradingController.getInstrument(order.instrumentId) ??
                    InstrumentModel(
                      instrumentId: order.instrumentId,
                      name: 'UNKNOWN',
                      code: 'UNKNOWN',
                    );

                return Column(
                  children: [
                    ListTile(
                      // title: Text('${order.symbolCode} - ${order.orderType}'),
                      // title: Text('${instrument.code} -${_getSideLabel(order.side)}'),
                      title: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: instrument.code,
                              style: const TextStyle(
                                color: AppColors.divider,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              // text: _getSideLabel(order.side),
                              text: _getSideLabel(order.side),

                              style: TextStyle(
                                color: isBuy ? AppColors.up : AppColors.down,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          Text(
                            // '${order.volume}/${order.volume} at market',
                            '${order.orderQty}/${order.orderQty}, ${_getOrderTypeLabel(order.orderType)}',
                            style: const TextStyle(
                              fontSize: 14,
                              // color: Colors.grey,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    //  if (isExpanded)
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(
                    //     horizontal: 16.0,
                    //     vertical: 8,
                    //   ),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       // Text('T/P: ${order.stopPrice.toStringAsFixed(4)}'),
                    //       // Text('S/L: ${order.limitPrice.toStringAsFixed(4)}'),

                    //       // Text('T/P: ${position.stopPrice.toStringAsFixed(4)}'),
                    //       // Text('S/L: ${position.limitPrice.toStringAsFixed(4)}'),
                    //     ],
                    //   ),
                    // ),
                  ],
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

                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
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

    // for (var order in closedOrders) {
    //   // final entryPrice = order.price;
    //   final entryPrice = order.orderPrice;

    //   // final volume = order.volume;
    //   final volume = order.orderQty;

    //   final isBuy = order.side == 2;
    //   final currentPrice = entryPrice + (isBuy ? 0.01 : -0.01);
    //   profit += (currentPrice - entryPrice) * volume * (isBuy ? 1 : -1);
    // }

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

  Widget _buildOrderSummarySection(List<OrderRequestModel> orders) {
    double totalVolume = 0.0;
    double deposit = 500.00;
    double swap = -2.0;
    double commission = -4.5;

    for (var order in orders) {
      // totalVolume += order.volume;
      totalVolume += order.orderQty;
    }
    double balance = deposit + swap + commission;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _summaryRow("Total Orders: ", orders.length.toDouble()),
          _summaryRow("Total Volume: ", totalVolume),
          _summaryRow("Net Change: ", balance),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 4),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final dotCount = (constraints.maxWidth / 3).floor();
                return Text(
                  List.generate(dotCount, (_) => '.').join(),
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                    // color: Colors.grey
                    color: AppColors.textSecondary,
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
                      ? AppColors.up
                      : value < 0
                      ? AppColors.down
                      : AppColors.neutral,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String text) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 48,
            //  color: Colors.grey
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 12),
          Text(
            'Empty history',
            style: TextStyle(
              fontSize: 16,
              //  color: Colors.grey
              color: AppColors.textSecondary,
            ),
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
          return 'Zero';
      }
    } else if (side is String) {
      if (side.toLowerCase() == 'buy') return 'Buy';
      if (side.toLowerCase() == 'sell') return 'Sell';
    }
    return 'Unknown';
  }

  String _getOrderTypeLabel(dynamic type) {
    if (type is int) {
      switch (type) {
        case 1:
          return 'Market';
        case 2:
          return 'Limit';
        case 3:
          return 'Stop';
        default:
          return 'Unknown';
      }
    } else if (type is String) {
      return type; 
    }
    return 'Unknown';
  }
}
