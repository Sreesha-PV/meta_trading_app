// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:netdania/app/config/theme/app_color.dart';
// import 'package:netdania/app/getX/order_getX.dart';
// import 'package:netdania/app/getX/trading_getX.dart';
// import 'package:netdania/app/models/instrument_model.dart';
// import 'package:netdania/app/models/order_get_model.dart';
// import 'package:netdania/app/models/order_model.dart';
// import 'package:netdania/app/modules/order/controller/place_order_controller.dart';
// import 'package:netdania/utils/responsive_layout_helper.dart';

// /// ---------------- VIEW ---------------- ///
// class ModifyOrderPage extends StatelessWidget {
//   final String symbol;
//   final double currentBuyPrice;
//   final double currentSellPrice;
//   final PendingOrder order;
//   final InstrumentModel instrument;

//   final OrderController orderController = Get.put(OrderController());
//   final TradingChartController tradingController = Get.put(
//     TradingChartController(),
//   );

//   ModifyOrderPage({
//     super.key,
//     required this.symbol,
//     required this.currentBuyPrice,
//     required this.currentSellPrice,
//     required this.order,
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
//     final c =
//         Get.isRegistered<PlaceOrderController>()
//             ? Get.find<PlaceOrderController>()
//             : Get.put(PlaceOrderController());

//     c.symbol.value = symbol;
//     c.currentBuyPrice.value = currentBuyPrice;
//     c.currentSellPrice.value = currentSellPrice;

//     // Initialize with order values
//     c.priceController.text = order.orderPrice.toStringAsFixed(5);
//     // c.slController.text = order.stopLoss?.toStringAsFixed(5) ?? '';
//     // c.tpController.text = order.takeProfit?.toStringAsFixed(5) ?? '';
//     c.slController.text = 0.0.toStringAsFixed(
//       5,
//     ); //order.stopLoss?.toStringAsFixed(5) ?? '';
//     c.tpController.text = 0.0.toStringAsFixed(5);

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
//           Transform.translate(
//             offset: const Offset(0, -4),
//             child: Container(height: 1, color: Colors.grey[300]),
//           ),
//           const SizedBox(height: 16),

//           // Current Market Prices
//           Obx(() {
//             final symbolKey = instrument.code.toUpperCase();
//             final ticker = tradingController.getTickerSafe(symbolKey);

//             if (ticker == null) {
//               return const Text('—');
//             }

//             final sell = safeDouble(ticker['bid']);
//             final buy = safeDouble(ticker['ask']);

//             final isUp = tradingController.isPriceUpForSymbol(symbolKey);
//             final color = isUp ? AppColors.up : AppColors.down;
//             return Column(
//               children: [
//                 const Text(
//                   'Current Market Price',
//                   style: TextStyle(
//                     color: AppColors.textPrimary,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Column(
//                       children: [
//                         const Text(
//                           'Sell',
//                           style: TextStyle(fontSize: 12, color: Colors.grey),
//                         ),
//                         _formattedPrice(sell, color),
//                       ],
//                     ),
//                     Column(
//                       children: [
//                         const Text(
//                           'Buy',
//                           style: TextStyle(fontSize: 12, color: Colors.grey),
//                         ),
//                         _formattedPrice(buy, color),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             );
//           }),

//           const SizedBox(height: 24),

//           // Order Price Adjuster
//           _priceAdjuster(
//             c,
//             "Order Price",
//             AppColors.info,
//             c.adjustPrice,
//             c.priceController,
//           ),

//           const SizedBox(height: 16),

//           // SL/TP Row
//           _buildSLTPRow(c),

//           const Spacer(),

//           // Bottom Buttons
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
//       backgroundColor: AppColors.background,
//       elevation: 0.5,
//       titleSpacing: 0,
//       title: Padding(
//         padding: const EdgeInsets.only(left: 8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Modify Order',
//               style: TextStyle(
//                 color: AppColors.textPrimary,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//               ),
//             ),
//             const SizedBox(height: 4),
//             RichText(
//               text: TextSpan(
//                 children: [
//                   TextSpan(
//                     text: _getSideLabel(order.side),
//                     style: TextStyle(
//                       color: order.side == 1 ? AppColors.up : AppColors.down,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14,
//                     ),
//                   ),
//                   TextSpan(
//                     text: ' ${order.orderQty.toStringAsFixed(2)}',
//                     style: TextStyle(
//                       color: order.side == 1 ? AppColors.up : AppColors.down,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14,
//                     ),
//                   ),
//                   TextSpan(
//                     text: ' ${instrument.code}',
//                     style: const TextStyle(
//                       color: AppColors.textPrimary,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14,
//                     ),
//                   ),
//                   TextSpan(
//                     text: ' @ ${order.orderPrice.toStringAsFixed(5)}',
//                     style: const TextStyle(
//                       color: AppColors.textPrimary,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
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

