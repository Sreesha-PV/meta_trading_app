// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:netdania/app/getX/order_getX.dart';
// import 'package:netdania/app/modules/history/view/utils/side_label.dart';
// import 'package:netdania/provider/tradingchart_provider.dart';
// import 'empty_state.dart';
// import 'summary_section.dart';

// class ClosedPositionsTab extends StatelessWidget {
//   final OrderController orderController;
//   final TradingChartProvider tradingProvider;
//   // final TradingChartController tradingController;

//   const ClosedPositionsTab({
//     required this.orderController,
//     required this.tradingProvider,
//     // required this.tradingController,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final closedOrders = orderController.closedOrders;

//       if (closedOrders.isEmpty) {
//         return const EmptyState(text: 'No positions yet');
//       }

//       return Column(
//         children: [
//           SummarySection(orders: closedOrders),
//           const Divider(height: 0),
//           Expanded(
//             child: ListView.builder(
//               itemCount: closedOrders.length,
//               itemBuilder: (context, index) {
//                 final order = closedOrders[index];
//                 final entryPrice = order.price;
//                 final volume = order.volume;
//                 final isBuy = order.side == 2;
//                 final ticker =
//                     tradingProvider.tickers[order.symbolCode.toUpperCase()];
//                   // final ticker = tradingController.tickers[order.symbolCode.toUpperCase()];
//                 final currentPrice = double.tryParse(
//                       isBuy ? (ticker?['a'] ?? '0.0') : (ticker?['b'] ?? '0.0'),
//                     ) ??
//                     0.0;

//                 final profit =
//                     (currentPrice - entryPrice) * volume * (isBuy ? 1 : -1);

//                 final profitColor = profit > 0
//                     ? Colors.blue
//                     : profit < 0
//                         ? Colors.red
//                         : Colors.grey;

//                 return ListTile(
//                   title: Text('${order.symbolCode} - ${getSideLabel(order.side)}'),
//                   subtitle: Text(
//                     '${order.volume} at ${order.price.toStringAsFixed(4)}',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey,
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
// }
