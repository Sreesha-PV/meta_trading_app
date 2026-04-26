import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netdania/app/getX/position_getx.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:netdania/screens/chart/chart_controller.dart';
import 'package:netdania/screens/chart/chart_html_generator.dart';

class ChartWebView extends StatefulWidget {
  final ChartController controller;
  final Function(bool isLoading)? onLoadingStateChanged;

  const ChartWebView({
    super.key,
    required this.controller,
    this.onLoadingStateChanged,
  });

  @override
  State<ChartWebView> createState() => _ChartWebViewState();
  
}


class _ChartWebViewState extends State<ChartWebView> {
  late WebViewController _webViewController;
  bool _isLoadingMoreData = false;
  Worker? _positionWorker;
  Timer? _positionDebounce;

  @override
  void initState() {    
    super.initState();
    
    _setupWebViewController();

    widget.controller.dataStream.listen((_) {
      if (mounted) _reloadChart();
    });

    _listenToPositionChanges();
  }



  @override
  void dispose() {
    _positionWorker?.dispose();
    _positionDebounce?.cancel();
    super.dispose();
  }

  void _listenToPositionChanges() {
    try {
      final positionsController = Get.find<PositionsController>();
      _positionWorker = ever(positionsController.positionOrders, (_) {
        if (!mounted) return;
        // Debounce rapid successive calls
        _positionDebounce?.cancel();
        _positionDebounce = Timer(const Duration(milliseconds: 200), () {
          if (mounted) _pushPositionLinesToChart(positionsController);
        });
      });
    } catch (e) {
      print('⚠️ PositionsController not found: $e');
    }
  }

  void _pushPositionLinesToChart(PositionsController positionsController) {
    final instrument = widget.controller.selectedInstrument;
    if (instrument == null) return;

    final lines =
        positionsController.positionOrders
            .where((p) => p.instrumentId == instrument.instrumentId)
            .map(
              (p) => {
                'price': p.orderPrice,
                'color': p.side == 1 ? '#26a69a' : '#ef5350',
                'label': '${p.side == 1 ? "▲ BUY" : "▼ SELL"} #${p.positionId}',
                'positionId': p.positionId,
                'side': p.side,
                'qty': p.positionQty,
                'sl': null,
                'tp': null,
              },
            )
            .toList();

    final jsCode = '''
      if (typeof updatePositionLines === 'function') {
        updatePositionLines(${jsonEncode(lines)});
      }
    ''';
    _webViewController.runJavaScript(jsCode).catchError((e) {
      print('❌ Error pushing position lines: $e');
    });
  }

  void _setupWebViewController() {
    _webViewController =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(Colors.white)
          ..enableZoom(false)
          ..addJavaScriptChannel(
            'FlutterChannel',
            onMessageReceived: _handleJavaScriptMessage,
          )
          ..setOnConsoleMessage(_handleConsoleMessage)
          ..loadHtmlString(_generateHtml());
  }


//   void _setupWebViewController() {
//   _webViewController =
//       WebViewController()
//         ..setJavaScriptMode(JavaScriptMode.unrestricted)
//         ..setBackgroundColor(Colors.white)
//         ..enableZoom(false)
//         ..addJavaScriptChannel(
//           'FlutterChannel',
//           onMessageReceived: _handleJavaScriptMessage,
//         )
//         ..setOnConsoleMessage(_handleConsoleMessage)
//         ..loadHtmlString(_generateHtml());

//   widget.controller.setWebController(_webViewController);
// }

  void _handleJavaScriptMessage(JavaScriptMessage message) {
    if (message.message == 'chart_initialized') {
      widget.controller.setChartInitialized(true);
      print('✅ Chart initialized successfully');

      // try {
      //   final positionsController = Get.find<PositionsController>();
      //   _pushPositionLinesToChart(positionsController);
      // } catch (_) {}
    } else if (message.message.startsWith('load_more_data:')) {
      final timestamp = message.message.split(':')[1];
      _loadMoreHistoricalData(int.parse(timestamp));
    } else if (message.message.startsWith('position_sl_tp:')) {
      final payload = message.message.substring('position_sl_tp:'.length);
      final data = jsonDecode(payload) as Map<String, dynamic>;
      _onPositionSlTpConfirmed(
        positionId: data['positionId'] as int,
        sl: (data['sl'] as num?)?.toDouble(),
        tp: (data['tp'] as num?)?.toDouble(),
      );
    }
  }

