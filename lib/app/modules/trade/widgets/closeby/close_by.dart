// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:netdania/app/config/theme/app_color.dart';
// import 'package:netdania/app/getX/order_getX.dart';
// import 'package:netdania/app/getX/trading_getX.dart';
// import 'package:netdania/app/models/order_model.dart';
// import 'package:netdania/app/modules/order/controller/place_order_controller.dart';
// import 'package:netdania/app/modules/trade/components/order_tile.dart';
// import 'package:netdania/app/modules/trade/helper/symbol_utils.dart';
// import 'package:netdania/app/modules/trade/widgets/market/controller/market_controller.dart';
// import 'package:netdania/app/modules/trade/widgets/market/view/market_screen_view.dart';
// import 'package:netdania/utils/responsive_layout_helper.dart';

// // class CloseByPage extends GetxController {
// //   final RxDouble sl = 0.7.obs;
// //   final RxDouble tp = 0.5.obs;
// //   final RxDouble volume = 0.2.obs;

// //   final RxBool isSlInitialized = false.obs;
// //   final RxBool isTpInitialized = false.obs;

// //   final TextEditingController slController = TextEditingController();
// //   final TextEditingController tpController = TextEditingController();

// //   void updateSl(double sellPrice, {bool increment = true}) {
// //     if (!isSlInitialized.value) {
// //       sl.value = sellPrice;
// //       isSlInitialized.value = true;
// //     } else {
// //       sl.value = (sl.value + (increment ? 1 : -1)).clamp(0, double.infinity);
// //     }
// //     slController.text = sl.value.toStringAsFixed(2);
// //   }

// //   void updateTp(double buyPrice, {bool increment = true}) {
// //     if (!isTpInitialized.value) {
// //       tp.value = buyPrice;
// //       isTpInitialized.value = true;
// //     } else {
// //       tp.value = (tp.value + (increment ? 1 : -1)).clamp(0, double.infinity);
// //     }
// //     tpController.text = tp.value.toStringAsFixed(2);
// //   }

// //   void updateVolume(double change) {
// //     volume.value += change;
// //     if (volume.value < 0.01) volume.value = 0.01;
// //   }
// // }

// class CloseByPage extends StatelessWidget {
//   final String symbol;
//   final double entryPrice;
//  final OrderController orderController = Get.put(OrderController());
//   final List<OrderModel>orders;

//   CloseByPage({
//     super.key, 
//     required this.symbol,
//     required this.entryPrice, required this.orders});

//   final tradingController = Get.find<TradingChartController>();
//   final marketController = Get.put(MarketController());

//   @override
//   Widget build(BuildContext context) {
//     //  Retrieve arguments passed from OrderTile
//     final args = Get.arguments ?? {};
//     final OrderModel? selectedOrder = args['order'];
//     final double? currentPrice = args['currentPrice'];

//         final c = Get.isRegistered<PlaceOrderController>()
//       ? Get.find<PlaceOrderController>()
//       : Get.put(PlaceOrderController());

//     c.symbol.value = symbol;
//     // c.currentBuyPrice.value = currentBuyPrice;
//     // c.currentSellPrice.value = currentSellPrice;


// final side = args['side'] ?? 0;
// final volume = (args['volume'] ?? 0.0) as double;

// c.selectedOrderType.value = side == 2 ? 'Buy' : 'Sell';
// c.volume.value = volume;

//     return ResponsiveLayout(
//       mobile: _buildScaffold(context, c, const EdgeInsets.all(12)),
//     );
//   }

//   Widget _buildScaffold(
//     BuildContext context,PlaceOrderController c,EdgeInsets padding
//   ){
//      return Scaffold(
//       appBar: _buildSymbolAppbar(context,c),
//       backgroundColor: Colors.white,

