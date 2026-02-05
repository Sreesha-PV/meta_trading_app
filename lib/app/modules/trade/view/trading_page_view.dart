import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netdania/app/config/theme/app_color.dart';
import 'package:netdania/app/getX/position_getx.dart';
import 'package:netdania/app/getX/wallet_getX.dart';
import 'package:netdania/app/getX/trading_getX.dart';
import 'package:netdania/app/models/instrument_model.dart';
import 'package:netdania/app/modules/home/widgets/app_drawer.dart';
import 'package:netdania/app/modules/order/view/place_order.dart';
import 'package:netdania/app/modules/trade/components/order_tile.dart';
import 'package:netdania/app/modules/trade/widgets/wallet/animated_account_metric.dart';
import 'package:netdania/app/modules/trade/components/pending_ordertile.dart';
import 'package:netdania/app/modules/trade/helper/symbol_utils.dart';
import 'package:netdania/app/getX/order_getX.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TradingPage extends StatelessWidget {
  final String symbol;
  final InstrumentModel instrument;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TradingPage({super.key, required this.symbol, required this.instrument});

  Future<void> _fetchAndSubscribe() async {
    // Find controllers instead of creating new ones
    final positionController = Get.find<PositionsController>();
    final orderController = Get.find<OrderController>();
    final tradingController = Get.find<TradingChartController>();

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');

    await positionController.loadPositions();

    if (userId != null) {
      final userIdInt = int.tryParse(userId);
      if (userIdInt != null) {
        // Fetch orders once with userId - this should get all orders
        await orderController.fetchOrders(userIdInt, true);
      }
    }

    // REMOVE THIS LOOP - it's causing multiple API calls
    // for (var p in positionController.positionOrders) {
    //   await orderController.fetchPendingOrders(p.accountId);
    // }

    // OR if you really need to fetch pending orders separately,
    // get unique account IDs and fetch them in parallel:
    final uniqueAccountIds =
        positionController.positionOrders
            .map((p) => p.accountId)
            .toSet()
            .toList();

    if (uniqueAccountIds.isNotEmpty) {
      await Future.wait(
        uniqueAccountIds.map(
          (accountId) => orderController.fetchPendingOrders(accountId),
        ),
      );
    }

    final symbols =
        positionController.positionOrders
            .map((p) => tradingController.getInstrument(p.instrumentId)?.code)
            .whereType<String>()
            .map((s) => s.toUpperCase())
            .toSet()
            .toList();

    tradingController.subscribeToSymbols(symbols);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAndSubscribe();
    });

    // Find existing controllers
    final positionController = Get.find<PositionsController>();
    final orderController = Get.find<OrderController>();
    final tradingController = Get.find<TradingChartController>();
    final walletController = Get.find<WalletController>();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(positionController, tradingController),
      drawer: CommonDrawer(),
      body: SingleChildScrollView(
        // ← Add SingleChildScrollView here
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAccountSummary(
              walletController,
              positionController,
              tradingController,
            ),
            Obx(() {
              if (positionController.positionOrders.isEmpty) {
                return const SizedBox.shrink();
              }
              return _buildPositionsBar(positionController);
            }),
            Obx(() {
              if (positionController.positionOrders.isEmpty) {
                return const SizedBox.shrink();
              }
              return _buildPositionsList(
                positionController,
                tradingController,
                orderController,
              );
            }),
            Obx(() {
              final hasOrders = orderController.pendingOrders.any(
                (o) => o.remainingQty > 0,
              );

              if (!hasOrders) {
                return const SizedBox.shrink();
              }
              return _buildOrderBar();
            }),
            _buildPendingOrderList(orderController, tradingController),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(
    PositionsController positionController,
    TradingChartController tradingController,
  ) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: true,
      title: Obx(() {
        final totalPL = positionController.calculateTotalUnrealizedPL(
          tradingController.tickers,
          tradingController,
        );
        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
          tween: Tween<double>(begin: totalPL, end: totalPL),
          builder: (context, animatedValue, child) {
            return Text(
              '${animatedValue.toStringAsFixed(2)} USD',
              style: TextStyle(
                color: animatedValue >= 0 ? Colors.blue : Colors.red,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            );
          },
        );
      }),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.swap_vert),
          itemBuilder:
              (context) => const [
                PopupMenuItem(value: 'Order', child: Text('Order')),
                PopupMenuItem(value: 'Time', child: Text('Open Time')),
                PopupMenuItem(value: 'Symbol', child: Text('Symbol')),
                PopupMenuItem(value: 'Profit', child: Text('State')),
              ],
        ),
        IconButton(
          icon: const Icon(Icons.restore_page_outlined),
          onPressed: () {
            if (positionController.positionOrders.isEmpty) return;

            final firstPosition = positionController.positionOrders.first;
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
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildAccountSummary(
    WalletController walletController,
    PositionsController positionController,
    TradingChartController tradingController,
  ) {
    return Obx(() {
      // Only show full loading on initial load
      if (walletController.isLoading.value) {
        return const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (walletController.error.value.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                'Error: ${walletController.error.value}',
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => walletController.refreshWallet(),
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      final balance = walletController.balance;
      final usedMargin = walletController.usedMargin;

      final totalPL = positionController.calculateTotalUnrealizedPL(
        tradingController.tickers,
        tradingController,
      );

      final equity = balance + totalPL;
      final freeMargin = equity - usedMargin;
      final marginLevel = usedMargin > 0 ? (equity / usedMargin) * 100 : 0.0;

      return Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedAccountMetric(label: 'Balance:', value: balance),
                AnimatedAccountMetric(label: 'Equity:', value: equity),
                AnimatedAccountMetric(label: 'Margin:', value: usedMargin),
                AnimatedAccountMetric(
                  label: 'Free Margin:',
                  value: freeMargin,
                  valueColor:
                      freeMargin >= 0 ? AppColors.textPrimary : Colors.red,
                ),
                AnimatedAccountMetric(
                  label: 'Margin Level (%):',
                  value: marginLevel,
                ),
              ],
            ),
          ),
          // Subtle refreshing indicator (optional)
          if (walletController.isRefreshing.value)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const SizedBox(
                  width: 8,
                  height: 8,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildPositionsBar(PositionsController positionController) {
    return Container(
      width: double.infinity,
      height: 36,
      color: Colors.grey[200],
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          const Text(
            'Positions',
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          Obx(() {
            if (positionController.positionOrders.isEmpty) {
              return const SizedBox.shrink();
            }

            return IconButton(
              icon: const Icon(
                Icons.more_horiz,
                color: AppColors.textSecondary,
              ),
              onPressed: () => _showBulkActions(),
            );
          }),
        ],
      ),
    );
  }

  void _showBulkActions() {
    final orderController = Get.find<OrderController>();
    final tradingController = Get.find<TradingChartController>();

    showModalBottomSheet(
      context: Get.context!,
      shape: const RoundedRectangleBorder(),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            children: [
              const ListTile(
                title: Text(
                  'Bulk Operations',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: const Text('Close All Positions'),
                onTap: () {
                  orderController.clearOrders();
                  Get.back();
                },
              ),
              ListTile(
                title: const Text('Close Profitable Positions'),
                onTap: () {
                  orderController.removeProfitableActiveOrders(
                    tradingController.tickers,
                  );
                  Get.back();
                },
              ),
              ListTile(
                title: const Text('Close Losing Positions'),
                onTap: () {
                  orderController.removeLosingActiveOrders(
                    tradingController.tickers,
                  );
                  Get.back();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPositionsList(
    PositionsController positionController,
    TradingChartController tradingController,
    OrderController orderController,
  ) {
    return Obx(() {
      final positions = positionController.positionOrders;

      if (positions.isEmpty) {
        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Center(
            child: Text(
              'No positions yet',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: positions.length,
        itemBuilder: (context, index) {
          final position = positions[index];

          final InstrumentModel? instrument = tradingController.getInstrument(
            position.instrumentId,
          );

          // print("Position InstrumentID: ${position.instrumentId}");

          if (instrument == null) {
            return const SizedBox.shrink();
          }

          final String symbolKey = instrument.code.toUpperCase();

          if (!tradingController.hasInstrumentDetails(position.instrumentId)) {
            tradingController.detailsInstruments(position.instrumentId);
          }

          return Obx(() {
            final ticker = tradingController.tickers[symbolKey];

            final currentPrice = PriceHelper.getCurrentPrice(
              ticker,
              position.side == 1 ? 2 : 1,
            );

            final instrumentDetails = tradingController
                .getCachedInstrumentDetails(position.instrumentId);

            double currencyRate = 0.0;

            if (instrumentDetails != null &&
                (instrumentDetails.plCalcModeId == 5 ||
                    instrumentDetails.plCalcModeId == 6)) {
              final quoteCurrencyId =
                  instrumentDetails.quoteCurrencyInstrumentId;

              if (quoteCurrencyId != null &&
                  !tradingController.hasInstrumentDetails(quoteCurrencyId)) {
                tradingController.detailsInstruments(quoteCurrencyId);
              }

              Map<String, dynamic>? quoteCurrencyTicker;
              if (quoteCurrencyId != null) {
                final InstrumentModel? quoteCurrencyInstrument =
                    tradingController.getInstrument(quoteCurrencyId);
                if (quoteCurrencyInstrument != null) {
                  final String quoteCurrencySymbolKey =
                      quoteCurrencyInstrument.code.toUpperCase();

                  quoteCurrencyTicker =
                      tradingController.tickers[quoteCurrencySymbolKey];
                }
              }

              final currencyRateBuy =
                  PriceHelper.getCurrentPrice(
                    quoteCurrencyTicker,
                    1,
                  ).toDouble();

              final currencyRateSell =
                  PriceHelper.getCurrentPrice(
                    quoteCurrencyTicker,
                    2,
                  ).toDouble();

              currencyRate = (currencyRateBuy + currencyRateSell) / 2.0;
            }

            final isExpanded =
                orderController.expandedOrderIndex.value == index;

            return OrderTile(
              position: position,
              instrument: instrument,
              index: index,
              currentPrice: currentPrice,
              isExpanded: isExpanded,
              onToggleExpand: () {
                orderController.expandedOrderIndex.value =
                    isExpanded ? null : index;
              },
              symbol: symbolKey,
              contractSize: instrumentDetails?.contractSize?.toDouble() ?? 1.0,
              pl_calc_mode_id: instrumentDetails?.plCalcModeId ?? 1,
              decimalPlaces: instrumentDetails?.decimalPlaces ?? 0,
              pointValue: instrumentDetails?.point?.toDouble() ?? 0.0,
              currencyRate: currencyRate.toDouble(),
            );
          });
        },
      );
    });
  }

  Widget _buildOrderBar() {
    return Container(
      width: double.infinity,
      height: 36,
      color: Colors.grey[200],
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          const Text(
            'Orders',
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.w600,
              fontSize: 14,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.more_horiz, color: AppColors.textSecondary),
            onPressed: () => _showBulkAction(),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingOrderList(
    OrderController orderController,
    TradingChartController tradingController,
  ) {
    return Obx(() {
      final pendingOrders =
          orderController.pendingOrders
              .where((po) => po.remainingQty > 0)
              .toList();

      if (pendingOrders.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: pendingOrders.length,
              itemBuilder: (context, index) {
                final po = pendingOrders[index];

                final InstrumentModel? instrument = tradingController
                    .getInstrument(po.instrumentId);

                if (instrument == null) {
                  return const SizedBox.shrink();
                }

                final symbolKey = instrument.code.toUpperCase();

                return Obx(() {
                  final ticker = tradingController.tickers[symbolKey];

                  final currentPrice =
                      ticker != null
                          ? PriceHelper.getCurrentPrice(ticker, po.side)
                          : po.orderPrice;

                  return PendingOrderTile(
                    key: ValueKey(
                      'pending_${po.pendingOrderId}_${po.instrumentId}',
                    ),
                    fetchOrder: po,
                    instrument: instrument,
                    currentPrice: currentPrice,
                    symbol: symbolKey,
                  );
                });
              },
            ),
          ),
        ],
      );
    });
  }

  void _showBulkAction() {
    final orderController = Get.find<OrderController>();
    final tradingController = Get.find<TradingChartController>();

    showModalBottomSheet(
      context: Get.context!,
      shape: const RoundedRectangleBorder(),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            children: [
              const ListTile(
                title: Text(
                  'Bulk Operations',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: const Text('Delete All Orders'),
                onTap: () {
                  orderController.clearOrders();
                  Get.back();
                },
              ),
              ListTile(
                title: const Text('Delete Stop Orders'),
                onTap: () {
                  orderController.removeProfitableActiveOrders(
                    tradingController.tickers,
                  );
                  Get.back();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class AccountMetric extends StatelessWidget {
  final String label;
  final String? value;
  final Color? valueColor;

  const AccountMetric({
    super.key,
    required this.label,
    this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
          if (value != null)
            Text(
              value!,
              style: TextStyle(
                color: valueColor ?? AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}
