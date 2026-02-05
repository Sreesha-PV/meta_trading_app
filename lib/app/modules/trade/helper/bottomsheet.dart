// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:netdania/app/config/theme/app_color.dart';
// import 'package:netdania/app/getX/trading_getX.dart';
// import 'package:netdania/app/modules/home/view/home_page.dart' as HomePage;
// import 'package:netdania/app/modules/order/view/place_order.dart';

// import 'package:netdania/screens/bottomnavigation/marketstat_page.dart';
// import 'package:netdania/screens/chart/candlestick_chart.dart';
// class OpenOrderBottomSheet extends StatelessWidget {
//   final String symbol;

//   const OpenOrderBottomSheet({super.key, required this.symbol});

//   @override
//   Widget build(BuildContext context) {
//     final TradingChartController tradingController =
//         Get.find<TradingChartController>();
//     // RxBool isSimpleViewMode = true.obs;

//     final textStyle = const TextStyle(
//       color: Colors.black,
//       fontWeight: FontWeight.bold,
//       fontFamily: 'Roboto',
//     );

//     return ListView(
//       children: [
//         ListTile(
//           // title: Text(
//           //   '$symbol : $symbol vs USD',
//           //   style: const TextStyle(
//           //     // color: Colors.grey,
//           //     color:AppColors.textSecondary,
//           //     fontWeight: FontWeight.bold,
//           //   ),
//           // ),

//           title:  Text(
//             '${instrument.code} ${_getSideLabel(order.side)} ${order.orderQty}',
//             style: const TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),,
//         ),

//         // -------- New Order ----------
//         ListTile(
//           dense: true,
//           title: Text('New Order', style: textStyle),
//           onTap: () {
//             final ticker = tradingController.getTicker(symbol);
//             final currentBuyPrice =
//                 double.tryParse(ticker?['a'] ?? '0.0') ?? 0.0;
//             final currentSellPrice =
//                 double.tryParse(ticker?['b'] ?? '0.0') ?? 0.0;

//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder:
//                     (_) => PlaceOrder(
//                       symbol: symbol,
//                       currentBuyPrice: currentBuyPrice,
//                       currentSellPrice: currentSellPrice,
//                     ),
//               ),
//             );
//           },
//         ),

//         // -------- Chart ----------
//         ListTile(
//           dense: true,
//           title: Text('Chart', style: textStyle),
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => 
//                 // LiveCandlestickChart(
//                 //   symbol: symbol
//                 //   ),
//                 CandlestickChartWidget()
//                 // builder: (_)=>LiveSymbolChart(symbol: symbol,)
//               ),
//             );
//           },
//         ),

//         // -------- Properties ----------
//         ListTile(
//           dense: true,
//           title: Text('Properties', style: textStyle),
//           onTap:
//               () => showDialog(
//                 context: context,
//                 builder:
//                     (_) => AlertDialog(
//                       title: const Text('Properties'),
//                       content: const Text('Feature coming soon.'),
//                       actions: [
//                         TextButton(
//                           onPressed: () => Navigator.pop(context),
//                           child: const Text('OK'),
//                         ),
//                       ],
//                     ),
//               ),
//         ),

//         // -------- Depth of Market ----------
//         ListTile(
//           dense: true,
//           title: Text('Depth of Market', style: textStyle),
//           onTap:
//               // () => 
//               // Navigator.push(
//               //   context,
//               //   MaterialPageRoute(builder: (_) => MarketScreen(symbol: symbol)),
//               // ),
//               (){}
//         ),

//         // -------- Market Statistics ----------
//         ListTile(
//           dense: true,
//           title: Text('Market Statistics', style: textStyle),
//           onTap:
//               () => Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => MarketstatisticsPage()),
//               ),
//         ),

//         // -------- Switch View Mode ----------
//         ListTile(
//           dense: true,
//           title: ValueListenableBuilder<bool>(
//             valueListenable: HomePage.isSimpleViewMode,
//             builder: (context, value, _) {
//               return Text(
//                 value ? 'Advanced view mode' : 'Simple view mode',
//                 style: textStyle,
//               );
//             },
//           ),
//           onTap: () {
//             // Toggle the shared ValueNotifier
//             HomePage.isSimpleViewMode.value = !HomePage.isSimpleViewMode.value;

//             // Close bottom sheet
//             Navigator.pop(context);

//             Text(
//               HomePage.isSimpleViewMode.value
//                   ? 'Switched to Simple View'
//                   : 'Switched to Advanced View',
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
