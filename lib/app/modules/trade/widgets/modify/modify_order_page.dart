import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netdania/app/config/theme/app_color.dart';
import 'package:netdania/app/config/theme/app_textstyle.dart';
import 'package:netdania/app/getX/modify_order_getx.dart';
import 'package:netdania/app/getX/trading_getX.dart';
import 'package:netdania/app/models/instrument_model.dart';
import 'package:netdania/app/models/order_get_model.dart';
import 'package:netdania/app/modules/order/components/date_picker.dart'
    show DatePickerSheet;
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
    // c.priceController.text = order.orderPrice.toStringAsFixed(5);
    if (c.priceController.text.isEmpty) {
      c.priceController.text = order.orderPrice.toStringAsFixed(5);
    }

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
    );
  }

  /// ---------------- MOBILE / TABLET ----------------
  Widget _buildScaffold(
    BuildContext context,
    PlaceOrderController c,
    EdgeInsets padding,
  ) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: _buildAppBar(context, c),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
        child: _buildOrderBody(context, c, padding),
      ),
    );
  }

  /// ---------------- DESKTOP ----------------

  Widget _buildOrderBody(
    BuildContext context,
    PlaceOrderController c,
    EdgeInsets padding,
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    'Price',
                    // style: TextStyle(
                    //   color: AppColors.textPrimary,
                    //   fontSize: 17,
                    //   fontWeight: FontWeight.w400,
                    // ),
                  style: AppTextStyle.h3_400.textPrimary(context),

                  ),
                ),
                Expanded(child: _buildPriceInput(c)),
              ],
            ),
            SizedBox(height: 16),
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
                  child: _priceAdjuster(
                    c,
                    "SL",
                    AppColors.bearish,
                    c.adjustSl,
                    c.slController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
            ),

            const SizedBox(height: 16),

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

                Expanded(child: _buildExpiryDropDown(c, context)),
              ],
            ),

            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.lightNeutral,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Obx(() {
                final symbol = c.symbol.value;
                final ticker = c.tradingController.getTicker(symbol);
                final bidRaw = ticker?['bid'];
                final askRaw = ticker?['ask'];
                final dotPositionRaw = ticker?['dot_position'];
                final sell = double.tryParse(bidRaw?.toString() ?? '0') ?? 0;
                final buy = double.tryParse(askRaw?.toString() ?? '0') ?? 0;
                final dotPosition =
                    int.tryParse(dotPositionRaw?.toString() ?? '5') ?? 5;
                final color =
                    c.tradingController.isPriceUp
                        ? AppColors.bullish
                        : AppColors.bearish;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _formattedPrice(sell, color),
                    _formattedPrice(buy, color),
                  ],
                );
              }),
            ),
            const SizedBox(height: 16),

            SizedBox(height: 12),
            _buildBottomButtons(c),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    PlaceOrderController c,
  ) {
    return AppBar(
      backgroundColor: AppColors.background(context),
      elevation: 0.5,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Modify Order',
            //  style : TextStyle(
            //     color: AppColors.textPrimary,
            //     fontWeight: FontWeight.bold,
            //     fontSize: 18,
            //   ),
                  style: AppTextStyle.h3_500.textPrimary(context),

            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: _getSideLabel(order.side),
                    style: TextStyle(
                      color: order.side == 1 ? AppColors.bullish : AppColors.bearish,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: ' ${order.orderQty.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: order.side == 1 ? AppColors.bullish : AppColors.bearish,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: ' ${instrument.code}',
                    // style: const TextStyle(
                    //   color: AppColors.textPrimary,
                    //   fontWeight: FontWeight.bold,
                    //   fontSize: 14,
                    // ),
                  style: AppTextStyle.medium_400.textPrimary(context),

                  ),
                  TextSpan(
                    text: ' @ ${order.orderPrice.toStringAsFixed(5)}',
                    // style: const TextStyle(
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
            SizedBox(
              width: 28,
              child: GestureDetector(
                onTap: () => onChange(-0.1),
                child: Text(
                  '⎼',
                  textAlign: TextAlign.center,
                  // style: TextStyle(fontSize: 18, color: AppColors.info),
                  style: AppTextStyle.h3_400.info(),

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
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 6),
                ),
              ),
            ),
            SizedBox(
              width: 28,
              child: GestureDetector(
                onTap: () => onChange(0.1),
                child: Text(
                  '+',
                  textAlign: TextAlign.center,
                  // style: TextStyle(fontSize: 18, color: AppColors.info),
                  style: AppTextStyle.h3_400.info(),

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

  Widget _buildPriceInput(PlaceOrderController c) {
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                c.adjustPrice(-0.1);
              },
              child: Text(
                '⎼',
                // style: TextStyle(fontSize: 24, color: AppColors.info),
                  style: AppTextStyle.h1_400.info(),

              ),
            ),
            Expanded(
              child: TextField(
                controller: c.priceController,
                textAlign: TextAlign.center,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  hintText: 'Not Set',
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
                onChanged: (_) => c.syncTextWithPrice(),
              ),
            ),
            GestureDetector(
              onTap: () {
                c.adjustPrice(0.1);
              },
              child: Text(
                '+',
                // style: TextStyle(fontSize: 24, color: AppColors.bullish),
                  style: AppTextStyle.h1_400.bullish(),

              ),
            ),
          ],
        ),
      ],
    );
  }

  // Widget _buildFillPolicyDropdown(
  //   PlaceOrderController c,
  //   BuildContext context,
  // ) {
  //   const policies = ['Fill or Kill', 'Immediate or Cancel'];

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Obx(
  //         () => DropdownButtonHideUnderline(
  //           child: DropdownButton<String>(
  //             isExpanded: true,
  //             value: c.selectedFillPolicy.value,
  //             onChanged: (v) => c.selectedFillPolicy.value = v!,
  //             items:
  //                 policies.map((val) {
  //                   return DropdownMenuItem<String>(
  //                     value: val,
  //                     child: Text(val, overflow: TextOverflow.ellipsis),
  //                   );
  //                 }).toList(),
  //           ),
  //         ),
  //       ),
  //       Container(
  //         height: 1.5,
  //         color: Colors.grey[300],
  //         margin: const EdgeInsets.only(top: 6),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildExpiryDropDown(PlaceOrderController c, BuildContext context) {
    // const expirations = ['GTC', 'Today', 'Specified', 'Specified day'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row(
        //   mainAxisSize: MainAxisSize.min, // shrink-wrap row
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     const Text(
        //       'Expiration:',
        //       style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
        //     ),
        //     SizedBox(width: 16), // optional spacing
            // Flexible(
            //   child: 
              Obx(
                () => DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: c.selectedExpiration.value,
                    isExpanded: true,
                    alignment: Alignment.centerRight,
                    dropdownColor: AppColors.background(context),

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
                      DropdownMenuItem(
                        value: 'Specified',
                        child: Text('Specified'),
                      ),
                      DropdownMenuItem(
                        value: 'Specified day',
                        child: Text('Specified day'),
                      ),
                    ],
                  ),
                ),
              ),
            // ),
        //   ],
        // ),
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

      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.info,
                foregroundColor: AppColors.surface(Get.context!),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                final newOrderPrice = double.tryParse(c.priceController.text);
                final newSL = double.tryParse(c.slController.text);
                final newTP = double.tryParse(c.tpController.text);

                if (newOrderPrice == null || newOrderPrice <= 0) {
                  Get.snackbar(
                    "Error",
                    "Please enter a valid order price",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.bearish,
                    colorText: AppColors.surface(Get.context!),
                  );
                  return;
                }

                final tif = mapExpirationToTIF(c.selectedExpiration.value);

                modifyorderController.modifyOrder(
                  accountId: order.accountId,
                  pendingOrderId: order.pendingOrderId,
                  orderPrice: newOrderPrice,
                  stopPrice: newSL ?? 0,
                  limitPrice: newTP ?? 0,
                  timeInForceId: tif,
                  status: order.orderStatus,
                  expiryDateTime: c.expirationDate.value,
                );

                Get.back();
              },
              child:  Text(
                'MODIFY ORDER',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  // style: AppTextStyle.body_700,

              ),
            ),
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
            // style: AppTextStyle.h3_400
          ),
          TextSpan(
            text: parts[1].substring(2),
            style: const TextStyle(fontSize: 24),
                  // style: AppTextStyle.h1_400.bullish,

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