//   Widget _buildSLTPRow(PlaceOrderController c) {
//     return Row(
//       children: [
//         Expanded(
//           child: _priceAdjuster(
//             c,
//             "Stop Loss",
//             AppColors.down,
//             c.adjustSl,
//             c.slController,
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: _priceAdjuster(
//             c,
//             "Take Profit",
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
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 14,
//             color: AppColors.textPrimary,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Container(
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey[300]!),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Row(
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.remove, color: AppColors.info),
//                 onPressed: () => onChange(-0.0001),
//                 padding: const EdgeInsets.all(8),
//                 constraints: const BoxConstraints(),
//               ),
//               Expanded(
//                 child: TextField(
//                   controller: controller,
//                   textAlign: TextAlign.center,
//                   keyboardType: const TextInputType.numberWithOptions(
//                     decimal: true,
//                   ),
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   decoration: const InputDecoration(
//                     border: InputBorder.none,
//                     isDense: true,
//                     contentPadding: EdgeInsets.symmetric(vertical: 12),
//                   ),
//                 ),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.add, color: AppColors.info),
//                 onPressed: () => onChange(0.0001),
//                 padding: const EdgeInsets.all(8),
//                 constraints: const BoxConstraints(),
//               ),
//             ],
//           ),
//         ),
//         Container(
//           height: 2,
//           color: color,
//           margin: const EdgeInsets.only(top: 4),
//         ),
//       ],
//     );
//   }

//   Widget _buildBottomButtons(PlaceOrderController c) {
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
//             'Modifying order price, stop loss, or take profit',
//             style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.grey[300],
//                     foregroundColor: AppColors.textPrimary,
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   onPressed: () => Get.back(),
//                   child: const Text(
//                     'CANCEL',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.info,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   onPressed: () {
//                     final newOrderPrice = double.tryParse(
//                       c.priceController.text,
//                     );
//                     final newSL = double.tryParse(c.slController.text);
//                     final newTP = double.tryParse(c.tpController.text);

//                     if (newOrderPrice == null || newOrderPrice <= 0) {
//                       Get.snackbar(
//                         "Error",
//                         "Please enter a valid order price",
//                         snackPosition: SnackPosition.BOTTOM,
//                         backgroundColor: AppColors.down,
//                         colorText: Colors.white,
//                       );
//                       return;
//                     }

//                     orderController.modifyOrder(
//                       accountId: order.accountId,
//                       pendingOrderId: order.pendingOrderId,
//                       newOrderPrice: newOrderPrice,
//                       newStopLoss: newSL,
//                       newTakeProfit: newTP,
//                     );

//                     Get.back();
//                   },
//                   child: const Text(
//                     'MODIFY ORDER',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
// }

// test- time in force



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netdania/app/config/theme/app_color.dart';
import 'package:netdania/app/getX/modify_order_getx.dart';
import 'package:netdania/app/getX/trading_getX.dart';
import 'package:netdania/app/models/instrument_model.dart';
import 'package:netdania/app/models/order_get_model.dart';
import 'package:netdania/app/modules/order/components/date_picker.dart' show DatePickerSheet;
import 'package:netdania/app/modules/order/components/datetime_picker_sheet.dart';
import 'package:netdania/app/modules/order/controller/place_order_controller.dart';
import 'package:netdania/utils/responsive_layout_helper.dart';

/// ---------------- VIEW ---------------- ///
class ModifyOrderPage extends StatelessWidget {
  final String symbol;
  final double currentBuyPrice;
  final double currentSellPrice;
  final PendingOrder order;
  final InstrumentModel instrument;

  // final OrderController orderController = Get.put(OrderController());
  final ModifyOrderController modifyorderController = Get.put(
    ModifyOrderController(),
  );
  final TradingChartController tradingController = Get.put(
    TradingChartController(),
  );

  ModifyOrderPage({
    super.key,
    required this.symbol,
    required this.currentBuyPrice,
    required this.currentSellPrice,
    required this.order,
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
    final c =
        Get.isRegistered<PlaceOrderController>()
            ? Get.find<PlaceOrderController>()
            : Get.put(PlaceOrderController());

    c.symbol.value = symbol;
    c.currentBuyPrice.value = currentBuyPrice;
    c.currentSellPrice.value = currentSellPrice;

    // Initialize with order values
    c.priceController.text = order.orderPrice.toStringAsFixed(5);
    // c.slController.text = order.stopLoss?.toStringAsFixed(5) ?? '';
    // c.tpController.text = order.takeProfit?.toStringAsFixed(5) ?? '';
    c.slController.text = 0.0.toStringAsFixed(
      5,
    ); //order.stopLoss?.toStringAsFixed(5) ?? '';
    c.tpController.text = 0.0.toStringAsFixed(5);

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
          ],
        ),
      ),
    );
  }

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
          Transform.translate(
            offset: const Offset(0, -4),
            child: Container(height: 1, color: Colors.grey[300]),
          ),
          const SizedBox(height: 16),

          // Current Market Prices
          Obx(() {
            final symbolKey = instrument.code.toUpperCase();
            final ticker = tradingController.getTickerSafe(symbolKey);

            if (ticker == null) {
              return const Text('—');
            }

            final sell = safeDouble(ticker['bid']);
            final buy = safeDouble(ticker['ask']);

            final isUp = tradingController.isPriceUpForSymbol(symbolKey);
            final color = isUp ? AppColors.up : AppColors.down;
            return Column(
              children: [
                const Text(
                  'Current Market Price',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        const Text(
                          'Sell',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        _formattedPrice(sell, color),
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          'Buy',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        _formattedPrice(buy, color),
                      ],
                    ),
                  ],
                ),
              ],
            );
          }),

          const SizedBox(height: 24),

          // Order Price Adjuster
          _priceAdjuster(
            c,
            "Order Price",
            AppColors.info,
            c.adjustPrice,
            c.priceController,
          ),

          const SizedBox(height: 16),

          // SL/TP Row
          _buildSLTPRow(c),
          SizedBox(height: 10),
          _buildExpiryDropDown(c, context),

          const Spacer(),

          // Bottom Buttons
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
      backgroundColor: AppColors.background,
      elevation: 0.5,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Modify Order',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: _getSideLabel(order.side),
                    style: TextStyle(
                      color: order.side == 1 ? AppColors.up : AppColors.down,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: ' ${order.orderQty.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: order.side == 1 ? AppColors.up : AppColors.down,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: ' ${instrument.code}',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: ' @ ${order.orderPrice.toStringAsFixed(5)}',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
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

  Widget _buildSLTPRow(PlaceOrderController c) {
    return Row(
      children: [
        Expanded(
          child: _priceAdjuster(
            c,
            "Stop Loss",
            AppColors.down,
            c.adjustSl,
            c.slController,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _priceAdjuster(
            c,
            "Take Profit",
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove, color: AppColors.info),
                onPressed: () => onChange(-0.0001),
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  textAlign: TextAlign.center,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: AppColors.info),
                onPressed: () => onChange(0.0001),
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
        Container(
          height: 2,
          color: color,
          margin: const EdgeInsets.only(top: 4),
        ),
      ],
    );
  }

  Widget _buildExpiryDropDown(PlaceOrderController c, BuildContext context) {
    // const expirations = ['GTC', 'Today', 'Specified', 'Specified day'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min, // shrink-wrap row
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Expiration:',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
            SizedBox(width: 16), // optional spacing
            Flexible(
              // ✅ Wrap dropdown in Flexible to prevent unbounded width error
              // child: Obx(
              //   () => DropdownButtonHideUnderline(
              //     child: DropdownButton<String>(
              //       value: c.selectedExpiration.value,
              //       // value: modifyorderController.selectedExpiration.value,
              //       isExpanded: true,
              //       alignment: Alignment.centerRight,
              //       dropdownColor: AppColors.background,

              //       onChanged: (v) async {
              //         if (v == null) return;

              //         switch (v) {
              //           case 'GTC':
              //           case 'Today':
              //             c.selectedExpiration.value = v;
              //             break;
              //           case 'Specified':
                        
              //             c.selectedExpiration.value = v;
              //             // modifyorderController.selectedExpiration.value = v;
              //             showDateTimePicker(context);
              //             break;
              //           case 'Specified day':
                          
              //             c.selectedExpiration.value = v;
             
              //             showDatePicker(context);
              //             break;
              //         }
              //       },
              //       items: const [
              //         DropdownMenuItem(value: 'GTC', child: Text('GTC')),
              //         DropdownMenuItem(value: 'Today', child: Text('Today')),
              //         DropdownMenuItem(
              //           value: 'Specified',
              //           child: Text('Specified'),
              //         ),
              //         DropdownMenuItem(
              //           value: 'Specified day',
              //           child: Text('Specified day'),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

            child:  Obx(
  () => DropdownButtonHideUnderline(
    child: DropdownButton<String>(
      value: c.selectedExpiration.value,
      isExpanded: true,
      alignment: Alignment.centerRight,
      dropdownColor: AppColors.background,

      // THIS controls what is shown when selected
      selectedItemBuilder: (context) {
        return ['GTC', 'Today', 'Specified', 'Specified day']
            .map(
              (_) => Align(
                alignment: Alignment.centerRight,
                child: Text(
                  c.expirationDisplayValue,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList();
      },

      onChanged: (v) async {
        if (v == null) return;

        c.selectedExpiration.value = v;

        if (v == 'Specified') {
          await showDateTimePicker(context);
        } else if (v == 'Specified day') {
          await showDatePicker(context);
        } else {
          c.expirationDate.value = null;
        }
      },

      items: const [
        DropdownMenuItem(value: 'GTC', child: Text('GTC')),
        DropdownMenuItem(value: 'Today', child: Text('Today')),
        DropdownMenuItem(value: 'Specified', child: Text('Specified')),
        DropdownMenuItem(value: 'Specified day', child: Text('Specified day')),
      ],
    ),
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
            'Modifying order price, stop loss, or take profit',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: AppColors.textPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Get.back(),
                  child: const Text(
                    'CANCEL',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.info,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    final newOrderPrice = double.tryParse(
                      c.priceController.text,
                    );
                    final newSL = double.tryParse(c.slController.text);
                    final newTP = double.tryParse(c.tpController.text);

                    if (newOrderPrice == null || newOrderPrice <= 0) {
                      Get.snackbar(
                        "Error",
                        "Please enter a valid order price",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.down,
                        colorText: Colors.white,
                      );
                      return;
                    }

                    // orderController.modifyOrder(
                    //   accountId: order.accountId,
                    //   pendingOrderId: order.pendingOrderId,
                    //   newOrderPrice: newOrderPrice,
                    //   newStopLoss: newSL,
                    //   newTakeProfit: newTP,
                    //   // timeInForceId: order.timeInForceId
                    // );
                    // modifyorderController.modifyOrder(
                    //   accountId: order.accountId,
                    //   pendingOrderId: order.pendingOrderId,
                    //   orderPrice: newOrderPrice,
                    //   stopPrice: newSL!,
                    //   limitPrice: newTP!,
                    //   timeInForceId: order.timeInForceId
                    //   // timeInForceId: 4
                    //   );

                    final tif = mapExpirationToTIF(c.selectedExpiration.value);

                    modifyorderController.modifyOrder(
                      accountId: order.accountId,
                      pendingOrderId: order.pendingOrderId,
                      orderPrice: newOrderPrice,
                      stopPrice: newSL ?? 0,
                      limitPrice: newTP ?? 0,
                      timeInForceId: tif, 
                      status: order.orderStatus,
                      expiryDateTime:c.expirationDate.value
                      
                    );


                    Get.back();
                  },
                  child: const Text(
                    'MODIFY ORDER',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

  Future<void> showDatePicker(BuildContext context) async {
    final result = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const DatePickerSheet(),
    );

    if (result != null) {
      final c = Get.find<PlaceOrderController>();
      c.expirationDate.value = result;
    }
  }

  Future<void> showDateTimePicker(BuildContext context) async {
    final result = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const DateTimePickerSheet(),
    );

    if (result != null) {
      final c = Get.find<PlaceOrderController>();
      c.expirationDate.value = result;
    }
  }

  int mapExpirationToTIF(String expiration) {
    switch (expiration) {
      case 'GTC':
        return 1;
      case 'Today':
        return 5; // Day
      case 'Specified day':
        return 3; // GTD
      case 'Specified':
        return 4; // GTDT
      default:
        return 1;
    }
  }
}



