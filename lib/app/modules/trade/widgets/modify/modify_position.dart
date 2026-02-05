// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// // import 'package:fl_chart/fl_chart.dart';
// import 'package:netdania/app/config/theme/app_color.dart';
// import 'package:netdania/app/getX/modify_limit_getx.dart';
// import 'package:netdania/app/models/instrument_model.dart';
// import 'package:netdania/app/models/positions_model.dart';
// import 'package:netdania/app/modules/order/controller/place_order_controller.dart';
// import 'package:netdania/utils/responsive_layout_helper.dart';
// import 'package:netdania/utils/tradingview_webchart.dart';

// /// ---------------- VIEW ----------------
// class ModifyPositionPage extends StatelessWidget {
//   final String symbol;
//   final double currentBuyPrice;
//   final double currentSellPrice;
//   // final double entryPrice;
//   final double orderPrice;
//   final double stopPrice;
//   final double limitPrice;
//   final Position position;
//   final InstrumentModel instrument;

//   const ModifyPositionPage({
//     super.key,
//     required this.symbol,
//     required this.currentBuyPrice,
//     required this.currentSellPrice,
//     // required this.entryPrice,
//     required this.orderPrice,
//     required this.stopPrice,
//     required this.limitPrice,
//     required this.position,
//     required this.instrument,
//   });

//   double safeDouble(dynamic value) {
//     if (value is double) return value;
//     if (value is int) return value.toDouble();
//     if (value is String) return double.tryParse(value) ?? 0.0;
//     return 0.0;
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final c = Get.put(PlaceOrderController());

//     final c =
//         Get.isRegistered<PlaceOrderController>(tag: symbol)
//             ? Get.find<PlaceOrderController>(tag: symbol)
//             : Get.put(PlaceOrderController(), tag: symbol);

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       c.symbol.value = symbol;
//       c.currentBuyPrice.value = currentBuyPrice;
//       c.currentSellPrice.value = currentSellPrice;

//       c.volume.value = position.positionQty;
//       c.price.value = orderPrice;
//       c.sl.value = stopPrice;
//       c.tp.value = limitPrice;

//       c.slController.text = stopPrice.toStringAsFixed(5);
//       c.tpController.text = limitPrice.toStringAsFixed(5);
//       c.priceController.text = orderPrice.toStringAsFixed(5);
//     });

//     // c.symbol.value = symbol;
//     // c.currentBuyPrice.value = currentBuyPrice;
//     // c.currentSellPrice.value = currentSellPrice;

//     // Set all initial values from position
//     c.symbol.value = symbol;
//     c.currentBuyPrice.value = currentBuyPrice;
//     c.currentSellPrice.value = currentSellPrice;
//     c.volume.value =
//         position
//             .positionQty; // <-- This ensures the AppBar shows correct volume
//     c.price.value = orderPrice; // Optional: if you want order price synced
//     c.sl.value = stopPrice; // Optional: sync SL
//     c.tp.value = limitPrice; // Optional: sync TP

//     // c.setSymbol(symbol);
//     // c.currentBuyPrice.value = currentBuyPrice;
//     // c.currentSellPrice.value = currentSellPrice;

//     return ResponsiveLayout(
//       mobile: _buildScaffold(context, c, const EdgeInsets.all(12)),
//       tablet: _buildScaffold(
//         context,
//         c,
//         const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
//       ),
//       desktop: _buildDesktopLayout(context, c),
//     );
//   }

//   /// ---------------- MOBILE / TABLET ----------------
//   Widget _buildScaffold(
//     BuildContext context,
//     PlaceOrderController c,
//     EdgeInsets padding,
//   ) {
//     return Scaffold(
//       // backgroundColor: Colors.white,
//       backgroundColor: AppColors.background,
//       appBar: _buildAppBar(context, c),
//       body: Padding(
//         padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
//         child: _buildOrderBody(context, c, padding),
//       ),
//     );
//   }

