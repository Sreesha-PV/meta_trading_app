// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// // import 'package:fl_chart/fl_chart.dart';
// import 'package:netdania/app/config/theme/app_color.dart';
// import 'package:netdania/app/getX/close_position_gettx.dart';
// import 'package:netdania/app/getX/order_getX.dart';
// import 'package:netdania/app/getX/trading_getX.dart';
// import 'package:netdania/app/models/instrument_model.dart';
// import 'package:netdania/app/models/positions_model.dart';
// import 'package:netdania/app/modules/order/controller/place_order_controller.dart';
// import 'package:netdania/utils/responsive_layout_helper.dart';

// /// ---------------- VIEW ---------------- ///
// class ClosePositionPage extends StatelessWidget {
//   final String symbol;
//   final double currentBuyPrice;
//   final double currentSellPrice;
//   final double entryPrice;
//   final Position position;
//   final InstrumentModel instrument;
//   // final int positions;
//   final OrderController orderController = Get.put(OrderController());
//   final TradingChartController tradingController =
//   //  Get.put(TradingChartController());
//   Get.put(TradingChartController());
  

//   ClosePositionPage({
//     super.key,
//     required this.symbol,
//     required this.currentBuyPrice,
//     required this.currentSellPrice,
//     required this.entryPrice,
//     required this.position,
//     // required this.positions,
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
//         Get.isRegistered<PlaceOrderController>()
//             ? Get.find<PlaceOrderController>()
//             : Get.put(PlaceOrderController());

//     c.symbol.value = symbol;
//     c.currentBuyPrice.value = currentBuyPrice;
//     c.currentSellPrice.value = currentSellPrice;

//     final args = Get.arguments ?? {};
//     final side = args['side'] ?? 0;
//     final volume = (args['volume'] ?? 0.0) as double;

//     // c.selectedOrderType.value = side == 2 ? 'Buy' : 'Sell';
//     c.volume.value = volume;

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

//       // bottomNavigationBar: _buildBottomBar(),
//       // bottomNavigationBar: _buildBottomButtons(c),
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
//           // _buildOrderTypeDropdown(c),
//           Transform.translate(
//             offset: Offset(0, -4),
//             child: Container(height: 1, color: Colors.grey[300]),
//           ),
//           const SizedBox(height: 8),
//           _buildVolumeSelector(context, c),
//           const SizedBox(height: 10),
//           Row(
//   children: [
//     SizedBox(
//       width: MediaQuery.of(context).size.width * 0.5,
//       child: Text(
//         'Stop Loss',
//         style: TextStyle(
//           color: AppColors.textPrimary,
//           fontSize: 17,
//         ),
//       ),
//     ),
//     Expanded(
//       flex: 3,
//       child: _priceAdjuster(
//         c,
//         'SL',
//         AppColors.down,
//         c.adjustSl,
//         c.slController,
//       ),
//     ),
//   ],
// ),

//           SizedBox(height: 16,),
//           Row(
//             children: [
//               SizedBox(
//                 width: MediaQuery.of(context).size.width * 0.5,
//                 child: Text(
//                   'Take Profit',
//                   style: TextStyle(
//                     color: AppColors.textPrimary,
//                     fontSize: 17,
//                     fontWeight: FontWeight.w400,
//                   ),),
//               ),
//               Expanded(child: _priceAdjuster(
//                 c,
//                 "TP",
//                 AppColors.success, 
//                 c.adjustTp, 
//                 c.tpController
//               )
//               )
//             ],
//           ),

         
//           const SizedBox(height: 16),
//           // _buildFillPolicyDropdown(c, context),
//           Row(
//               children: [
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width * 0.5,
//                   child: Text(
//                     'Expiration',
//                     style: TextStyle(
//                       color: AppColors.textPrimary,
//                       fontSize: 17,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ),

//               Expanded(
//                   child: _buildFillPolicyDropdown(c, context),
//                 ),
//               ],
//             ),