  void _handleConsoleMessage(JavaScriptConsoleMessage consoleMessage) {
    final message = consoleMessage.message.toLowerCase();
    if (message.contains('updateacquirefence') ||
        message.contains('acquire fence') ||
        message.contains('did not find frame')) {
      return;
    }
    print('🌐 [JS ${consoleMessage.level.name}]: ${consoleMessage.message}');
  }

  Future<void> _loadMoreHistoricalData(int earliestTimestamp) async {
    if (_isLoadingMoreData) {
      print('⚠️ Already loading more data, skipping...');
      return;
    }

    setState(() => _isLoadingMoreData = true);
    widget.onLoadingStateChanged?.call(true);

    print(
      '📥 Loading more historical data before timestamp: $earliestTimestamp',
    );

    try {
      final newCandles = await widget.controller.loadMoreHistoricalData(
        earliestTimestamp,
      );

      if (newCandles.isNotEmpty && mounted) {
        final jsCode = '''
          if (typeof prependHistoricalData === 'function') {
            prependHistoricalData(${jsonEncode(newCandles)});
          }
        ''';
        _webViewController.runJavaScript(jsCode).catchError((e) {
          print('❌ Error prepending data: $e');
        });
      } else {
        print('ℹ️ No new candles to add');
      }
    } catch (e) {
      print('❌ Error loading more historical data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load more data: $e'),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingMoreData = false);
        widget.onLoadingStateChanged?.call(false);
      }
    }
  }

  void _onPositionSlTpConfirmed({
    required int positionId,
    required double? sl,
    required double? tp,
  }) {
    print('✅ SL/TP confirmed for position $positionId → SL: $sl, TP: $tp');

    if (mounted) {
      final dotPosition = widget.controller.currentDotPosition;
      final slText = sl != null ? sl.toStringAsFixed(dotPosition) : 'None';
      final tpText = tp != null ? tp.toStringAsFixed(dotPosition) : 'None';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('SL: $slText | TP: $tpText'),
          backgroundColor: Colors.blueGrey[800],
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _reloadChart() {
    _webViewController.loadHtmlString(_generateHtml());
  }

  String _generateHtml() {
    return TradingViewHtmlGenerator.generateHtml(
      ohlcData: widget.controller.ohlcData,
      symbol: widget.controller.currentSymbol,
      dotPosition: widget.controller.currentDotPosition,
      positions: [],
      // selectedInstrument: widget.controller.selectedInstrument,
    );
  }

  void pushCandle(Map<String, dynamic> candle) {
    if (!mounted) return;
    final jsCode = '''
      if (typeof updateChart === 'function') {
        updateChart(${jsonEncode(candle)});
      }
    ''';
    try {
      _webViewController.runJavaScript(jsCode);
    } catch (e) {
      print('❌ Error updating chart: $e');
    }
  }

  void pushLivePrice(double bid, double ask) {
    final mid = (bid + ask) / 2;
    final jsCode = '''
      if (typeof updateLivePrice === 'function') {
        updateLivePrice($mid);
      }
    ''';
    try {
      _webViewController.runJavaScript(jsCode);
    } catch (e) {}
  }

  void changeIndicator(String indicator) {
    final jsCode = '''
      if (typeof changeIndicator === 'function') {
        changeIndicator('$indicator');
      }
    ''';
    try {
      _webViewController.runJavaScript(jsCode);
    } catch (e) {
      print('Error changing indicator: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>?>(
      stream: widget.controller.latestPriceStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final candle = widget.controller.getCurrentCandle();
          if (candle != null) {
            pushCandle(candle);
            pushLivePrice(
              snapshot.data!['bid'] as double,
              snapshot.data!['ask'] as double,
            );
          }
        }

        return StreamBuilder<String>(
          stream: widget.controller.indicatorStream,
          builder: (context, indicatorSnapshot) {
            if (indicatorSnapshot.hasData) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                changeIndicator(indicatorSnapshot.data!);
              });
            }
            return WebViewWidget(controller: _webViewController);
          },
        );
      },
    );
  }
}
