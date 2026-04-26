import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netdania/app/config/theme/app_color.dart';
import 'package:netdania/app/config/theme/app_textstyle.dart';
import 'package:netdania/app/getX/order_getX.dart';
import 'package:netdania/app/getX/position_getx.dart';
import 'package:netdania/app/getX/trading_getX.dart';
import 'package:netdania/app/models/instrument_model.dart';
import 'package:netdania/app/models/positions_model.dart';
import 'package:netdania/app/modules/order/view/place_order.dart';
// import 'package:netdania/app/modules/order/view/place_order.dart';
// import 'package:netdania/app/modules/trade/components/pending_ordertile.dart';
import 'package:netdania/app/modules/trade/widgets/closeposition/view/close_position.dart' hide TextStyle;
import 'package:netdania/app/modules/trade/widgets/modify/modify_position.dart';
// import 'package:netdania/screens/services/instrument_fetch_services.dart';
import 'package:netdania/app/getX/modify_limit_getx.dart';
import 'package:netdania/utils/profit_calculator.dart';
import 'package:netdania/app/modules/trade/components/animated_profit_text.dart';

class OrderTile extends StatelessWidget {
  // final OrderRequestModel order;
  final Position position;
  // final PendingOrder fetchOrder;
  // final ModifyOrderController modify;
  // final ModifyOrderModel modify;
  // final int pendingOrderId;
  final InstrumentModel instrument;
  final int index;
  final double currentPrice;
  final bool isExpanded;
  final VoidCallback onToggleExpand;
  final String symbol;
  final double contractSize;
  // ignore: non_constant_identifier_names
  final int pl_calc_mode_id;
  final int decimalPlaces;
  final double pointValue;
  final double currencyRate;

  final PositionsController positionController =
      Get.find<PositionsController>();
  OrderTile({
    super.key,
    required this.position,
    // required this.fetchOrder,
    // required this.modify,
    required this.instrument,
    required this.index,
    required this.currentPrice,
    required this.isExpanded,
    required this.onToggleExpand,
    required this.symbol,
    required this.contractSize,
    // ignore: non_constant_identifier_names
    required this.pl_calc_mode_id,
    required this.decimalPlaces,
    required this.pointValue,
    required this.currencyRate,
    // required this.pendingOrderId,
  });
  
  @override
  Widget build(BuildContext context) {
    final isBuy = position.side == 1;
    final entryPrice = position.orderPrice;
    final volume = position.positionQty;

    final tradingController = Get.find<TradingChartController>();
    final ticker = tradingController.tickers[instrument.code.toUpperCase()];

    final profit = calculateProfit(
      entryPrice: entryPrice,
      currentPrice: currentPrice,
      positionQty: volume,
      side: position.side,
      contractSize: contractSize,
      pl_calc_mode_id: pl_calc_mode_id,
      decimalPlaces: decimalPlaces,
      pointValue: pointValue,
      currencyRate: currencyRate,
    );

    // print("ShowProfit $profit");
    final profitColor = getProfitColor(profit);
    void showPositionActions(BuildContext context) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        ),
        builder: (context) {
          return Obx(() {
            final orderController = Get.find<OrderController>();
            final positionsController = Get.find<PositionsController>();
            final realPosition = positionsController.findPosition(
              instrumentId: position.instrumentId,
              side: position.side,
              accountId: position.accountId,
            );

            if (realPosition == null) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "Position not found",
                  style: TextStyle(color: Colors.red),
                ),
              );
            }
            final pendingOrder = orderController.getRelatedPendingOrder(
              realPosition,
            );

            // final stopLoss = pendingOrder?.stopPrice;