//      body: Column(
//       children: [
//         _buildOrdersList()
//       ],
//      ),
//       bottomNavigationBar: _buildBottomBar(c),
//     );
//   }
  
  
// PreferredSizeWidget _buildSymbolAppbar(
//     BuildContext context, PlaceOrderController c) {
//   return AppBar(
//     // backgroundColor: Colors.white,
//     backgroundColor: AppColors.background,
//     elevation: 0.5,
//     titleSpacing: 0,
//     title: Padding(
//       padding: const EdgeInsets.only(left: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // First line
//           const Text(
//             'Close Position',
//             style: TextStyle(
//               // color: Colors.black,
//               color: AppColors.textPrimary,
//               fontWeight: FontWeight.bold,
//               fontSize: 18,
//             ),
//           ),
//           const SizedBox(height: 4),

//           // Second line: symbol, side, volume, and live price
//           Obx(() {
//             final ticker = c.tradingController.getTickerSafe(c.symbol.value);
//             final bid = double.tryParse(ticker?['bid']?.toString() ?? '0') ?? 0.0;
//             final ask = double.tryParse(ticker?['ask']?.toString() ?? '0') ?? 0.0;
//             // final price = (bid + ask) / 2;
//             final price = entryPrice;

//             // Side color & label — same as in OrderTile
//             // final side = _getSideLabel(c.selectedOrderType.value);
//             final side = _getSideLabel(c.selectedOrderType.value);
//             final isBuy = side == 'Buy';
//             final isSell = side == 'Sell';
//             // final color = isBuy ? Colors.blue : Colors.red;
//             final color = isBuy ? AppColors.up : AppColors.down;
//             return Row(
//               children: [
//                 // Symbol + Side + Volume
//                 RichText(
//                   text: TextSpan(
//                     children: [
                     
                      
//                       TextSpan(
//                         text: '${c.symbol.value}, ',
//                         style: const TextStyle(
//                             // color: Colors.black,
//                             color: AppColors.textPrimary,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14),
//                       ),

//                        TextSpan(
//                         text: '$side ',
//                         style: TextStyle(
//                             color: color,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14),
//                       ),

//                        TextSpan(
//                         text: c.volume.value.toStringAsFixed(2),
//                         style: TextStyle(
//                             color: color,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14),
//                       ),
                      
//                       TextSpan(
//                         text: entryPrice.toStringAsFixed(5),
//                         style: const TextStyle(
//                             // color: Colors.black,
//                             color: AppColors.textPrimary,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14),
//                       )
                     
//                     ],
//                   ),
//                 ),
//                 // const SizedBox(width: 8),
//                 // // Current price
//                 // Text(
//                 //   price == 0 ? '—' : '@ ${price.toStringAsFixed(5)}',
//                 //   style: const TextStyle(
//                 //     fontSize: 14,
//                 //     // color: Colors.grey,
//                 //     color: AppColors.textSecondary,
//                 //     fontWeight: FontWeight.w500,
//                 //   ),
//                 // ),
//               ],
//             );
//           }),
//         ],
//       ),
//     ),
//   );
// }


// String _getSideLabel(String orderType) {
//   if (orderType.toLowerCase().contains('buy')) return 'Buy';
//   if (orderType.toLowerCase().contains('sell')) return 'Sell';
//   return 'Unknown';
// }

  
// Widget _buildOrdersList() {
//   return Expanded(
//     child: ListView.builder(
//       itemCount: orders.length,
//       itemBuilder: (context, index) {
//         final o = orders[index];
//         final isBuy = o.side == 2;
//         // final profit = (o.currentPrice - o.price) * o.volume * (isBuy ? 1 : -1);
//         final symbolKey = PriceHelper.normalizeSymbol(o.symbolCode.toUpperCase());
//         return Obx((){
//            final ticker = tradingController.tickers[symbolKey];
//           double currentPrice = PriceHelper.getCurrentPrice(ticker, o.side);

   

//           final entryPrice = o.price;
//           final volume = o.volume;
//           final profit =
//               (currentPrice - entryPrice) * volume * (isBuy ? 1 : -1);
//           // (price-entryPrice) * volume*(isBuy ? 1 : -1);