//   /// ---------------- DESKTOP ----------------
//   Widget _buildDesktopLayout(BuildContext context, PlaceOrderController c) {
//     return Scaffold(
//       // backgroundColor: Colors.white,
//       backgroundColor: AppColors.background,
//       appBar: _buildAppBar(context, c),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
//         child: Row(
//           children: [
//             Expanded(
//               flex: 2,
//               child: _buildOrderBody(context, c, EdgeInsets.zero),
//             ),
//             const SizedBox(width: 24),
//             Expanded(
//               flex: 3,
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[50],
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.grey[300]!),
//                 ),
//                 child: Obx(() {
//                   final data = c.tradingController.getPriceHistory(
//                     c.symbol.value,
//                   );
//                   if (data.isEmpty) {
//                     return const Center(
//                       child: Text("Waiting for live data..."),
//                     );
//                   }
//                   return Text('Chart');
//                   // return LineChartWidget(priceHistory: data);
//                 }),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// ---------------- COMMON BODY ----------------
//   Widget _buildOrderBody(
//     BuildContext context,
//     PlaceOrderController c,
//     EdgeInsets padding,
//   ) {
//     return Padding(
//       padding: padding,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Transform.translate(offset: Offset(0, -4),
//           // child: Container(height: 1,color: Colors.grey[300]),),
//           // const SizedBox(height: 8),
//           const SizedBox(height: 10),

//           // Obx(() {
//           //   // final ticker = c.tradingController.getTicker(c.symbol.value);
//           //   // final ticker = c.tradingController.getTickerSafe(symbol);
//           //   // final sell =
//           //   //     double.tryParse(ticker?['bid']?.toString() ?? '0') ?? 0;
//           //   // final buy = double.tryParse(ticker?['ask']?.toString() ?? '0') ?? 0;
//           //   // final color = c.tradingController.isPriceUp ? Colors.blue : Colors.red;
//           //   final color =
//           //       c.tradingController.isPriceUp ? AppColors.up : AppColors.down;

//           //       final instrumentName = SymbolUtils.getInstrumentName(
//           //     position.instrumentId,
//           //   );

//           //        final symbolKey = PriceHelper.normalizeSymbol(instrumentName);
//           //   final ticker = c.tradingController.tickers[symbolKey];

//           //   final sell = safeDouble(ticker?['bid']);
//           //   final buy = safeDouble(ticker?['ask']);
//           //   return Row(
//           //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           //     children: [
//           //       _formattedPrice(sell, color),
//           //       _formattedPrice(buy, color),
//           //     ],
//           //   );
//           // }),
//           Obx(() {
//             final symbolKey = instrument.code.toUpperCase();
//             final ticker = c.tradingController.getTickerSafe(symbolKey);

//             if (ticker == null) {
//               return const Text('—');
//             }

//             final sell = safeDouble(ticker['bid']);
//             final buy = safeDouble(ticker['ask']);

//             final isUp = c.tradingController.isPriceUpForSymbol(symbolKey);
//             final color = isUp ? AppColors.up : AppColors.down;

//             return Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _formattedPrice(sell, color),
//                 _formattedPrice(buy, color),
//               ],
//             );
//           }),

//           const SizedBox(height: 10),
//           _buildSLTPRow(c),
//           const SizedBox(height: 10),
//           _buildFillPolicyDropdown(c, context),
//           const SizedBox(height: 10),
//           Expanded(
//             child: Obx(() {
//               // final prices = c.tradingController.getPriceHistory(
//               //   c.symbol.value,
//               // );
//               final prices = c.tradingController.getPriceHistory(symbol);

//               // if (prices.isEmpty) {
//               //   return const Center(child: Text("Waiting for live data..."));
//               // }
//               // return LineChartWidget(priceHistory: prices);
//               // return Text('Chart');
//               return TradingViewWeb(symbol: symbol,);
//             }),
//           ),
//           const SizedBox(height: 10),
//           _buildBottomButtons(c),
//         ],
//       ),
//     );
//   }

//   /// ---------------- UI PARTS ----------------
//   PreferredSizeWidget _buildAppBar(
//     BuildContext context,
//     PlaceOrderController c,
//   ) {
//     return AppBar(
//       // backgroundColor: Colors.white,
//       backgroundColor: AppColors.background,
//       // automaticallyImplyLeading: false,
//       title: Column(
//         children: [
//           Row(
//             children: [
//               Text(
//                 'Modify position',
//                 style: const TextStyle(
//                   // color: Colors.black,
//                   color: AppColors.textPrimary,
//                   fontSize: 18,
//                 ),
//               ),
//             ],
//           ),