//           const SizedBox(height: 16),

//            Container(
//             padding: EdgeInsets.symmetric(horizontal: 0 ,vertical: 16),
//             decoration: BoxDecoration(
//               color: AppColors.lightNeutral,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Obx(() {
//               final symbolKey = instrument.code.toUpperCase();
//               final ticker = tradingController.getTickerSafe(symbolKey);
             
//               if (ticker == null) {
//                 return const Text('—');
//               }
             
//               final sell = safeDouble(ticker['bid']);
//               final buy = safeDouble(ticker['ask']);
             
//               final isUp = tradingController.isPriceUpForSymbol(symbolKey);
//               final color = isUp ? AppColors.up : AppColors.down;
             
//               return Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   _formattedPrice(sell, color),
//                   _formattedPrice(buy, color),
//                 ],
//               );
//                        }),
//            ),

          
//           const SizedBox(height: 16),
//           _buildBottomButtons(c),
//         ],
//       ),
//     );
//   }

//   PreferredSizeWidget _buildAppBar(
//     BuildContext context,
//     PlaceOrderController c,
//   ) {
//     return AppBar(
//       // backgroundColor: Colors.white,
//       backgroundColor: AppColors.background,
//       elevation: 0.5,
//       titleSpacing: 0,
//       title: Padding(
//         padding: const EdgeInsets.only(left: 8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // First line
//             const Text(
//               'Close Position',
//               style: TextStyle(
//                 // color: Colors.black,
//                 color: AppColors.textPrimary,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//               ),
//             ),
//             const SizedBox(height: 4),

//             Obx(() {
          
//               final side = _getSideLabel(position.side);
              
//               return Row(
//                 children: [
//                   // Symbol + Side + Volume
//                   RichText(
//                     text: TextSpan(
//                       children: [
//                         TextSpan(
//                           text: '$side ',
//                           // text: _getSideLabel(side),
//                           style: TextStyle(
//                             // color: color,
//                             color:  AppColors.textSecondary,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                           ),
//                         ),

//                         TextSpan(
//                           text: c.volume.value.toStringAsFixed(2),
//                           style: TextStyle(
//                             // color: color,
//                             color: AppColors.textSecondary,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                           ),
//                         ),

//                         TextSpan(
//                           // text: '${c.symbol.value},',
//                           text: instrument.code,
//                           style: const TextStyle(
//                             // color: Colors.black,
//                             color: AppColors.textPrimary,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                           ),
//                         ),

//                         TextSpan(
//                           text: entryPrice.toStringAsFixed(4),
//                           style: const TextStyle(
//                             // color: Colors.black,
//                             color: AppColors.textPrimary,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
                 
//                 ],
//               );
//             }),
//           ],
//         ),
//       ),
//     );
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


//    Widget _buildVolumeSelector(BuildContext context, PlaceOrderController c) {
//     return Center(
//       child: Container(
//         constraints: const BoxConstraints(maxWidth: 600),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Padding(padding: const EdgeInsets.only(bottom: 8)),

//             Obx(
//               () => Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   _volumeButton(c, '-0.5', -0.5),
//                   _volumeButton(c, '-0.1', -0.1),

//                   c.isEditingVolume.value
//                       ? Container(
//                         width: 100,
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 8,
//                         ),
//                         child: CupertinoTextField(
//                           controller: c.volumeTextController,
//                           keyboardType: const TextInputType.numberWithOptions(
//                             decimal: true,
//                           ),
//                           autofocus: true,
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             color: AppColors.textPrimary,
//                             fontSize: 17,
//                             fontWeight: FontWeight.w500,
//                           ),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           onSubmitted: (value) {
//                             final newVol = double.tryParse(value);
//                             if (newVol != null && newVol >= 0.01) {
//                               c.volume.value = newVol;
//                             }
//                             c.isEditingVolume.value = false;
//                           },
//                         ),
//                       )
//                       : GestureDetector(
//                         onTap: () {
//                           c.volumeTextController.text = c.volume.value
//                               .toStringAsFixed(2);
//                           c.isEditingVolume.value = true;
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 8,
//                           ),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Text(
//                             c.volume.value.toStringAsFixed(2),
//                             style: TextStyle(
//                               color: AppColors.textPrimary,
//                               fontSize: 17,
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                         ),
//                       ),

