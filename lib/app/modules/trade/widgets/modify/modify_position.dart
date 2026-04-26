import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:fl_chart/fl_chart.dart';
import 'package:netdania/app/config/theme/app_color.dart';
import 'package:netdania/app/config/theme/app_textstyle.dart';
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

      if (c.slController.text.isEmpty){
        c.slController.text = stopPrice.toStringAsFixed(5);
      }

      if (c.tpController.text.isEmpty){
      c.tpController.text = limitPrice.toStringAsFixed(5);

      }
      // c.priceController.text = orderPrice.toStringAsFixed(5);
    });

   
    // c.symbol.value = symbol;
    // c.currentBuyPrice.value = currentBuyPrice;
    // c.currentSellPrice.value = currentSellPrice;
    // c.volume.value =
    //     position
    //         .positionQty; 
    // c.price.value = orderPrice;
    // c.sl.value = stopPrice; 
    // c.tp.value = limitPrice; 

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
// 
  /// ---------------- MOBILE / TABLET ----------------
  Widget _buildScaffold(
    BuildContext context,
    PlaceOrderController c,
    EdgeInsets padding,
  ) {
    return Scaffold(
      // backgroundColor: Colors.white,
      backgroundColor: AppColors.background(context),
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
      backgroundColor: AppColors.background(context),
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

              Expanded(
                  child: _buildFillPolicyDropdown(c, context),
                ),
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
                // final ticker = c.tradingController.getTicker(symbol);
                final ticker = c.tradingController.getTickerSafe(c.symbol.value);
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

            SizedBox(height: 14),
            Text(
              'Stop Loss or Take Profit you set must differ from market price by at least 250 points.Stop processsing is performed on the broker side',
              textAlign: TextAlign.center,
              // style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  style: AppTextStyle.small_400.textSecondary(context),

            ),
            SizedBox(height: 12,),
            Row(
              children: [
                Expanded(
                  child:GestureDetector(
                    onTap: (){
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
                      // stopPrice: position.stopPrice,
                      // limitPrice: position.limitPrice,
                      timeInForceId: 1,
                    );

                    },
                 
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.bearish
                    ),
                    child: Column(
                      children: [
                        Text('Modify',
                        // style: TextStyle(
                        //   color: AppColors.background,
                        //   fontSize: 16,
                        //   fontWeight: FontWeight.bold
                        // ),
                  style: AppTextStyle.body_400.surface(context),

                        )
                      ],
                    ),
                     ),
                  ))
              ],
            )
          ],
        ),
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
      backgroundColor: AppColors.background(context),
      // automaticallyImplyLeading: false,
      title: Column(
        children: [
          Row(
            children: [
              Text(
                'Modify position',
                // style: const TextStyle(
                //   // color: Colors.black,
                //   color: AppColors.textPrimary,
                //   fontSize: 18,
                // ),
                  style: AppTextStyle.h3_400.textPrimary(context),

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
            // final ticker = c.tradingController.getTickerSafe(symbol);
            final ticker = c.tradingController.getTickerSafe(c.symbol.value);

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
                        // style: TextStyle(
                        //   color: AppColors.textSecondary,
                        //   fontWeight: FontWeight.bold,
                        //   fontSize: 14,
                        // ),
                  style: AppTextStyle.medium_700.textSecondary(context),

                      ),
                      TextSpan(
                        // text: c.volume.value.toStringAsFixed(2),
                        // text: position.positionQty.toStringAsFixed(2),
                        text: _formatVolume(position.positionQty),
                        // style: TextStyle(
                        //   color: AppColors.textSecondary,
                        //   fontWeight: FontWeight.bold,
                        //   fontSize: 14,
                        // ),
                  style: AppTextStyle.medium_700.textSecondary(context),

                      ),

                      TextSpan(

                        text: instrument.code,
                        // style: const TextStyle(

                        //   color: AppColors.textSecondary,
                        //   fontWeight: FontWeight.bold,
                        //   fontSize: 14,
                        // ),
                        style: AppTextStyle.medium_700.textSecondary(context),
                      ),
                      TextSpan(
                        text: orderPrice.toStringAsFixed(5),

                        // style: const TextStyle(
                        //   // color: Colors.black,
                        //   color: AppColors.textSecondary,
                        //   fontWeight: FontWeight.bold,
                        //   fontSize: 14,
                        // ),
                        style: AppTextStyle.medium_700.textSecondary(context),
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
                '-',
                textAlign: TextAlign.center,
                // style: TextStyle(
                //   fontSize: 18,
                //   color: AppColors.info,
                // ),
                style: AppTextStyle.h3_400.info(),
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              textAlign: TextAlign.center,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
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
                // style: TextStyle(
                //   fontSize: 18,
                //   color: AppColors.info,
                // ),
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
            onChanged: (v) => c.selectedFillPolicy.value = v!,
            items: policies.map((val) {
              return DropdownMenuItem<String>(
                value: val,
                child: Text(
                  val,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
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
            // style: AppTextStyle.h3_400,
          ),
          TextSpan(
            text: parts[1].substring(2),
            style: const TextStyle(fontSize: 24),
            // style: AppTextStyle.h1_400,
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