//           // Row(
//           //   children: [
//           //     // IconButton(
//           //     //   icon: const Icon(Icons.arrow_back, color: Colors.black),
//           //     //   onPressed: () => Navigator.pop(context),
//           //     // ),
//           //     Text(c.symbol.value,
//           //         style: const TextStyle(
//           //           // color: Colors.black,
//           //           color: AppColors.textPrimary,
//           //            fontSize: 18)),
//           //     const Spacer(),
//           //     const Icon(Icons.refresh, color: AppColors.textPrimary),
//           //   ],
//           // ),
//           Obx(() {
//             // final ticker = c.tradingController.getTickerSafe(c.symbol.value);
//             final ticker = c.tradingController.getTickerSafe(symbol);

//             final bid =
//                 double.tryParse(ticker?['bid']?.toString() ?? '0') ?? 0.0;
//             final ask =
//                 double.tryParse(ticker?['ask']?.toString() ?? '0') ?? 0.0;
//             // final price = (bid + ask) / 2;
//             // final price = entryPrice;
//             // final price = orderPrice;

//             // Side color & label — same as in OrderTile
//             // final side = _getSideLabel(c.selectedOrderType.value);
//             // final side = _getSideLabel(c.selectedOrderType.value);
//             final side = _getSideLabel(position.side);
//             return Row(
//               children: [
//                 RichText(
//                   text: TextSpan(
//                     children: [
//                       TextSpan(
//                         text: '$side ',
//                         style: TextStyle(
//                           color: AppColors.textSecondary,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14,
//                         ),
//                       ),
//                       TextSpan(
//                         // text: c.volume.value.toStringAsFixed(2),
//                         // text: position.positionQty.toStringAsFixed(2),
//                         text: _formatVolume(position.positionQty),
//                         style: TextStyle(
//                           color: AppColors.textSecondary,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14,
//                         ),
//                       ),

//                       TextSpan(
//                         // text: '${c.symbol.value}, ',
//                         text: instrument.code,
//                         style: const TextStyle(
//                           // color: Colors.black,
//                           color: AppColors.textSecondary,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14,
//                         ),
//                       ),
//                       TextSpan(
//                         text: orderPrice.toStringAsFixed(5),
//                         // text: orderPrice.toString(),
//                         style: const TextStyle(
//                           // color: Colors.black,
//                           color: AppColors.textSecondary,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 //     const SizedBox(width: 8),
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
//     );
//   }