//                   _volumeButton(c, '+0.1', 0.1),
//                   _volumeButton(c, '+0.5', 0.5),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }


//    Widget _volumeButton(PlaceOrderController c, String label, double delta) {
//     return CupertinoButton(
//       padding: EdgeInsets.zero,
//       minSize: 0,
//       onPressed: () {
//         final newVol = c.volume.value + delta;
//         if (newVol >= 0.01) {
//           c.volume.value = newVol;
//         }
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8),
//           // border: Border.all(color: AppColors.primary, width: 1.5),
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             color: AppColors.primary,
//             fontSize: 17,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
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
//                   // color: Colors.blue
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
//         Obx(
//           () => DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               isExpanded: true,
//               value: c.selectedFillPolicy.value,
//               alignment: Alignment.centerRight,
//               dropdownColor: AppColors.background,              
//               onChanged: (v) => c.selectedFillPolicy.value = v!,
//               items:
//                   policies
//                       .map(
//                         (val) => DropdownMenuItem(
//                           value: val,
//                           child: Align(
//                             alignment: Alignment.centerRight,
//                             child: Text(
//                               val,
//                               style: const TextStyle(
//                                 // fontSize: 16,
//                                 // color: Colors.black
//                                 color: AppColors.textPrimary,
//                                 overflow: TextOverflow.ellipsis
//                               ),
//                             ),
//                           ),
//                         ),
//                       )
//                       .toList(),
//             ),
//           ),
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
   
//       return Column(
//         children: [
//           Text(
//             'Attention! The trade will be executed at market condition,difference with requested price may be significant!',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey[500],),
//           ),

