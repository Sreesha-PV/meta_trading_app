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
import 'package:netdania/utils/websocket_handler.dart';

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
  late WebSocketHandler _webSocketHandler;
  
  List<InstrumentModel> instruments = [];
  InstrumentModel? selectedInstrument;
  bool loading = true;
  bool _isLoadingMoreData = false;

  @override
  void initState() {
    super.initState();
    print('TradingViewWeb initialized with symbol: ${widget.symbol}');
    
    _chartController = ChartController(
      symbol: widget.symbol,
      initialTimeframe: widget.initialTimeframe,
    );
    
    _webSocketHandler = WebSocketHandler(
      webSocketService: widget.webSocketService,
      chartController: _chartController,
    );

    final accountController = Get.find<AccountController>();
    final accountId = accountController.selectedAccountId.value;
    _loadInstruments(accountId);
  }

  final InstrumentService _instrumentService = InstrumentService();

  Future<void> _loadInstruments(int accountId) async {
    final data = await _instrumentService.fetchInstruments(accountId);

    setState(() {
      instruments = data;
      final symbolToFind = widget.symbol.isEmpty ? 'EURUSD' : widget.symbol;
      selectedInstrument = data.firstWhere(
        (i) => i.code.toUpperCase() == symbolToFind.toUpperCase(),
        orElse: () {
          final eurusd = data.firstWhere(
            (i) => i.code.toUpperCase() == 'EURUSD',
            orElse: () => data.first,
          );
          return eurusd;
        },
      );
      loading = false;
      _chartController.setSelectedInstrument(selectedInstrument!);
    });
  }

  @override
  void dispose() {
    print('🔴 TradingViewWeb DISPOSING for symbol: ${widget.symbol}');
    _webSocketHandler.dispose();
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

  void _onInstrumentChanged(InstrumentModel? value) {
    if (value == null) return;
    setState(() {
      selectedInstrument = value;
    });

    _chartController.setSelectedInstrument(value);
    Get.find<tradingControllerLib.TradingChartController>()
        .symbol
        .value = value.code;
  }

  void _onTimeframeChanged(String newTimeframe) {
    _chartController.changeTimeframe(newTimeframe);
  }

  void _onIndicatorChanged(String newIndicator) {
    _chartController.changeIndicator(newIndicator);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: DropdownButtonHideUnderline(
        child: DropdownButton<InstrumentModel>(
          value: selectedInstrument,
          icon: const Icon(Icons.arrow_drop_down),
          items: instruments.map((symbol) {
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
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
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
          itemBuilder: (context) => OHLCService.getTimeframes()
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
          itemBuilder: (context) => OHLCService.getIndicators()
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

        return ChartWebView(
          controller: _chartController,
          onLoadingStateChanged: (isLoading) {
            setState(() {
              _isLoadingMoreData = isLoading;
            });
          },
        );
      },
    );
  }
}