//   Widget _buildSLTPRow(PlaceOrderController c) {
//     return Row(
//       children: [
//         Expanded(
//           child: _priceAdjuster(
//             c,
//             "SL",
//             AppColors.down,
//             c.adjustSl,
//             c.slController,
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: _priceAdjuster(
//             c,
//             "TP",
//             AppColors.success,
//             c.adjustTp,
//             c.tpController,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _priceAdjuster(
//     PlaceOrderController c,
//     String label,
//     Color color,
//     void Function(double) onChange,
//     TextEditingController controller,
//   ) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             GestureDetector(
//               onTap: () => onChange(-0.1),
//               child: const Text(
//                 '-',
//                 style: TextStyle(
//                   fontSize: 24,
//                   // color: Colors.blue
//                   color: AppColors.info,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: TextField(
//                 controller: controller,
//                 textAlign: TextAlign.center,
//                 keyboardType: const TextInputType.numberWithOptions(
//                   decimal: true,
//                 ),
//                 decoration: InputDecoration(
//                   hintText: label,
//                   border: InputBorder.none,
//                   isDense: true,
//                   contentPadding: const EdgeInsets.symmetric(vertical: 8),
//                 ),
//               ),
//             ),
//             GestureDetector(
//               onTap: () => onChange(0.1),
//               child: const Text(
//                 '+',
//                 style: TextStyle(
//                   fontSize: 24,
//                   //  color: Colors.blue
//                   color: AppColors.info,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         Container(
//           height: 2,
//           color: color,
//           margin: const EdgeInsets.only(top: 4),
//         ),
//       ],
//     );
//   }

//   Widget _buildFillPolicyDropdown(
//     PlaceOrderController c,
//     BuildContext context,
//   ) {
//     const policies = ['Fill or Kill', 'Immediate or Cancel'];
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text(
//               'Fill Policy',
//               style: TextStyle(
//                 fontSize: 16,
//                 // color: Colors.black
//                 color: AppColors.textPrimary,
//               ),
//             ),
//             // Spacer(),
//             Obx(
//               () => DropdownButtonHideUnderline(
//                 child: DropdownButton<String>(
//                   value: c.selectedFillPolicy.value,
//                   onChanged: (v) => c.selectedFillPolicy.value = v!,
//                   items:
//                       policies
//                           .map(
//                             (val) => DropdownMenuItem(
//                               value: val,
//                               child: Align(
//                                 alignment: Alignment.centerRight,
//                                 child: Text(
//                                   val,
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     // color: Colors.black
//                                     color: AppColors.textPrimary,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           )
//                           .toList(),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         Container(
//           height: 1.5,
//           color: Colors.grey[300],
//           margin: const EdgeInsets.only(top: 6),
//         ),
//       ],
//     );
//   }
//   Widget _buildBottomButtons(PlaceOrderController c) {
//     print("Position Payload $position");
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         border: Border(top: BorderSide(color: Colors.grey[300]!)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text(
//             'Stop Loss or Take Profit you set must differ from market price by at least 250 points.Stop processsing is performed on the broker side',
//             style: TextStyle(fontSize: 12, color: Colors.grey[500]),
//           ),
//           // Container(
//           //     margin: const EdgeInsets.only(top: 6),
//           //     height: 1,
//           //     color: Colors.grey[300]),
//           Row(
//             children: [
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () {
//                     final modifyController = Get.put(ModifyLimitController());
//                     final pending = Get.arguments["pendingOrder"];
//                     modifyController.modifyLimit(
//                       accountId: position.accountId,
//                       side: position.side,
//                       instrumentId: position.instrumentId,
//                       positionQty: position.positionQty,
//                       positionId: position.positionId,
//                       orderPrice: orderPrice,
//                       stopPrice:
//                           double.tryParse(c.slController.text) ??
//                           pending.stopPrice ??
//                           0,
//                       limitPrice:
//                           double.tryParse(c.tpController.text) ??
//                           pending.limitPrice ??
//                           0,
//                       timeInForceId: 1,
     
//                     );
//                   },











//                   // onTap: () {
//                   //   // final modifyController = Get.put(ModifyOrderController());
//                   //   final modifyController = Get.put(ModifyLimitController());
                    
//                   //   // Get SL & TP safely
//                   //   final newSL = double.tryParse(c.slController.text) ?? stopPrice;
//                   //   final newTP = double.tryParse(c.tpController.text) ?? limitPrice;
//                   //   final newOrderPrice = double.tryParse(c.priceController.text) ?? orderPrice;

//                   //   final pending = Get.arguments["pendingOrder"];
//                   //   // If this screen is modifying a *position*
//                   //   // final pendingOrderId = position.pendingOrderId;
//                   //   // final accountId = position.accountId;
//                   //   // final timeInForceId = position.timeInForceId;

//                   //   // if (pendingOrderId == null) {
//                   //   //   Get.snackbar(
//                   //   //     "Error",
//                   //   //     "No pending order ID available for modification.",
//                   //   //     backgroundColor: Colors.red,
//                   //   //     colorText: Colors.white,
//                   //   //   );
//                   //   //   return;
//                   //   // }
//                   //     modifyController.modifyLimit(
//                   //     accountId: position.accountId,
//                   //     side: position.side,
//                   //     instrumentId: position.instrumentId,
//                   //     positionQty: position.positionQty,
//                   //     positionId: position.positionId,
//                   //     orderPrice: orderPrice,
//                   //     stopPrice:
//                   //         double.tryParse(c.slController.text) ??
//                   //         pending.stopPrice ??
//                   //         0,
//                   //     limitPrice:
//                   //         double.tryParse(c.tpController.text) ??
//                   //         pending.limitPrice ??
//                   //         0,
//                   //     timeInForceId: 1,
//                   //   );
//                   //   // modifyController.modifyOrder(
//                   //   //   accountId: position.accountId!,
//                   //   //   pendingOrderId: pending?.pendingOrderId ?? 0,
//                   //   //   orderPrice: newOrderPrice,
//                   //   //   stopPrice: newSL,
//                   //   //   limitPrice: newTP,
//                   //   //   timeInForceId: pending?.timeInForceId ?? 1,
//                   //   // );
//                   // },

//                   // onTap: () {
//                   //   final modifyController = Get.put(ModifyOrderController());

//                   //   final pending = Get.arguments["pendingOrder"];

//                   // modifyController.modifyOrder(
//                   //   accountId: position.accountId,
//                   //   pendingOrderId: pending?.pendingOrderId ?? 0,
//                   //   orderPrice: orderPrice,
//                   //   stopPrice: double.tryParse(c.slController.text) ?? stopPrice,
//                   //   limitPrice: double.tryParse(c.tpController.text) ?? limitPrice,
//                   //   timeInForceId: pending?.timeInForceId ?? 1,
//                   // );

//                   // },
//                   child: Column(
//                     children: const [
//                       Text(
//                         'MODIFY',
//                         style: TextStyle(
//                           // color: Colors.red,
//                           color: AppColors.down,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _formattedPrice(double price, Color color) {
//     final parts = price.toStringAsFixed(5).split('.');
//     return RichText(
//       text: TextSpan(
//         style: TextStyle(color: color, fontWeight: FontWeight.bold),
//         children: [
//           TextSpan(text: '${parts[0]}.'),
//           TextSpan(
//             text: parts[1].substring(0, 2),
//             style: const TextStyle(fontSize: 18),
//           ),
//           TextSpan(
//             text: parts[1].substring(2),
//             style: const TextStyle(fontSize: 24),
//           ),
//         ],
//       ),
//     );
//   }

//   // String _getSideLabel(String orderType) {
//   //   if (orderType.toLowerCase().contains('buy')) return 'Buy';
//   //   if (orderType.toLowerCase().contains('sell')) return 'Sell';
//   //   return 'Unknown';
//   // }

//   String _formatVolume(double volume) {
//     if (volume == volume.roundToDouble()) return volume.toStringAsFixed(0);
//     if ((volume * 10) == (volume * 10).roundToDouble()) {
//       return volume.toStringAsFixed(1);
//     }
//     if ((volume * 100) == (volume * 100).roundToDouble()) {
//       return volume.toStringAsFixed(2);
//     }
//     return volume.toStringAsFixed(3);
//   }

//   String _getSideLabel(dynamic side) {
//     if (side is int) {
//       switch (side) {
//         case 1:
//           return 'Buy';
//         case 2:
//           return 'Sell';
//       }
//     } else if (side is String) {
//       if (side.toLowerCase() == 'buy') return 'Buy';
//       if (side.toLowerCase() == 'sell') return 'Sell';
//     }
//     return 'Unknown';
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:fl_chart/fl_chart.dart';
import 'package:netdania/app/config/theme/app_color.dart';
import 'package:netdania/app/getX/modify_limit_getx.dart';
import 'package:netdania/app/models/instrument_model.dart';
import 'package:netdania/app/models/positions_model.dart';
import 'package:netdania/app/modules/order/controller/place_order_controller.dart';
import 'package:netdania/utils/responsive_layout_helper.dart';

/// ---------------- VIEW ----------------
class ModifyPositionPage extends StatelessWidget {
  
  final String symbol;
  final double currentBuyPrice;
  final double currentSellPrice;
  // final double entryPrice;
  final double orderPrice;
  final double stopPrice;
  final double limitPrice;
  final Position position;
  final InstrumentModel instrument;

  const ModifyPositionPage({
    super.key,
    required this.symbol,
    required this.currentBuyPrice,
    required this.currentSellPrice,
    // required this.entryPrice,
    required this.orderPrice,
    required this.stopPrice,
    required this.limitPrice,
    required this.position,
    required this.instrument,
  });

  double safeDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    // final c = Get.put(PlaceOrderController());

    final c =
        Get.isRegistered<PlaceOrderController>(tag: symbol)
            ? Get.find<PlaceOrderController>(tag: symbol)
            : Get.put(PlaceOrderController(), tag: symbol);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      c.symbol.value = symbol;
      c.currentBuyPrice.value = currentBuyPrice;
      c.currentSellPrice.value = currentSellPrice;

      c.volume.value = position.positionQty;
      c.price.value = orderPrice;
      c.sl.value = stopPrice;
      c.tp.value = limitPrice;

      c.slController.text = stopPrice.toStringAsFixed(5);
      c.tpController.text = limitPrice.toStringAsFixed(5);
      c.priceController.text = orderPrice.toStringAsFixed(5);
    });

    // c.symbol.value = symbol;
    // c.currentBuyPrice.value = currentBuyPrice;
    // c.currentSellPrice.value = currentSellPrice;

    // Set all initial values from position
    c.symbol.value = symbol;
    c.currentBuyPrice.value = currentBuyPrice;
    c.currentSellPrice.value = currentSellPrice;
    c.volume.value =
        position
            .positionQty; // <-- This ensures the AppBar shows correct volume
    c.price.value = orderPrice; // Optional: if you want order price synced
    c.sl.value = stopPrice; // Optional: sync SL
    c.tp.value = limitPrice; // Optional: sync TP

    // c.setSymbol(symbol);
    // c.currentBuyPrice.value = currentBuyPrice;
    // c.currentSellPrice.value = currentSellPrice;

    return ResponsiveLayout(
      mobile: _buildScaffold(context, c, const EdgeInsets.all(12)),
      tablet: _buildScaffold(
        context,
        c,
        const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
      ),
      desktop: _buildDesktopLayout(context, c),
    );
  }

  /// ---------------- MOBILE / TABLET ----------------
  Widget _buildScaffold(
    BuildContext context,
    PlaceOrderController c,
    EdgeInsets padding,
  ) {
    return Scaffold(
      // backgroundColor: Colors.white,
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context, c),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
        child: _buildOrderBody(context, c, padding),
      ),
    );
  }

  /// ---------------- DESKTOP ----------------
  Widget _buildDesktopLayout(BuildContext context, PlaceOrderController c) {
    return Scaffold(
      // backgroundColor: Colors.white,
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context, c),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildOrderBody(context, c, EdgeInsets.zero),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Obx(() {
                  final data = c.tradingController.getPriceHistory(
                    c.symbol.value,
                  );
                  if (data.isEmpty) {
                    return const Center(
                      child: Text("Waiting for live data..."),
                    );
                  }
                  return Text('Chart');
                  // return LineChartWidget(priceHistory: data);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------- COMMON BODY ----------------
  Widget _buildOrderBody(
    BuildContext context,
    PlaceOrderController c,
    EdgeInsets padding,
  ) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Transform.translate(offset: Offset(0, -4),
          // child: Container(height: 1,color: Colors.grey[300]),),
          // const SizedBox(height: 8),
          const SizedBox(height: 10),

          // Obx(() {
          //   // final ticker = c.tradingController.getTicker(c.symbol.value);
          //   // final ticker = c.tradingController.getTickerSafe(symbol);
          //   // final sell =
          //   //     double.tryParse(ticker?['bid']?.toString() ?? '0') ?? 0;
          //   // final buy = double.tryParse(ticker?['ask']?.toString() ?? '0') ?? 0;
          //   // final color = c.tradingController.isPriceUp ? Colors.blue : Colors.red;
          //   final color =
          //       c.tradingController.isPriceUp ? AppColors.up : AppColors.down;

          //       final instrumentName = SymbolUtils.getInstrumentName(
          //     position.instrumentId,
          //   );

          //        final symbolKey = PriceHelper.normalizeSymbol(instrumentName);
          //   final ticker = c.tradingController.tickers[symbolKey];

          //   final sell = safeDouble(ticker?['bid']);
          //   final buy = safeDouble(ticker?['ask']);
          //   return Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //       _formattedPrice(sell, color),
          //       _formattedPrice(buy, color),
          //     ],
          //   );
          // }),
          Obx(() {
            final symbolKey = instrument.code.toUpperCase();
            final ticker = c.tradingController.getTickerSafe(symbolKey);

            if (ticker == null) {
              return const Text('—');
            }

            final sell = safeDouble(ticker['bid']);
            final buy = safeDouble(ticker['ask']);

            final isUp = c.tradingController.isPriceUpForSymbol(symbolKey);
            final color = isUp ? AppColors.up : AppColors.down;

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _formattedPrice(sell, color),
                _formattedPrice(buy, color),
              ],
            );
          }),

          const SizedBox(height: 10),
          _buildSLTPRow(c),
          const SizedBox(height: 10),
          _buildFillPolicyDropdown(c, context),
          const SizedBox(height: 10),
          Expanded(
            child: Obx(() {
              // final prices = c.tradingController.getPriceHistory(
              //   c.symbol.value,
              // );
              final prices = c.tradingController.getPriceHistory(symbol);

              if (prices.isEmpty) {
                return const Center(child: Text("Waiting for live data..."));
              }
              // return LineChartWidget(priceHistory: prices);
              return Text('Chart');
            }),
          ),
          const SizedBox(height: 10),
          _buildBottomButtons(c),
        ],
      ),
    );
  }

  /// ---------------- UI PARTS ----------------
  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    PlaceOrderController c,
  ) {
    return AppBar(
      // backgroundColor: Colors.white,
      backgroundColor: AppColors.background,
      // automaticallyImplyLeading: false,
      title: Column(
        children: [
          Row(
            children: [
              Text(
                'Modify position',
                style: const TextStyle(
                  // color: Colors.black,
                  color: AppColors.textPrimary,
                  fontSize: 18,
                ),
              ),
            ],
          ),

          // Row(
          //   children: [
          //     // IconButton(
          //     //   icon: const Icon(Icons.arrow_back, color: Colors.black),
          //     //   onPressed: () => Navigator.pop(context),
          //     // ),
          //     Text(c.symbol.value,
          //         style: const TextStyle(
          //           // color: Colors.black,
          //           color: AppColors.textPrimary,
          //            fontSize: 18)),
          //     const Spacer(),
          //     const Icon(Icons.refresh, color: AppColors.textPrimary),
          //   ],
          // ),
          Obx(() {
            // final ticker = c.tradingController.getTickerSafe(c.symbol.value);
            final ticker = c.tradingController.getTickerSafe(symbol);

            final bid =
                double.tryParse(ticker?['bid']?.toString() ?? '0') ?? 0.0;
            final ask =
                double.tryParse(ticker?['ask']?.toString() ?? '0') ?? 0.0;
            // final price = (bid + ask) / 2;
            // final price = entryPrice;
            // final price = orderPrice;

            // Side color & label — same as in OrderTile
            // final side = _getSideLabel(c.selectedOrderType.value);
            // final side = _getSideLabel(c.selectedOrderType.value);
            final side = _getSideLabel(position.side);
            return Row(
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '$side ',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        // text: c.volume.value.toStringAsFixed(2),
                        // text: position.positionQty.toStringAsFixed(2),
                        text: _formatVolume(position.positionQty),
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),

                      TextSpan(
                        // text: '${c.symbol.value}, ',
                        text: instrument.code,
                        style: const TextStyle(
                          // color: Colors.black,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text: orderPrice.toStringAsFixed(5),
                        // text: orderPrice.toString(),
                        style: const TextStyle(
                          // color: Colors.black,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                //     const SizedBox(width: 8),
                // // Current price
                // Text(
                //   price == 0 ? '—' : '@ ${price.toStringAsFixed(5)}',
                //   style: const TextStyle(
                //     fontSize: 14,
                //     // color: Colors.grey,
                //     color: AppColors.textSecondary,
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSLTPRow(PlaceOrderController c) {
    return Row(
      children: [
        Expanded(
          child: _priceAdjuster(
            c,
            "SL",
            AppColors.down,
            c.adjustSl,
            c.slController,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _priceAdjuster(
            c,
            "TP",
            AppColors.success,
            c.adjustTp,
            c.tpController,
          ),
        ),
      ],
    );
  }

  Widget _priceAdjuster(
    PlaceOrderController c,
    String label,
    Color color,
    void Function(double) onChange,
    TextEditingController controller,
  ) {
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => onChange(-0.1),
              child: const Text(
                '-',
                style: TextStyle(
                  fontSize: 24,
                  // color: Colors.blue
                  color: AppColors.info,
                ),
              ),
            ),
            Expanded(
              child: TextField(
                controller: controller,
                textAlign: TextAlign.center,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  hintText: label,
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => onChange(0.1),
              child: const Text(
                '+',
                style: TextStyle(
                  fontSize: 24,
                  //  color: Colors.blue
                  color: AppColors.info,
                ),
              ),
            ),
          ],
        ),
        Container(
          height: 2,
          color: color,
          margin: const EdgeInsets.only(top: 4),
        ),
      ],
    );
  }

  Widget _buildFillPolicyDropdown(
    PlaceOrderController c,
    BuildContext context,
  ) {
    const policies = ['Fill or Kill', 'Immediate or Cancel'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Fill Policy',
              style: TextStyle(
                fontSize: 16,
                // color: Colors.black
                color: AppColors.textPrimary,
              ),
            ),
            // Spacer(),
            Obx(
              () => DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: c.selectedFillPolicy.value,
                  onChanged: (v) => c.selectedFillPolicy.value = v!,
                  items:
                      policies
                          .map(
                            (val) => DropdownMenuItem(
                              value: val,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  val,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    // color: Colors.black
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),
            ),
          ],
        ),
        Container(
          height: 1.5,
          color: Colors.grey[300],
          margin: const EdgeInsets.only(top: 6),
        ),
      ],
    );
  }

  Widget _buildBottomButtons(PlaceOrderController c) {
    print("Position Payload $position");
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Stop Loss or Take Profit you set must differ from market price by at least 250 points.Stop processsing is performed on the broker side',
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
          // Container(
          //     margin: const EdgeInsets.only(top: 6),
          //     height: 1,
          //     color: Colors.grey[300]),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    final modifyController = Get.put(ModifyLimitController());
                    final pending = Get.arguments["pendingOrder"];
                    modifyController.modifyLimit(
                      accountId: position.accountId,
                      side: position.side,
                      instrumentId: position.instrumentId,
                      positionQty: position.positionQty,
                      positionId: position.positionId,
                      orderPrice: orderPrice,
                      stopPrice:
                          double.tryParse(c.slController.text) ??
                          pending.stopPrice ??
                          0,
                      limitPrice:
                          double.tryParse(c.tpController.text) ??
                          pending.limitPrice ??
                          0,
                      timeInForceId: 1,
                    );
                  },

                  // onTap: () {
                  //   final modifyController = Get.put(ModifyOrderController());

                  //   // Get SL & TP safely
                  //   final newSL = double.tryParse(c.slController.text) ?? stopPrice;
                  //   final newTP = double.tryParse(c.tpController.text) ?? limitPrice;
                  //   final newOrderPrice = double.tryParse(c.priceController.text) ?? orderPrice;

                  //   final pending = Get.arguments["pendingOrder"];
                  //   // If this screen is modifying a *position*
                  //   // final pendingOrderId = position.pendingOrderId;
                  //   // final accountId = position.accountId;
                  //   // final timeInForceId = position.timeInForceId;

                  //   // if (pendingOrderId == null) {
                  //   //   Get.snackbar(
                  //   //     "Error",
                  //   //     "No pending order ID available for modification.",
                  //   //     backgroundColor: Colors.red,
                  //   //     colorText: Colors.white,
                  //   //   );
                  //   //   return;
                  //   // }

                  //   modifyController.modifyOrder(
                  //     accountId: position.accountId!,
                  //     pendingOrderId: pending?.pendingOrderId ?? 0,
                  //     orderPrice: newOrderPrice,
                  //     stopPrice: newSL,
                  //     limitPrice: newTP,
                  //     timeInForceId: pending?.timeInForceId ?? 1,
                  //   );
                  // },

                  // onTap: () {
                  //   final modifyController = Get.put(ModifyOrderController());

                  //   final pending = Get.arguments["pendingOrder"];

                  // modifyController.modifyOrder(
                  //   accountId: position.accountId,
                  //   pendingOrderId: pending?.pendingOrderId ?? 0,
                  //   orderPrice: orderPrice,
                  //   stopPrice: double.tryParse(c.slController.text) ?? stopPrice,
                  //   limitPrice: double.tryParse(c.tpController.text) ?? limitPrice,
                  //   timeInForceId: pending?.timeInForceId ?? 1,
                  // );

                  // },
                  child: Column(
                    children: const [
                      Text(
                        'MODIFY',
                        style: TextStyle(
                          // color: Colors.red,
                          color: AppColors.down,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _formattedPrice(double price, Color color) {
    final parts = price.toStringAsFixed(5).split('.');
    return RichText(
      text: TextSpan(
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
        children: [
          TextSpan(text: '${parts[0]}.'),
          TextSpan(
            text: parts[1].substring(0, 2),
            style: const TextStyle(fontSize: 18),
          ),
          TextSpan(
            text: parts[1].substring(2),
            style: const TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }

  // String _getSideLabel(String orderType) {
  //   if (orderType.toLowerCase().contains('buy')) return 'Buy';
  //   if (orderType.toLowerCase().contains('sell')) return 'Sell';
  //   return 'Unknown';
  // }

  String _formatVolume(double volume) {
    if (volume == volume.roundToDouble()) return volume.toStringAsFixed(0);
    if ((volume * 10) == (volume * 10).roundToDouble()) {
      return volume.toStringAsFixed(1);
    }
    if ((volume * 100) == (volume * 100).roundToDouble()) {
      return volume.toStringAsFixed(2);
    }
    return volume.toStringAsFixed(3);
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
}