            // final takeProfit = pendingOrder?.limitPrice;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                children: [
                  Container(
                    child: Column(
                      children: [
                        ListTile(
                          title: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: instrument.code,
                                  // style: const TextStyle(
                                  //   color: AppColors.textPrimary,
                                  //   fontWeight: FontWeight.bold,
                                  // ),
                                  style: AppTextStyle.h2_500.textPrimary(context)
                                ),
                                TextSpan(
                                  text: ' ${_getSideLabel(position.side)} ',
                                  style: TextStyle(
                                    color:
                                        isBuy ? AppColors.bullish : AppColors.bearish,
                                    fontWeight: FontWeight.bold,fontSize: 16
                                  ),
                                ),
                                TextSpan(
                                  text: _formatVolume(position.positionQty),
                                  style: TextStyle(
                                    color:
                                        isBuy ? AppColors.bullish : AppColors.bearish,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    entryPrice.toStringAsFixed(4),
                                    // style: const TextStyle(
                                    //   fontSize: 14,
                                    //   color: AppColors.textSecondary,
                                    //   fontWeight: FontWeight.bold,
                                    // ),
                                    style: AppTextStyle.medium_400.textSecondary(context),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.arrow_right_alt_rounded,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),

                                  Text(
                                    currentPrice == 0.0
                                        ? 'Loading...'
                                        : currentPrice.toStringAsFixed(4),
                                    // style: const TextStyle(
                                    //   fontSize: 16,
                                    //   fontWeight: FontWeight.w400,
                                    //   color: AppColors.textSecondary,
                                    // ),
                                    style: AppTextStyle.body_400.textPrimary(context)

                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),

                              Obx(() {
                                final positionsController =
                                    Get.find<PositionsController>();
                                final stopLoss = positionsController.getSL(
                                  position.positionId,
                                );
                                final takeProfit = positionsController.getTP(
                                  position.positionId,
                                );
                               

                                return
                                  Row(
                                  children: [
                              
                                    Text(
                                      
                                      // 'S/L: ${stopLoss.toStringAsFixed(decimalPlaces)}',
                                      'S/L: ${position.stopPrice.toStringAsFixed(decimalPlaces)}',

                                      style: TextStyle(
                                        color: AppColors.textSecondary(context),
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Text(
                                      // 'T/P: ${takeProfit.toStringAsFixed(decimalPlaces)}',
                                      'T/P: ${position.limitPrice.toStringAsFixed(decimalPlaces)}',

                                      style: TextStyle(
                                        color: AppColors.textSecondary(context),
                                      ),
                                    ),
                                  ],
                                );

  //                               final stopLoss =
  //     positionsController.getSL(position.positionId) ?? 0.0;
  // final takeProfit =
  //     positionsController.getTP(position.positionId) ?? 0.0;

  // return Row(
  //   children: [
  //     Text(
  //       'S/L: ${stopLoss.toStringAsFixed(decimalPlaces)}',
  //       style: TextStyle(color: AppColors.textSecondary),
  //     ),
  //     SizedBox(width: 16),
  //     Text(
  //       'T/P: ${takeProfit.toStringAsFixed(decimalPlaces)}',
  //       style: TextStyle(color: AppColors.textSecondary),
  //     ),
  //   ],
  // );
                              }),

                              Row(
                                children: [
                                  Text(
                                    'Open: ${_formatDate(position.positionDate)}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),

                          trailing: Column(
                            children: [
                              Text(
                                profit.toStringAsFixed(2),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: profitColor,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              Text(
                                '#${position.positionId}',
                                style: TextStyle(
                                  color: AppColors.textSecondary(context),
                                ),
                              ),
                              // Text(_formatDate(position.positionDate))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    // leading: Icon(Icons.edit, color: AppColors.info),
                    title: const Text(
                      'Close Position',
                      style: TextStyle(color: AppColors.bearish),
                      textAlign: TextAlign.center,
                    ),
                    onTap: () async {
                      Get.back();
                      final positionsController =
                          Get.find<PositionsController>();
                      final realPosition = positionsController.findPosition(
                        instrumentId: position.instrumentId,
                        side: position.side,
                        accountId: position.accountId,
                      );

                      if (realPosition == null) {
                        Get.snackbar(
                          "Error",
                          "No open position found to close",
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        return;
                      }

                      Get.to(
                        () => ClosePositionPage(
                          symbol: symbol,
                          currentBuyPrice:
                              double.tryParse(
                                ticker?['a']?.toString() ?? '0',
                              ) ??
                              0,
                          currentSellPrice:
                              double.tryParse(
                                ticker?['b']?.toString() ?? '0',
                              ) ??
                              0,
                          entryPrice: realPosition.orderPrice,
                          position: realPosition,
                          instrument: instrument,
                        ),
                        arguments: {
                          'side': realPosition.side,
                          'volume': realPosition.positionQty,
                        },
                      );
                    },
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.grey[300]),
                  ListTile(
                    // leading: Icon(Icons.edit, color: AppColors.info),
                    title: const Text(
                      'Modify Position',
                      style: TextStyle(color: AppColors.info),
                      textAlign: TextAlign.center,
                    ),
                    onTap: () async {
                      Get.back();
                      final positionsController =
                          Get.find<PositionsController>();
                      final orderController = Get.find<OrderController>();

                      // Find the real open position
                      final realPosition = positionsController.findPosition(
                        instrumentId: position.instrumentId,
                        side: position.side,
                        accountId: position.accountId,
                      );

                      if (realPosition == null) {
                        Get.snackbar("Error", "No open position found");
                        return;
                      }

                      await orderController.fetchPendingOrders(
                        realPosition.accountId,
                        // realPosition.status
                      );

                      // final pendingOrder = orderController
                      //     .getRelatedPendingOrder(realPosition);

                      print("Found pending order: $pendingOrder");

                      final modifyController = Get.put(ModifyLimitController());
                      final result = await modifyController.findTpAndSl(
                        accountId: position.accountId,
                        // status: position.status,
                        positionId: position.positionId,
                      );

                      print('TP/SL Result: $result');

                      final stopLoss = result['stopLoss'];
                      final takeProfit = result['takeProfit'];

                      positionsController.updateSL(
                        position.positionId,
                        stopLoss ?? 0,
                      );
                      positionsController.updateTP(
                        position.positionId,
                        takeProfit ?? 0,
                      );

                      // print("Stop Loss value: $stopLoss");
                      // print("Take Profit value: $takeProfit");

                      Get.to(
                        () => ModifyPositionPage(
                          symbol: symbol,
                          // currentBuyPrice: currentBuyPrice,
                          // currentSellPrice: currentSellPrice,
                          currentBuyPrice:
                              double.tryParse(
                                ticker?['a']?.toString() ?? '0',
                              ) ??
                              0,
                          currentSellPrice:
                              double.tryParse(
                                ticker?['b']?.toString() ?? '0',
                              ) ??
                              0,
                          orderPrice: realPosition.orderPrice,
                          stopPrice: stopLoss ?? 0.0,
                          limitPrice: takeProfit ?? 0.0,
                          position: realPosition,
                          // position: position,
                          instrument: instrument,
                        ),
                        arguments: {"pendingOrder": pendingOrder},
                      );
                    },
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.grey[300]),
                  ListTile(
                    // leading: Icon(Icons.close, color: AppColors.down),
                    title: Text(
                      'Trade',
                      style: TextStyle(color: AppColors.info),
                      textAlign: TextAlign.center,
                    ),
                    onTap: () {
                      Get.back();
                      if (positionController.positionOrders.isEmpty) return;

                      final firstPosition =
                          positionController.positionOrders.first;
                      final instrument = tradingController.getInstrument(
                        firstPosition.instrumentId,
                      );

                      if (instrument == null) return;

                      Get.to(
                        () => PlaceOrder(
                          symbol: instrument.code,
                          currentBuyPrice: 0,
                          currentSellPrice: 0,
                        ),
                      );
                    },
                  ),
                  Divider(height: 1, thickness: 1, color: Colors.grey[300]),
                  ListTile(
                    // leading: Icon(Icons.close, color: AppColors.info),
                    title: Text(
                      'Depth Of Market',
                      style: TextStyle(color: AppColors.info),
                      textAlign: TextAlign.center,
                    ),
                    onTap: () {
                      Get.back();
                      // onPlaceOrder();
                    },
                  ),
                  Divider(height: 1, thickness: 1, color: AppColors.border(Get.context!)),
                  ListTile(
                    // leading: Icon(Icons.close, color: AppColors.info),
                    title: Text(
                      'Bulk Operations',
                      style: TextStyle(color: AppColors.info),
                      textAlign: TextAlign.center,
                    ),
                    onTap: () {
                      Get.back();
                      // onPlaceOrder();
                    },
                  ),
                ],
              ),
            );
          });
        },
      );
    }

    final positionsController = Get.find<PositionsController>();
    final realPosition = positionsController.findPosition(
      instrumentId: position.instrumentId,
      side: position.side,
      accountId: position.accountId,
    );
    if (realPosition == null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text("Position not found", style: TextStyle(color: AppColors.error)),
      );
    }
    return Column(
      children: [
        InkWell(
          onTap: () => showPositionActions(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                dense: true,
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                minVerticalPadding: 0,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                title: RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Transform.scale(
                          scaleY: 1.2,
                          child: Text(
                            symbol,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Transform.scale(
                          scaleY: 1.2,
                          child: Text(
                            ' ${_getSideLabel(position.side)} ',
                            style: TextStyle(
                              color: isBuy ? AppColors.bullish : AppColors.bearish,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                      ),
                      TextSpan(
                        text: _formatVolume(position.positionQty),
                        style: TextStyle(
                          color: isBuy ? AppColors.bullish: AppColors.bearish,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                subtitle: Row(
                  children: [
                    Text(
                      entryPrice.toStringAsFixed(4),
                      // style: const TextStyle(
                      //   fontSize: 16,
                      //   fontWeight: FontWeight.w400,
                      //   color: AppColors.textSecondary,
                      // ),
                      style: AppTextStyle.body_400.textSecondary(context),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_right_alt_rounded,
                      size: 16,
                      color: AppColors.textSecondary(context),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      currentPrice == 0.0
                          ? 'Loading...'
                          : currentPrice.toStringAsFixed(5),
                      // style: const TextStyle(
                      //   fontSize: 16,
                      //   fontWeight: FontWeight.w400,
                      //   color: AppColors.textSecondary,
                      // ),
                      style: AppTextStyle.body_400.textSecondary(context),
                    ),
                  ],
                ),
                // trailing: Text(
                //   profit.toStringAsFixed(2),
                //   style: TextStyle(
                //     fontWeight: FontWeight.w600,
                //     fontSize: 20,
                //     color: profitColor,
                //     letterSpacing: -0.3,
                //   ),
                // ),
                trailing: AnimatedProfitText(
                  profit: profit,
                  profitColor: profitColor,
                ),
              ),
            ],
          ),
        ),
        // ),
        Divider(height: 1, thickness: 1, color: Colors.grey[300]),
      ],
    );
  }
  String _getSideLabel(int side) {
    switch (side) {
      case 1:
        return 'buy';
      case 2:
        return 'sell';
      default:
        return 'Unknown';
    }
  }

  double calculateProfit({
    required double entryPrice,
    required double currentPrice,
    required double positionQty,
    required double contractSize,
    required int side,
    required int pl_calc_mode_id,
    required int decimalPlaces,
    required double pointValue,
    required double currencyRate,
  }) {
    return ProfitCalculator.calculateProfit(
      entryPrice: entryPrice.toDouble(),
      currentPrice: currentPrice.toDouble(),
      positionQty: positionQty.toDouble(),
      contractSize: contractSize.toDouble(),
      side: side,
      plCalcModeId: pl_calc_mode_id,
      decimalPlaces: decimalPlaces,
      pointValue: pointValue.toDouble(),
      currencyRate: currencyRate.toDouble(),
    );
  }

  Color getProfitColor(double profit) {
    if (profit > 0) return AppColors.bullish;
    if (profit < 0) return AppColors.bearish;
    return AppColors.textSecondary(Get.context!);
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
  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return '--';

    return "${dateTime.year.toString().padLeft(4, '0')}-"
        "${dateTime.month.toString().padLeft(2, '0')}-"
        "${dateTime.day.toString().padLeft(2, '0')}";
  }
}


// bool isFullClose = orderQty.toStringAsFixed(2) ==
//     pos.positionQty.toStringAsFixed(2);

// final bool isFullClose =
//     (orderQty - pos.positionQty).abs() < 0.000001;


//     if (isSuccess) {
//   Get.snackbar('Success', result["message"] ?? 'Position closed');

//   final positionsController = Get.find<PositionsController>();
//   final orderController = Get.find<OrderController>();

//   //  Always refresh from backend
//   await positionsController.fetchOpenPositions(accountId);
//   await orderController.fetchClosedOrders(accountId);

//   Get.until((route) => route.isFirst);
//   MainTabView.selectedIndexNotifier.value = 2;
// }