//           final profitColor =
//               profit > 0
//                   // ? Colors.blue
//                   // : profit < 0
//                   // ? Colors.red
//                   // : Colors.grey;
//                     ? AppColors.up
//                     : profit < 0
//                     ? AppColors.down
//                     : AppColors.neutral;
//           // final isExpanded = _expandedOrderIndex == index;
//                final isExpanded =
//             orderController.expandedOrderIndex.value == index;

//           //     return OrderTile(
//           //   order: o,
//           //   index: index,
//           //   currentPrice: currentPrice, 
//           //   isExpanded: isExpanded,
//           //   onToggleExpand: () {
//           //     if (isExpanded) {
//           //       orderController.expandedOrderIndex.value = null;
//           //     } else {
//           //       orderController.expandedOrderIndex.value = index;
//           //     }
//           //   },
//           //   symbol: symbolKey,
//           // );
//            return ListTile(
//           dense: true,
//           contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//           title: Text(
//             '${o.symbolCode} ${isBuy ? "Buy" : "Sell"} ${o.volume.toStringAsFixed(2)}',
//             style: TextStyle(
//               color: isBuy ? AppColors.up : AppColors.down,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           subtitle: Row(
//             children: [
//               Text(entryPrice.toStringAsFixed(4),
//               style: const TextStyle(color: AppColors.textSecondary),
//               ),
//               Icon(
//                 Icons.arrow_right_alt_rounded,
//                 size: 14,
//                 color: AppColors.textSecondary,),
//               Text(
//                 '${o.price.toStringAsFixed(4)} ',
//                 style: const TextStyle(color: AppColors.textSecondary),
//               ),
            
//             ],
//           ),
//           trailing: Text(
//             '${profit >= 0 ? '+' : ''}${profit.toStringAsFixed(2)}',
//             style: TextStyle(
//               color: profit > 0
//                   ? AppColors.up
//                   : (profit < 0 ? AppColors.down : AppColors.textSecondary),
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         );
//         });
       
//       },
//     ),
//   );
// }

   
//   }

//   // ---------- Bottom Bar ----------
//   Widget _buildBottomBar(PlaceOrderController c) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       color: Colors.grey[200],
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//          GestureDetector(
//           onTap: () {},
//            child: Text('CLOSE BY',
//             style: TextStyle(
//               // color: Color(0xFFFFAB40),
//               color: AppColors.iconText,  
//               fontSize: 16,
//               fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,),
//          )
//         ],
//       ),
//     );
//   }

//   // ---------- Volume Button ----------
//   Widget _volumeButton(String label, double change) {
//     final marketController = Get.find<MarketController>();
//     return TextButton(
//       style: TextButton.styleFrom(
//         padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
//         minimumSize: const Size(20, 20),
//         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//       ),
//       onPressed: () => marketController.updateVolume(change),
//       child: Text(
//         label,
//         style: const TextStyle(
//           // color: Colors.blue,
//           color: AppColors.up,
//            fontSize: 12),
//       ),
//     );
//   }
//   // );
// // }






// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:netdania/app/models/order_model.dart';
// import 'package:netdania/app/getX/order_getX.dart';
// import 'package:netdania/app/config/theme/app_color.dart';

// class CloseByPage extends StatelessWidget {
//   final String symbol;
//   final double entryPrice;
//   final List<OrderModel> orders;

//   CloseByPage({
//     Key? key,
//     required this.symbol,
//     required this.entryPrice,
//     required this.orders,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final OrderModel selectedOrder = Get.arguments['order'];
//     final double currentPrice = Get.arguments['currentPrice'];

//     // Filter opposite side orders
//     final oppositeOrders = orders.where((o) => o.side != selectedOrder.side).toList();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Close By: $symbol'),
//       ),
//       body: oppositeOrders.isEmpty
//           ? Center(child: Text('No opposite orders available to close.'))
//           : ListView.builder(
//               itemCount: oppositeOrders.length,
//               itemBuilder: (context, index) {
//                 final order = oppositeOrders[index];

