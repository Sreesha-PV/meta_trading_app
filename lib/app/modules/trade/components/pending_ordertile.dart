import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netdania/app/config/theme/app_color.dart';
import 'package:netdania/app/getX/order_getX.dart';
import 'package:netdania/app/models/order_get_model.dart';
import 'package:netdania/app/models/instrument_model.dart';
import 'package:netdania/app/getX/trading_getX.dart';
import 'package:netdania/app/modules/trade/widgets/modify/modify_order_page.dart';

class PendingOrderTile extends StatelessWidget {
  final PendingOrder fetchOrder;
  final InstrumentModel instrument;
  final double currentPrice;
  final String symbol;
  // final bool isExpanded;
  // final VoidCallback onToggleExpand;

  const PendingOrderTile({
    super.key,
    required this.fetchOrder,
    required this.instrument,
    required this.currentPrice,
    required this.symbol,
    // required this.isExpanded, required this.onToggleExpand,
  });

  String _getSideLabel(int side) {
    switch (side) {
      case 1:
        return 'Buy';
      case 2:
        return 'Sell';
      default:
        return 'Unknown';
    }
  }

  String _getTypeLabel(int type, int side) {
    String sideLabel;
    String typeLabel;

    switch (side) {
      case 1:
        sideLabel = 'buy';
        break;
      case 2:
        sideLabel = 'sell';
        break;
      default:
        sideLabel = 'Unknown';
    }

    switch (type) {
      case 2:
        typeLabel = 'limit';
        break;
      case 3:
        typeLabel = 'stop';
        break;
      default:
        typeLabel = 'Unknown';
    }

    return '$sideLabel $typeLabel';
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

  void onCloseOrder() {
    final orderController = Get.find<OrderController>();

    Get.dialog(
      AlertDialog(
        title: Text('Delete Order'),
        // content: Text('Are you sure you want to close this order?'),
        content: Text(
          'Delete Order : #${fetchOrder.pendingOrderId} ${_getSideLabel(fetchOrder.side)} ${fetchOrder.orderQty} ${instrument.code} at ${fetchOrder.orderPrice}',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: AppColors.info)),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              orderController.closePendingOrder(
                fetchOrder.pendingOrderId,
                fetchOrder.accountId,
                fetchOrder.orderQty,
              );
            },
            child: Text('Delete', style: TextStyle(color: AppColors.info)),
          ),
        ],
      ),
    );
  }

  void onEditOrder() {
    print('Edit order pressed: ${fetchOrder.pendingOrderId}');

    // Find the order from OrderController
    final orderController = Get.find<OrderController>();
    final order = orderController.pendingOrders.firstWhereOrNull(
      (o) => o.pendingOrderId == fetchOrder.pendingOrderId,
    );

    if (order == null) {
      Get.snackbar(
        "Error",
        "Order not found",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.down,
        colorText: Colors.white,
      );
      return;
    }
    final tradingController = Get.find<TradingChartController>();
    if (!tradingController.hasInstrumentDetails(order.instrumentId)) {
      tradingController.detailsInstruments(order.instrumentId);
    }
    final instrument = tradingController.getInstrument(order.instrumentId);

    if (instrument == null) {
      Get.snackbar(
        "Error",
        "Instrument not found",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.down,
        colorText: Colors.white,
      );
      return;
    }

    // Get current ticker prices
    final ticker = tradingController.getTickerSafe(
      instrument.code.toUpperCase(),
    );

    final currentBuyPrice =
        double.tryParse(ticker?['ask']?.toString() ?? '0') ?? 0;
    final currentSellPrice =
        double.tryParse(ticker?['bid']?.toString() ?? '0') ?? 0;

    Get.to(
      () => ModifyOrderPage(
        symbol: instrument.code,
        currentBuyPrice: currentBuyPrice,
        currentSellPrice: currentSellPrice,
        order: order,
        instrument: instrument,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isBuy = fetchOrder.side == 1;

    void _showOrderActions(BuildContext context) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        ),
        builder: (context) {
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
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text:
                                    ' ${_getTypeLabel(fetchOrder.orderType, fetchOrder.side)} ',
                                style: TextStyle(
                                  color: isBuy ? AppColors.up : AppColors.down,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: _formatVolume(fetchOrder.orderQty),
                                 style: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              )
                            
                            ],
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            Row(
                              children: [
                                Text(
                                  fetchOrder.orderPrice.toStringAsFixed(4),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                                children: [
                                  Text(
                                    'S/L: ${fetchOrder.stopPrice?.toStringAsFixed(5)}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                   Text(
                                    'T/P: ${fetchOrder.limitPrice?.toStringAsFixed(5)}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                    ),
                                  ), 
                                ],
                              ),

                           
                          ],
                        ),

                        trailing: Column(
                          children: [
                            Text(
                              'Placed',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text(
                    'Order Actions',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.edit, color: AppColors.info),
                  title: const Text('Edit Order'),
                  onTap: () {
                    Get.back();
                    onEditOrder();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.close, color: AppColors.down),
                  title: Text(
                    'Cancel Order',
                    style: TextStyle(color: AppColors.down),
                  ),
                  onTap: () {
                    Get.back();
                    onCloseOrder();
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    // print('Ordertype for pendingorder: ${_getOrderTypeLabel(fetchOrder)} ');

    return Column(
      children: [
        InkWell(
          onTap: () => _showOrderActions(context),
          child: ListTile(
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
                        instrument.code,
                        style: TextStyle(
                          color: AppColors.textPrimary,
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
                        ' ${_getTypeLabel(fetchOrder.orderType, fetchOrder.side)} ',
                        style: TextStyle(
                          color: isBuy ? AppColors.up : AppColors.down,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            subtitle: Row(
              children: [
              
                Text(
                  '${_formatVolume(fetchOrder.orderQty)}/0.0 at',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 4),
               
                const SizedBox(width: 4),
               
                Text(
                  fetchOrder.orderPrice.toStringAsFixed(4),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            trailing: Text(
              'placed',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 20,
                color: AppColors.textSecondary,
              ),
            )
          ),
        ),
        Divider(height: 1, thickness: 1, color: Colors.grey[300]),
      ],
    );
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return '--';

    return "${dateTime.year.toString().padLeft(4, '0')}-"
        "${dateTime.month.toString().padLeft(2, '0')}-"
        "${dateTime.day.toString().padLeft(2, '0')}";
  }
}