import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netdania/app/config/theme/app_color.dart';
import 'package:netdania/app/getX/account_getx.dart';
import 'package:netdania/app/getX/trading_getX.dart' as tradingControllerLib;
import 'package:netdania/app/models/instrument_model.dart';
import 'package:netdania/screens/services/instrument_fetch_services.dart';
import 'package:netdania/screens/services/ohlc_service.dart';
import 'package:netdania/screens/services/socket_connection.dart';
// import 'package:webview_flutter/webview_flutter.dart';
import 'package:netdania/screens/chart/chart_webview.dart';
import 'package:netdania/screens/chart/chart_controller.dart';
import 'package:netdania/screens/chart/chart_trade_card.dart';

/// Main TradingView chart widget
class TradingViewWeb extends StatefulWidget {
  final String symbol;
  final String initialTimeframe;
  final LocalWebSocketService? webSocketService;

  const TradingViewWeb({
    super.key,
    this.symbol = 'EURUSD',
    this.initialTimeframe = '15m',
    this.webSocketService,
  });

  @override
  State<TradingViewWeb> createState() => _TradingViewWebState();
}

class _TradingViewWebState extends State<TradingViewWeb> {
  late ChartController _chartController;
  StreamSubscription? _subscription;

  List<InstrumentModel> instruments = [];
  InstrumentModel? selectedInstrument;
  bool loading = true;
  bool _isLoadingMoreData = false;
  bool _showTradingCard = false;

  @override
  void initState() {
    super.initState();
    print('TradingViewWeb initialized with symbol: ${widget.symbol}');

    _chartController = ChartController(
      symbol: widget.symbol,
      initialTimeframe: widget.initialTimeframe,
    );

    if (Get.isRegistered<LocalWebSocketService>()) {
      final wsService = Get.find<LocalWebSocketService>();
      _subscription = wsService.stream.listen(_onData);
      print('✅ Subscribed to WebSocket stream');
    } else {
      print('⚠️ LocalWebSocketService not registered');
    }

    final accountController = Get.find<AccountController>();
    final accountId = accountController.selectedAccountId.value;
    _loadInstruments(accountId);
  }

  void _onData(dynamic data) {
    if (!_chartController.isChartInitialized) return;

    if (data is Map<String, dynamic>) {
      _processData(data);
    } else if (data is List) {
      for (var item in data) {
        if (item is Map<String, dynamic>) _processData(item);
      }
    }
  }

  void _processData(Map<String, dynamic> data) {
    final symbol =
        (data['s'] ?? data['item_code'] ?? data['symbol'])
            ?.toString()
            .toUpperCase();

    if (symbol != _chartController.currentSymbol.toUpperCase()) return;

    final bid = double.tryParse(data['bid']?.toString() ?? '') ?? 0.0;
    final ask = double.tryParse(data['ask']?.toString() ?? '') ?? 0.0;

    print('📥 Tick $symbol -> bid: $bid, ask: $ask');

    if (bid == 0 || ask == 0) return;
    _chartController.updateCandle(
      bid: bid,
      ask: ask,
      timestamp: DateTime.now(),
    );
  }