//                 // Calculate profit/loss for this pairing
//                 final profit = calculateProfit(
//                   entryPrice: selectedOrder.price,
//                   closePrice: order.price,
//                   volume: selectedOrder.volume < order.volume ? selectedOrder.volume : order.volume,
//                   side: selectedOrder.side,
//                 );

//                 return ListTile(
//                   title: Text('${_getSideLabel(order.side)} ${_formatVolume(order.volume)}'),
//                   subtitle: Text('Entry: ${order.price.toStringAsFixed(4)}'),
//                   trailing: Text(
//                     '${profit >= 0 ? '+' : ''}${profit.toStringAsFixed(2)}',
//                     style: TextStyle(
//                       color: profit > 0 ? AppColors.up : (profit < 0 ? AppColors.down : AppColors.textSecondary),
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   onTap: () {
//                     // Close By action (update order state)
//                     _closeBy(selectedOrder, order);
//                     Get.back();
//                   },
//                 );
//               },
//             ),
//     );
//   }

//   void _closeBy(OrderModel order1, OrderModel order2) {
//     // This is a simple example, implement your actual logic to close orders
//     print('Closing ${order1.symbolCode} order against ${order2.symbolCode} order');
//     // For example, update volumes or mark them as closed in controller
//     final orderController = Get.find<OrderController>();
    
//     double closedVolume = order1.volume < order2.volume ? order1.volume : order2.volume;

//     order1.volume -= closedVolume;
//     order2.volume -= closedVolume;

//     // Optional: remove fully closed orders
//     if (order1.volume <= 0) orderController.orders.remove(order1);
//     if (order2.volume <= 0) orderController.orders.remove(order2);

//     orderController.update(); // Refresh UI
//   }

//   double calculateProfit({
//     required double entryPrice,
//     required double closePrice,
//     required double volume,
//     required int side,
//   }) {
//     final direction = (side == 2) ? 1 : -1;
//     return (closePrice - entryPrice) * volume * direction;
//   }

//   String _getSideLabel(int side) {
//     return side == 1 ? 'Sell' : 'Buy';
//   }

//   String _formatVolume(double volume) {
//     if (volume == volume.roundToDouble()) return volume.toStringAsFixed(0);
//     if (volume * 10 == (volume * 10).roundToDouble()) return volume.toStringAsFixed(1);
//     if (volume * 100 == (volume * 100).roundToDouble()) return volume.toStringAsFixed(2);
//     return volume.toStringAsFixed(3);
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:netdania/app/models/order_model.dart';
// import 'package:netdania/app/getX/order_getX.dart';
// import 'package:netdania/app/config/theme/app_color.dart';

// class CloseByPage extends StatefulWidget {
//   final String symbol;
//   final double entryPrice;
//   final List<OrderModel> orders;

//   const CloseByPage({
//     Key? key,
//     required this.symbol,
//     required this.entryPrice,
//     required this.orders,
//   }) : super(key: key);

//   @override
//   State<CloseByPage> createState() => _CloseByPageState();
// }

// class _CloseByPageState extends State<CloseByPage> {
//   late OrderModel selectedOrder;
//   List<OrderModel> selectedOppositeOrders = [];

//   @override
//   void initState() {
//     super.initState();
//     selectedOrder = Get.arguments['order'];

//     // Automatically select opposite orders to maximize profit
//     _autoSelectBestOppositeOrders();
//   }

//   void _autoSelectBestOppositeOrders() {
//     final oppositeOrders =
//         widget.orders.where((o) => o.side != selectedOrder.side).toList();

//     // Sort orders by potential profit (descending)
//     oppositeOrders.sort((a, b) {
//       double profitA = _calculateProfitForCloseBy(a);
//       double profitB = _calculateProfitForCloseBy(b);
//       return profitB.compareTo(profitA);
//     });

//     double remainingVolume = selectedOrder.volume;

//     for (var order in oppositeOrders) {
//       if (remainingVolume <= 0) break;

//       selectedOppositeOrders.add(order);

//       double closedVolume = remainingVolume < order.volume
//           ? remainingVolume
//           : order.volume;
//       remainingVolume -= closedVolume;
//     }
//       setState(() {}); 
//   }

//   double _calculateProfitForCloseBy(OrderModel oppositeOrder) {
//     double closeVolume =
//         selectedOrder.volume < oppositeOrder.volume ? selectedOrder.volume : oppositeOrder.volume;
//     final direction = (selectedOrder.side == 2) ? 1 : -1;
//     return (oppositeOrder.price - selectedOrder.price) * closeVolume * direction;
//   }

//   @override
//   Widget build(BuildContext context,) {
//     final oppositeOrders =
//         widget.orders.where((o) => o.side != selectedOrder.side).toList();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Close By: ${widget.symbol}'),
//       ),
//       body: oppositeOrders.isEmpty
//           ? const Center(child: Text('No opposite orders available to close.'))
//           : Column(
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: oppositeOrders.length,
//                     itemBuilder: (context, index) {
//                       final order = oppositeOrders[index];
//                       final isBuy = order.side == 2;
//                       final profit = _calculateProfitForCloseBy(order);
//                       final isSelected = selectedOppositeOrders.contains(order);
//                       final entryPrice = order.price;
//                       return ListTile(
//                           dense: true,
//           contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//           title: Text(
//             // '${order.symbolCode} ${isBuy ? "Buy" : "Sell"} ${order.volume.toStringAsFixed(2)}',
//             '${order.symbolCode} ${isBuy ? "Buy" : "Sell"} ${_formatVolume(order.volume)}',

//             style: TextStyle(
//               color: isBuy ? AppColors.up : AppColors.down,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           subtitle: Row(
//             children: [
//               Text(entryPrice.toStringAsFixed(4),
//               style: const TextStyle(color: AppColors.textSecondary),
//               ),
//               Icon(
//                 Icons.arrow_right_alt_rounded,
//                 size: 14,
//                 color: AppColors.textSecondary,),
//               Text(
//                 '${entryPrice.toStringAsFixed(4)} ',
//                 style: const TextStyle(color: AppColors.textSecondary),
//               ),
            
//             ],
//           ),
//           trailing: Text(
//             '${profit >= 0 ? '+' : ''}${profit.toStringAsFixed(2)}',
//             style: TextStyle(
//               color: profit > 0
//                   ? AppColors.up
//                   : (profit < 0 ? AppColors.down : AppColors.textSecondary),
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//                         // title: Text(
//                         //     '${_getSideLabel(order.side)} ${_formatVolume(order.volume)}'),
//                         // subtitle:
//                         //     Text('Entry: ${order.price.toStringAsFixed(4)}'),
//                         // trailing: Row(
//                         //   mainAxisSize: MainAxisSize.min,
//                         //   children: [
//                         //     Text(
//                         //       '${profit >= 0 ? '+' : ''}${profit.toStringAsFixed(2)}',
//                         //       style: TextStyle(
//                         //         color: profit > 0
//                         //             ? AppColors.up
//                         //             : (profit < 0
//                         //                 ? AppColors.down
//                         //                 : AppColors.textSecondary),
//                         //         fontWeight: FontWeight.bold,
//                         //       ),
//                         //     ),
//                         //     // Checkbox(
//                         //     //   value: isSelected,
//                         //     //   onChanged: (val) {
//                         //     //     setState(() {
//                         //     //       if (val == true) {
//                         //     //         selectedOppositeOrders.add(order);
//                         //     //       } else {
//                         //     //         selectedOppositeOrders.remove(order);
//                         //     //       }
//                         //     //     });
//                         //     //   },
//                         //     // )
//                         //   ],
//                         // ),
//                       );
//                     },
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: selectedOppositeOrders.isEmpty
//                         ? null
//                         : _executeCloseBy ,
//                     child: const Text('Close By Selected Orders',
//                        style: TextStyle(
//               // color: Color(0xFFFFAB40),
//               color: AppColors.iconText,  
//               fontSize: 16,
//               fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }


//   // void _executeCloseBy() {
//   //   final orderController = Get.find<OrderController>();
//   //   double remainingVolume = selectedOrder.volume;

//   //   for (var oppositeOrder in selectedOppositeOrders) {
//   //     if (remainingVolume <= 0) break;

//   //     double closedVolume =
//   //         remainingVolume < oppositeOrder.volume ? remainingVolume : oppositeOrder.volume;

//   //     // Update volumes
//   //     selectedOrder.volume -= closedVolume;
//   //     oppositeOrder.volume -= closedVolume;
//   //     remainingVolume -= closedVolume;

//   //     // Remove fully closed opposite orders
//   //     if (oppositeOrder.volume <= 0) {
//   //       orderController.orders.remove(oppositeOrder);
//   //     }
//   //   }

//   //   // Remove selected order if fully closed
//   //   if (selectedOrder.volume <= 0) {
//   //     orderController.orders.remove(selectedOrder);
//   //   }

//   //   orderController.update(); // Refresh UI
//   //   Get.back(); // Close page
//   // }

//   String _getSideLabel(int side) => side == 1 ? 'Sell' : 'Buy';

//   String _formatVolume(double volume) {
//     if (volume == volume.roundToDouble()) return volume.toStringAsFixed(0);
//     if (volume * 10 == (volume * 10).roundToDouble()) return volume.toStringAsFixed(1);
//     if (volume * 100 == (volume * 100).roundToDouble()) return volume.toStringAsFixed(2);
//     return volume.toStringAsFixed(3);
//   }

// //   void _executeCloseBy() {
// //   final orderController = Get.find<OrderController>();
// //   double remainingVolume = selectedOrder.volume;

// //   for (var oppositeOrder in selectedOppositeOrders) {
// //     if (remainingVolume <= 0) break;

// //     double closedVolume =
// //         remainingVolume < oppositeOrder.volume ? remainingVolume : oppositeOrder.volume;

// //     // Update volumes
// //     selectedOrder.volume -= closedVolume;
// //     oppositeOrder.volume -= closedVolume;
// //     remainingVolume -= closedVolume;

// //     // Remove fully closed opposite orders from activeOrders
// //     if (oppositeOrder.volume <= 0) {
// //       orderController.activeOrders.remove(oppositeOrder);

// //       // Optional: persist removal
// //       final orderKey = orderController.getOrderKey(oppositeOrder);
// //       orderController.removedOrderIds.add(orderKey);
// //       orderController.saveRemovedOrders();
// //     }
// //   }

// //   // Remove selected order if fully closed
// //   if (selectedOrder.volume <= 0) {
// //     orderController.activeOrders.remove(selectedOrder);

// //     // Optional: persist removal
// //     final orderKey = orderController.getOrderKey(selectedOrder);
// //     orderController.removedOrderIds.add(orderKey);
// //     orderController.saveRemovedOrders();
// //   }

// //   orderController.update(); // Refresh any GetBuilder UI
// //   Get.back(); // Close CloseByPage
// // }

// void _executeCloseBy() {
//   final orderController = Get.find<OrderController>();
//   double remainingVolume = selectedOrder.volume;

//   for (var oppositeOrder in selectedOppositeOrders) {
//     if (remainingVolume <= 0) break;

//     double closedVolume = remainingVolume < oppositeOrder.volume
//         ? remainingVolume
//         : oppositeOrder.volume;

//     // Adjust volumes
//     selectedOrder.volume -= closedVolume;
//     oppositeOrder.volume -= closedVolume;
//     remainingVolume -= closedVolume;

//     // Remove fully closed opposite orders from activeOrders
//     if (oppositeOrder.volume <= 0) {
//       orderController.activeOrders.remove(oppositeOrder);
//       orderController.closeOrder(oppositeOrder); // move to closedOrders
//     }
//   }

//   // Remove the selected order if fully closed
//   if (selectedOrder.volume <= 0) {
//     orderController.activeOrders.remove(selectedOrder);
//     orderController.closeOrder(selectedOrder); // move to closedOrders
//   }

//   orderController.update(); // Refresh UI
//   Get.back(); // Close page
// }

// }