//           SizedBox(height: 16,),
//           Row(
//             children: [
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () {
                  
//                     var closeController = Get.put(CloseController());
//                     //  closeController.closePosition(

//                     final pos = position;

//                     final double closeQty = c.volume.value;
//                     final double openQty = position.positionQty;

//                     if (closeQty <= 0 || closeQty > openQty) {
//                       Get.snackbar(
//                         'Invalid volume',
//                         'Close volume must be less than or equal to open volume',
//                       );
//                       return;
//                     }

//                     closeController.closePosition(
//                       instrumentId: pos.instrumentId,
//                       // side: pos.side,
//                       side: position.side == 1 ? 2 : 1, // reverse side to close
//                       // orderType: 1,
//                       // orderQty: pos.positionInitialQty,
//                       orderQty: closeQty,

//                       orderPrice: pos.orderPrice,
//                       accountId: pos.accountId,
//                       relatedPositionId: pos.positionId,
//                     );
//                   },
//                   child: Container(
//                     padding: EdgeInsets.symmetric(vertical: 12),
//                     decoration: BoxDecoration(
//                       color: AppColors.down
//                     ),
//                     child: Column(
//                       children: const [
//                         Text(
//                           'CLOSE POSITION',
//                           style: TextStyle(
//                             // color: Color(0xFFFFAB40),
//                             color: AppColors.background,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       // ),
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
// }













import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
// import 'package:fl_chart/fl_chart.dart';
import 'package:netdania/app/config/theme/app_color.dart';
import 'package:netdania/app/config/theme/app_textstyle.dart';
import 'package:netdania/app/getX/close_position_gettx.dart';
import 'package:netdania/app/getX/order_getX.dart';
import 'package:netdania/app/getX/trading_getX.dart';
import 'package:netdania/app/models/instrument_model.dart';
import 'package:netdania/app/models/positions_model.dart';
import 'package:netdania/app/modules/order/controller/place_order_controller.dart';
import 'package:netdania/utils/responsive_layout_helper.dart';

/// ---------------- VIEW ---------------- ///
class ClosePositionPage extends StatelessWidget {
  final String symbol;
  final double currentBuyPrice;
  final double currentSellPrice;
  final double entryPrice;
  final Position position;
  final InstrumentModel instrument;
  // final int positions;
  final OrderController orderController = Get.put(OrderController());
  final TradingChartController tradingController =
  //  Get.put(TradingChartController());
  Get.put(TradingChartController());
  

  ClosePositionPage({
    super.key,
    required this.symbol,
    required this.currentBuyPrice,
    required this.currentSellPrice,
    required this.entryPrice,
    required this.position,
    // required this.positions,
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
        Get.isRegistered<PlaceOrderController>()
            ? Get.find<PlaceOrderController>()
            : Get.put(PlaceOrderController());

    c.symbol.value = symbol;
    c.currentBuyPrice.value = currentBuyPrice;
    c.currentSellPrice.value = currentSellPrice;

    final args = Get.arguments ?? {};
    final side = args['side'] ?? 0;
    final volume = (args['volume'] ?? 0.0) as double;

    // c.selectedOrderType.value = side == 2 ? 'Buy' : 'Sell';
    c.volume.value = volume;

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
      // desktop: _buildDesktopLayout(context, c),
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
      backgroundColor: AppColors.background(context),
      resizeToAvoidBottomInset: true,
      appBar: _buildAppBar(context, c),
      // body: Padding(
      //   padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
      //   child: _buildOrderBody(context, c, padding),
      // ),

      
body: LayoutBuilder(
  builder: (context, constraints) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: constraints.maxHeight, // fills available space
        ),
        child: IntrinsicHeight(
          child: _buildOrderBody(context, c, EdgeInsets.zero),
        ),
      ),
    );
  },
),
      // bottomNavigationBar: _buildBottomBar(),
      // bottomNavigationBar: _buildBottomButtons(c),
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
          // _buildOrderTypeDropdown(c),
          Transform.translate(
            offset: Offset(0, -4),
            child: Container(height: 1, color: Colors.grey[300]),
          ),
          const SizedBox(height: 8),
          _buildVolumeSelector(context, c),
          const SizedBox(height: 10),
          Row(
  children: [
    SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Text(
        'Stop Loss',
        // style: TextStyle(
        //   color: AppColors.textPrimary,
        //   fontSize: 17,
        // ),
        style: AppTextStyle.h3_400.textPrimary(context),

      ),
    ),
    Expanded(
      flex: 3,
      child: _priceAdjuster(
        c,
        'SL',
        AppColors.bearish,
        c.adjustSl,
        c.slController,
      ),
    ),
  ],
),

          SizedBox(height: 8,),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  'Take Profit',
                  // style: TextStyle(
                  //   color: AppColors.textPrimary,
                  //   fontSize: 17,
                  //   fontWeight: FontWeight.w400,
                  // ),
                  style: AppTextStyle.h3_400.textPrimary(context),
                  
                  ),
              ),
              Expanded(child: _priceAdjuster(
                c,
                "TP",
                AppColors.success, 
                c.adjustTp, 
                c.tpController
              )
              )
            ],
          ),

         
          const SizedBox(height: 8),
          // _buildFillPolicyDropdown(c, context),
          Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    'Expiration',
                    // style: TextStyle(
                    //   color: AppColors.textPrimary,
                    //   fontSize: 17,
                    //   fontWeight: FontWeight.w400,
                    // ),
                  style: AppTextStyle.h3_400.textPrimary(context),

                  ),
                ),

              Expanded(
                  child: _buildFillPolicyDropdown(c, context),
                ),
              ],
            ),

          const SizedBox(height: 8),

           Container(
            padding: EdgeInsets.symmetric(horizontal: 0 ,vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.lightNeutral,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Obx(() {
              final symbolKey = instrument.code.toUpperCase();
              final ticker = tradingController.getTickerSafe(symbolKey);
             
              if (ticker == null) {
                return const Text('—');
              }
             
              final sell = safeDouble(ticker['bid']);
              final buy = safeDouble(ticker['ask']);
             
              final isUp = tradingController.isPriceUpForSymbol(symbolKey);
              final color = isUp ? AppColors.bullish : AppColors.bearish;
             
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _formattedPrice(sell, color),
                  _formattedPrice(buy, color),
                ],
              );
                       }),
           ),

          
          const SizedBox(height: 8),
          
          _buildBottomButtons(c),
        ],
      ),
    );
  }


  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    PlaceOrderController c,
  ) {
    return AppBar(
      // backgroundColor: Colors.white,
      backgroundColor: AppColors.background(context),
      elevation: 0.5,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First line
            Text(
              'Close Position',
              // style: TextStyle(
              //   // color: Colors.black,
              //   color: AppColors.textPrimary,
              //   fontWeight: FontWeight.bold,
              //   fontSize: 18,
              // ),
                  style: AppTextStyle.h3_700.textPrimary(context),

            ),
            const SizedBox(height: 4),

            Obx(() {
          
              final side = _getSideLabel(position.side);
              // final qty = _formatVolume(position.positionQty);
              return Row(
                children: [
                  // Symbol + Side + Volume
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$side ',
                          // text: _getSideLabel(side),
                          // style: TextStyle(
                          //   // color: color,
                          //   color:  AppColors.textSecondary,
                          //   fontWeight: FontWeight.bold,
                          //   fontSize: 14,
                          // ),
                  style: AppTextStyle.medium_700.textSecondary(context),

                        ),

                        TextSpan(
                          text: c.volume.value.toStringAsFixed(2),
                          // text: qty,
                          // style: TextStyle(
                          //   // color: color,
                          //   color: AppColors.textSecondary,
                          //   fontWeight: FontWeight.bold,
                          //   fontSize: 14,
                          // ),
                  style: AppTextStyle.medium_700.textSecondary(context),

                        ),

                        TextSpan(
                          // text: '${c.symbol.value},',
                          text: instrument.code,
                          // style: const TextStyle(
                          //   // color: Colors.black,
                          //   color: AppColors.textPrimary,
                          //   fontWeight: FontWeight.bold,
                          //   fontSize: 14,
                          // ),
                  style: AppTextStyle.medium_700.textPrimary(context),

                        ),

                        TextSpan(
                          text: entryPrice.toStringAsFixed(4),
                          // style: const TextStyle(
                          //   // color: Colors.black,
                          //   color: AppColors.textPrimary,
                          //   fontWeight: FontWeight.bold,
                          //   fontSize: 14,
                          // ),
                  style: AppTextStyle.medium_400.textPrimary(context),

                        ),
                      ],
                    ),
                  ),
                 
                ],
              );
            }),
          ],
        ),
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


   Widget _buildVolumeSelector(BuildContext context, PlaceOrderController c) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(padding: const EdgeInsets.only(bottom: 8)),

            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _volumeButton(c, '-0.5', -0.5),
                  _volumeButton(c, '-0.1', -0.1),

                  c.isEditingVolume.value
                      ? Container(
                        width: 100,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: CupertinoTextField(
                          controller: c.volumeTextController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          autofocus: true,
                          textAlign: TextAlign.center,
                          // style: TextStyle(
                          //   color: AppColors.textPrimary,
                          //   fontSize: 17,
                          //   fontWeight: FontWeight.w500,
                          // ),
                  style: AppTextStyle.h3_500.textPrimary(context),

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          onSubmitted: (value) {
                            final newVol = double.tryParse(value);
                            if (newVol != null && newVol >= 0.01) {
                              c.volume.value = newVol;
                            }
                            c.isEditingVolume.value = false;
                          },
                        ),
                      )
                      : GestureDetector(
                        onTap: () {
                          c.volumeTextController.text = c.volume.value
                              .toStringAsFixed(2);
                          c.isEditingVolume.value = true;
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            c.volume.value.toStringAsFixed(2),
                            // style: TextStyle(
                            //   color: AppColors.textPrimary,
                            //   fontSize: 17,
                            //   fontWeight: FontWeight.w400,
                            // ),
                  style: AppTextStyle.h3_400.textPrimary(context),

                          ),
                        ),
                      ),

                  _volumeButton(c, '+0.1', 0.1),
                  _volumeButton(c, '+0.5', 0.5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


   Widget _volumeButton(PlaceOrderController c, String label, double delta) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minSize: 0,
      onPressed: () {
        final newVol = c.volume.value + delta;
        if (newVol >= 0.01) {
          c.volume.value = newVol;
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          // border: Border.all(color: AppColors.primary, width: 1.5),
        ),
        child: Text(
          label,
          // style: TextStyle(
          //   color: AppColors.primary,
          //   fontSize: 17,
          //   fontWeight: FontWeight.w500,
          // ),
                  style: AppTextStyle.h3_500.primary(Get.context!),

        ),
      ),
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
              child: Text(
                '-',
                // style: TextStyle(
                //   fontSize: 24,
                //   // color: Colors.blue
                //   color: AppColors.info,
                // ),
                  style: AppTextStyle.h1_400.info(),

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
              child:  Text(
                '+',
                // style: TextStyle(
                //   fontSize: 24,
                //   // color: Colors.blue
                //   color: AppColors.info,
                // ),
                  style: AppTextStyle.h1_400.info(),

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
        Obx(
          () => DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: c.selectedFillPolicy.value,
              alignment: Alignment.centerRight,
              dropdownColor: AppColors.background(context),              
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
                              style: TextStyle(
                                // fontSize: 16,
                                // color: Colors.black
                                color: AppColors.textPrimary(context),
                                overflow: TextOverflow.ellipsis
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
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
   
      return Column(
        children: [
          
          Text(
            'Attention! The trade will be executed at market condition,difference with requested price may be significant!',
            textAlign: TextAlign.center,
            // style: TextStyle(
            //   fontSize: 12,
            //   color: Colors.grey[500],),
                  style: AppTextStyle.small2_400.muted(Get.context!),

          ),
          SizedBox(height: 16,),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                  
                    var closeController = Get.put(CloseController());
                    //  closeController.closePosition(

                    final pos = position;

                    final double closeQty = c.volume.value;
                    final double openQty = position.positionQty;

                    if (closeQty <= 0 || closeQty > openQty) {
                      Get.snackbar(
                        'Invalid volume',
                        'Close volume must be less than or equal to open volume',
                      );
                      return;
                    }

                    closeController.closePosition(
                      instrumentId: pos.instrumentId,
                      // side: pos.side,
                      side: position.side == 1 ? 2 : 1, // reverse side to close
                      // orderType: 1,
                      // orderQty: pos.positionInitialQty,
                      orderQty: closeQty,

                      
                      orderPrice: pos.orderPrice,
                      accountId: pos.accountId,
                      relatedPositionId: pos.positionId,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.bearish
                    ),
                    child: Column(
                      children: [
                        Text(
                          'CLOSE POSITION',
                          // style: TextStyle(
                          //   // color: Color(0xFFFFAB40),
                          //   color: AppColors.background,
                          //   fontSize: 16,
                          //   fontWeight: FontWeight.bold,
                          // ),
                  style: AppTextStyle.body_400.surface(Get.context!),

                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      // ),
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
            // style: const TextStyle(fontSize: 18),
            style: AppTextStyle.h3_400
          ),
          TextSpan(
            text: parts[1].substring(2),
            // style: const TextStyle(fontSize: 24),
                  style: AppTextStyle.h1_400,

          ),
        ],
      ),
    );
  }

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

}