  @override
  void dispose() {
    print('🔴 TradingViewWeb DISPOSING for symbol: ${widget.symbol}');
    _subscription?.cancel(); // ✅
    _chartController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TradingViewWeb oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.symbol != widget.symbol) {
      debugPrint(
        '🔄 Chart symbol changed: ${oldWidget.symbol} → ${widget.symbol}',
      );
      _chartController.changeSymbol(widget.symbol);
    }
  }

  final InstrumentService _instrumentService = InstrumentService();

  Future<void> _loadInstruments(int accountId) async {
    final data = await _instrumentService.fetchInstruments(accountId);

    final symbolToFind = widget.symbol.isEmpty ? 'EURUSD' : widget.symbol;
    final instrument = data.firstWhere(
      (i) => i.code.toUpperCase() == symbolToFind.toUpperCase(),
      orElse:
          () => data.firstWhere(
            (i) => i.code.toUpperCase() == 'EURUSD',
            orElse: () => data.first,
          ),
    );

    _chartController.setSelectedInstrument(instrument);

    setState(() {
      instruments = data;
      selectedInstrument = instrument;
      loading = false;
    });
  }

  void _onInstrumentChanged(InstrumentModel? value) {
    if (value == null) return;
    setState(() {
      selectedInstrument = value;
    });

    _chartController.setSelectedInstrument(value);
    Get.find<tradingControllerLib.TradingChartController>().symbol.value =
        value.code;
  }

  void _onTimeframeChanged(String newTimeframe) {
    _chartController.changeTimeframe(newTimeframe);
  }

  void _onIndicatorChanged(String newIndicator) {
    _chartController.changeIndicator(newIndicator);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: DropdownButtonHideUnderline(
        child: DropdownButton<InstrumentModel>(
          value: selectedInstrument,
          icon: const Icon(Icons.arrow_drop_down),
          items:
              instruments.map((symbol) {
                return DropdownMenuItem(
                  value: symbol,
                  child: Text(
                    symbol.code,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                );
              }).toList(),
          onChanged: _onInstrumentChanged,
        ),
      ),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 1,
      actions: [
        if (_isLoadingMoreData)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _showTradingCard = !_showTradingCard;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _showTradingCard ? Colors.blue : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _showTradingCard ? Colors.blue : Colors.grey.shade400,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _showTradingCard ? Icons.swap_horiz : Icons.swap_horiz,
                    size: 16,
                    color:
                        _showTradingCard ? Colors.white : Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Trade',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color:
                          _showTradingCard
                              ? Colors.white
                              : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        _buildTimeframeSelector(),
        _buildIndicatorSelector(),
      ],
    );
  }

  Widget _buildTimeframeSelector() {
    return StreamBuilder<String>(
      stream: _chartController.timeframeStream,
      initialData: widget.initialTimeframe,
      builder: (context, snapshot) {
        return PopupMenuButton<String>(
          icon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                snapshot.data ?? widget.initialTimeframe,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(Icons.arrow_drop_down, size: 20),
            ],
          ),
          onSelected: _onTimeframeChanged,
          itemBuilder:
              (context) =>
                  OHLCService.getTimeframes()
                      .map(
                        (tf) => PopupMenuItem<String>(
                          value: tf['value'],
                          child: Text(tf['label']!),
                        ),
                      )
                      .toList(),
        );
      },
    );
  }

  Widget _buildIndicatorSelector() {
    return StreamBuilder<String>(
      stream: _chartController.indicatorStream,
      initialData: 'none',
      builder: (context, snapshot) {
        final selectedIndicator = snapshot.data ?? 'none';

        return PopupMenuButton<String>(
          icon: const Icon(Icons.show_chart),
          onSelected: _onIndicatorChanged,
          itemBuilder:
              (context) =>
                  OHLCService.getIndicators()
                      .map(
                        (ind) => PopupMenuItem<String>(
                          value: ind['value'],
                          child: Row(
                            children: [
                              if (selectedIndicator == ind['value'])
                                const Icon(
                                  Icons.check,
                                  size: 18,
                                  color: Colors.green,
                                ),
                              const SizedBox(width: 8),
                              Text(ind['label']!),
                            ],
                          ),
                        ),
                      )
                      .toList(),
        );
      },
    );
  }

  Widget _buildBody() {
    return StreamBuilder<ChartState>(
      stream: _chartController.stateStream,
      initialData: ChartState.loading,
      builder: (context, snapshot) {
        final state = snapshot.data ?? ChartState.loading;

        if (state == ChartState.loading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading chart...'),
              ],
            ),
          );
        }

        if (state == ChartState.error) {
          return const Center(child: Text('Error loading chart'));
        }

        if (state == ChartState.noData) {
          return const Center(child: Text('No data available'));
        }

        return Stack(
          children: [
            ChartWebView(
              controller: _chartController,
              onLoadingStateChanged: (isLoading) {
                setState(() {
                  _isLoadingMoreData = isLoading;
                });
              },
            ),
            // ✅ Animated Buy/Sell Card
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              bottom: _showTradingCard ? 16 : -200,
              left: 16,
              right: 16,
              child: ChartTradeCard(
                controller: _chartController,
                selectedInstrument: selectedInstrument,
                onClose: () => setState(() => _showTradingCard = false),
                onBuy: (ask, lotSize) {
                  print(
                    '🟢 BUY | symbol: ${selectedInstrument?.code} | ask: $ask | lot: $lotSize',
                  );
                  // TODO: Call trading API with lotSize
                },
                onSell: (bid, lotSize) {
                  print(
                    '🔴 SELL | symbol: ${selectedInstrument?.code} | bid: $bid | lot: $lotSize',
                  );
                  // TODO: Call trading API with lotSize
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
