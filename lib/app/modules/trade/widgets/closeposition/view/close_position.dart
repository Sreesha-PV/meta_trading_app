import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:fl_chart/fl_chart.dart';
import 'package:netdania/app/config/theme/app_color.dart';
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

      // bottomNavigationBar: _buildBottomBar(),
      // bottomNavigationBar: _buildBottomButtons(c),
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
            // Expanded(
            //   flex: 3,
            //   child: Container(
            //     padding: const EdgeInsets.all(16),
            //     decoration: BoxDecoration(
            //       color: Colors.grey[50],
            //       borderRadius: BorderRadius.circular(12),
            //       border: Border.all(color: Colors.grey[300]!),
            //     ),
            //     child: Obx(() {
            //       final data = c.tradingController.getPriceHistory(
            //         c.symbol.value,
            //       );
            //       if (data.isEmpty) {
            //         return const Center(
            //           child: Text("Waiting for live data..."),
            //         );
            //       }
            //       // return LineChartWidget(priceHistory: data);
            //     }),
            //   ),
            // ),
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
          // _buildOrderTypeDropdown(c),
          Transform.translate(
            offset: Offset(0, -4),
            child: Container(height: 1, color: Colors.grey[300]),
          ),
          const SizedBox(height: 8),
          _buildVolumeSelector(context, c),
          const SizedBox(height: 10),

          //           Obx(() {
          //             // final ticker = c.tradingController.getTicker(c.symbol.value);

          //             // final ticker = c.tradingController.getTickerSafe(symbol);

          //             // final sell = double.tryParse(ticker?['bid']?.toString() ?? '0') ?? 0;
          //             // final buy = double.tryParse(ticker?['ask']?.toString() ?? '0') ?? 0;

          //             //   final sell = (ticker?['bid'] ?? 0).toDouble();
          //             // final buy  = (ticker?['ask'] ?? 0).toDouble();

          //             // final sell = safeDouble(ticker?['bid']);
          //             // final buy = safeDouble(ticker?['ask']);

          //             // final color = c.tradingController.isPriceUp ? Colors.blue : Colors.red;
          //             final color =
          //                 c.tradingController.isPriceUp ? AppColors.up : AppColors.down;

          // final instrumentName = SymbolUtils.getInstrumentName(
          //               position.instrumentId,
          //             );
          //                  final symbolKey = PriceHelper.normalizeSymbol(instrumentName);
          //             final ticker = tradingController.tickers[symbolKey];

          //             final sell = safeDouble(ticker?['bid']);
          //             final buy = safeDouble(ticker?['ask']);
          //             return Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //               children: [
          //                 _formattedPrice(sell, color),
          //                 _formattedPrice(buy, color),
          //               ],
          //             );
          //           }),
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
              final prices = c.tradingController.getPriceHistory(
                c.symbol.value,
              );
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

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    PlaceOrderController c,
  ) {
    return AppBar(
      // backgroundColor: Colors.white,
      backgroundColor: AppColors.background,
      elevation: 0.5,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First line
            const Text(
              'Close Position',
              style: TextStyle(
                // color: Colors.black,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4),

            // Second line: symbol, side, volume, and live price
            Obx(() {
              // final ticker = c.tradingController.getTickerSafe(c.symbol.value);
              // final bid =
              //     double.tryParse(ticker?['bid']?.toString() ?? '0') ?? 0.0;
              // final ask =
              //     double.tryParse(ticker?['ask']?.toString() ?? '0') ?? 0.0;
              // final price = (bid + ask) / 2;

              // Side color & label — same as in OrderTile
              // final side = _getSideLabel(c.selectedOrderType.value);
              final side = _getSideLabel(position.side);
              // final isBuy = side == 'Buy';
              // final isBuy = position.side == 1;
              // final isSell = side == 'Sell';
              // final color = isBuy ? Colors.blue : Colors.red;
              // final color = isBuy ? AppColors.up : AppColors.down;
              return Row(
                children: [
                  // Symbol + Side + Volume
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$side ',
                          // text: _getSideLabel(side),
                          style: TextStyle(
                            // color: color,
                            color:  AppColors.textSecondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),

                        TextSpan(
                          text: c.volume.value.toStringAsFixed(2),
                          style: TextStyle(
                            // color: color,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),

                        TextSpan(
                          // text: '${c.symbol.value},',
                          text: instrument.code,
                          style: const TextStyle(
                            // color: Colors.black,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),

                        TextSpan(
                          text: entryPrice.toStringAsFixed(4),
                          style: const TextStyle(
                            // color: Colors.black,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // const SizedBox(width: 8),
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
      ),
    );
  }

  // / Helper to match OrderTile style
  // String _getSideLabel(String orderType) {
  //   if (orderType.toLowerCase().contains('buy')) return 'Buy';
  //   if (orderType.toLowerCase().contains('sell')) return 'Sell';
  //   return 'Unknown';
  // }

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
    final width = MediaQuery.of(context).size.width;

    // Responsive adjustments
    final bool isMobile = width < 600;
    final bool isTablet = width >= 600 && width < 1100;
    final bool isDesktop = width >= 1100;

    final double fontSize = isMobile ? 14 : (isTablet ? 15 : 16);
    final double spacing = isMobile ? 8 : (isTablet ? 10 : 12);
    final double volumeFontSize = isMobile ? 16 : (isTablet ? 18 : 20);

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Horizontal scrolling if too wide
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _volumeButton(c, '-0.5', -0.5, fontSize),
                    SizedBox(width: spacing),
                    _volumeButton(c, '-0.1', -0.1, fontSize),
                    SizedBox(width: spacing),
                    _volumeButton(c, '-0.01', -0.01, fontSize),
                    SizedBox(width: spacing),
                    Column(
                      children: [
                        Text(
                          c.volume.value.toStringAsFixed(2),
                          style: TextStyle(
                            // color: Colors.black,
                            // color: AppColors.background,
                            color: AppColors.textPrimary,
                            fontSize: volumeFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: spacing),
                    _volumeButton(c, '+0.01', 0.01, fontSize),
                    SizedBox(width: spacing),
                    _volumeButton(c, '+0.1', 0.1, fontSize),
                    SizedBox(width: spacing),
                    _volumeButton(c, '+0.5', 0.5, fontSize),
                  ],
                ),
              ),
            ),

            // Divider
            Container(
              margin: const EdgeInsets.only(top: 6),
              height: 1,
              width: double.infinity,
              color: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }

  /// Helper for volume buttons
  Widget _volumeButton(
    PlaceOrderController c,
    String label,
    double change,
    double fontSize,
  ) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: const Size(50, 30),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: () => c.changeVolume(change),
      child: Text(
        label,
        style: TextStyle(
          // color: Colors.blue,
          color: AppColors.info,
          fontSize: fontSize,
        ),
        overflow: TextOverflow.ellipsis,
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
            //  Colors.red,
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
            //  Colors.green,
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
                  // color: Colors.blue
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

  Widget _buildOrderTypeSelector(CloseController c) {
    const types = {1: 'Market Order', 2: 'Limit Order', 3: 'Stop Order'};

    return Obx(
      () => DropdownButton<int>(
        value: c.selectedOrderType.value,
        items:
            types.entries
                .map(
                  (e) =>
                      DropdownMenuItem<int>(value: e.key, child: Text(e.value)),
                )
                .toList(),
        onChanged: (v) {
          if (v != null) c.selectedOrderType.value = v;
        },
      ),
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
            'Attention! The trade will be executed at market condition,difference with requested price may be significant!',
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
                    //      orderController.removeProfitableActiveOrders(
                    //   tradingController.tickers,
                    // );

                    //  orderController.closeOrder(order);

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
                  child: Column(
                    children: const [
                      Text(
                        'CLOSE POSITION',
                        style: TextStyle(
                          // color: Color(0xFFFFAB40),
                          color: AppColors.iconText,
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
}


// final double closeQty = c.volume.value;
// final double openQty = position.positionQty;

// if (closeQty <= 0 || closeQty > openQty) {
//   Get.snackbar(
//     'Invalid volume',
//     'Close volume must be less than or equal to open volume',
//   );
//   return;
// }

