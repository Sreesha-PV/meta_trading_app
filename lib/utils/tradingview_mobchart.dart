// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'dart:convert';
// import 'dart:async';
// import 'package:netdania/screens/services/ohlc_service.dart';
// import 'package:netdania/screens/services/socket_connection.dart';

// class TradingViewWeb extends StatefulWidget {
//   final String symbol;
//   final String initialTimeframe;
//   final LocalWebSocketService? webSocketService;

//   const TradingViewWeb({
//     super.key,
//     this.symbol = 'XAUUSD',
//     this.initialTimeframe = '1m',
//     this.webSocketService,
//   });

//   @override
//   State<TradingViewWeb> createState() => _TradingViewWebState();
// }

// class _TradingViewWebState extends State<TradingViewWeb> {
//   late WebViewController controller;
//   List<Map<String, dynamic>> ohlcData = [];
//   String selectedTimeframe = '1m';
//   String selectedIndicator = 'none';
//   bool isLoading = true;
//   Map<String, dynamic>? latestPrice;
//   StreamSubscription<dynamic>? _webSocketSubscription;
//   Timer? _candleAggregationTimer;
//   Map<String, dynamic>? _currentCandle;
//   bool _chartInitialized = false;
//   Timer? _updateThrottleTimer;
//   bool _canUpdate = true;

//   @override
//   void initState() {
//     super.initState();
//     selectedTimeframe = widget.initialTimeframe;
//     _initializeChart();
//     // _setupWebSocketListener();
//   }

//   @override
//   void dispose() {
//     _webSocketSubscription?.cancel();
//     _candleAggregationTimer?.cancel();
//     _updateThrottleTimer?.cancel();
//     super.dispose();
//   }

//   void _setupWebSocketListener() {
//     if (widget.webSocketService == null) {
//       print('⚠️ No WebSocket service provided');
//       return;
//     }

//     print('📡 Setting up WebSocket listener for ${widget.symbol}');

//     _webSocketSubscription = widget.webSocketService!.stream.listen(
//       (data) {
//         // Only process if chart is initialized
//         if (!_chartInitialized) {
//           return;
//         }

//         if (data is Map<String, dynamic>) {
//           _processWebSocketData(data);
//         } else if (data is List) {
//           for (var item in data) {
//             if (item is Map<String, dynamic>) {
//               _processWebSocketData(item);
//             }
//           }
//         }
//       },
//       onError: (error) {
//         print('❌ Stream error: $error');
//       },
//       onDone: () {
//         print('⚠️ Stream closed');
//       },
//     );
//   }

//   void _processWebSocketData(Map<String, dynamic> data) {
//     final symbol =
//         (data['s'] ?? data['item_code'] ?? data['symbol'])
//             ?.toString()
//             .toUpperCase();

//     if (symbol != widget.symbol.toUpperCase()) {
//       return;
//     }

//     final bid = double.tryParse(data['bid']?.toString() ?? '') ?? 0.0;
//     final ask = double.tryParse(data['ask']?.toString() ?? '') ?? 0.0;
//     final last =
//         double.tryParse(
//           data['last']?.toString() ?? data['close']?.toString() ?? '',
//         ) ??
//         0.0;
//     final high = double.tryParse(data['high']?.toString() ?? '') ?? 0.0;
//     final low = double.tryParse(data['low']?.toString() ?? '') ?? 0.0;
//     final open = double.tryParse(data['open']?.toString() ?? '') ?? 0.0;

//     final double price =
//         bid > 0 && ask > 0 ? (bid + ask) / 2.0 : (last > 0 ? last : 0.0);

//     if (price == 0) {
//       return;
//     }

//     final highValue = high > 0 ? high : price;
//     final lowValue = low > 0 ? low : price;
//     final openValue = open > 0 ? open : price;

//     _updateCandle(
//       price: price,
//       high: highValue,
//       low: lowValue,
//       open: openValue,
//       bid: bid,
//       ask: ask,
//       timestamp: DateTime.now(),
//     );
//   }

//   void _updateCandle({
//     required double price,
//     required double high,
//     required double low,
//     required double open,
//     required double bid,
//     required double ask,
//     required DateTime timestamp,
//   }) {
//     if (!_chartInitialized) {
//       return;
//     }

//     if (!_canUpdate) {
//       return;
//     }

//     final timeframeSeconds = _getTimeframeSeconds(selectedTimeframe);
//     final candleTime =
//         (timestamp.millisecondsSinceEpoch ~/ 1000) ~/
//         timeframeSeconds *
//         timeframeSeconds;

//     if (ohlcData.isNotEmpty) {
//       final lastHistoricalCandle = ohlcData.last;
//       final lastHistoricalTime = lastHistoricalCandle['time'] as int;

//       if (candleTime < lastHistoricalTime) {
//         print('⚠️ Ignoring old tick: $candleTime < $lastHistoricalTime');
//         return;
//       }
//     }

//     if (_currentCandle == null || _currentCandle!['time'] != candleTime) {
//       if (_currentCandle != null) {
//         _pushCandleToChart(_currentCandle!);
//       }

//       _currentCandle = {
//         'time': candleTime,
//         'open': open,
//         'high': high,
//         'low': low,
//         'close': price,
//       };
//     } else {
//       _currentCandle!['high'] = [
//         _currentCandle!['high'] as double,
//         high,
//         price,
//       ].reduce((a, b) => a > b ? a : b);
//       _currentCandle!['low'] = [
//         _currentCandle!['low'] as double,
//         low,
//         price,
//       ].reduce((a, b) => a < b ? a : b);
//       _currentCandle!['close'] = price;
//     }

//     _pushCandleToChart(_currentCandle!);

//     _canUpdate = false;
//     _updateThrottleTimer?.cancel();
//     _updateThrottleTimer = Timer(const Duration(milliseconds: 100), () {
//       _canUpdate = true;
//     });

//     setState(() {
//       latestPrice = {
//         'bid': bid,
//         'ask': ask,
//         'mid': price,
//         'open': _currentCandle!['open'],
//         'high': _currentCandle!['high'],
//         'low': _currentCandle!['low'],
//         'close': _currentCandle!['close'],
//       };
//     });
//   }

//   void _setupWebViewController() {
//     controller =
//         WebViewController()
//           ..setJavaScriptMode(JavaScriptMode.unrestricted)
//           ..setBackgroundColor(Colors.white)
//           ..enableZoom(false) // Add this
//           ..addJavaScriptChannel(
//             'FlutterChannel',
//             onMessageReceived: (JavaScriptMessage message) {
//               if (message.message == 'chart_initialized') {
//                 setState(() {
//                   _chartInitialized = true;
//                 });
//                 print('✅ Chart initialized, starting WebSocket listener');
//                 _setupWebSocketListener();
//               }
//             },
//           )
//           ..setOnConsoleMessage((JavaScriptConsoleMessage consoleMessage) {
//             if (!consoleMessage.message.contains('updateAcquireFence')) {
//               print(
//                 '🌐 [JS ${consoleMessage.level.name}]: ${consoleMessage.message}',
//               );
//             }
//           })
//           ..loadHtmlString(_generateHtml());
//   }

//   int _getTimeframeSeconds(String timeframe) {
//     switch (timeframe) {
//       case '1m':
//         return 60;
//       case '5m':
//         return 300;
//       case '15m':
//         return 900;
//       case '30m':
//         return 1800;
//       case '1h':
//         return 3600;
//       case '4h':
//         return 14400;
//       case '1d':
//         return 86400;
//       default:
//         return 60;
//     }
//   }

//   void _pushCandleToChart(Map<String, dynamic> candle) {
//     final jsCode = '''
//       if (typeof updateChart === 'function') {
//         updateChart(${jsonEncode(candle)});
//       }
//     ''';

//     try {
//       controller.runJavaScript(jsCode);
//     } catch (e) {
//       print('❌ Error updating chart: $e');
//     }
//   }

//   Future<void> _initializeChart() async {
//     setState(() => isLoading = true);

//     try {
//       final symbolToFetch = widget.symbol.isEmpty ? 'EURUSD' : widget.symbol;

//       final data = await OHLCService.fetchOHLC(
//         symbol: symbolToFetch,
//         resolution: selectedTimeframe,
//       );

//       print(
//         '✅ Fetched ${data.length} candles for timeframe $selectedTimeframe',
//       );

//       setState(() {
//         ohlcData = data;
//         isLoading = false;
//       });

//       if (data.isEmpty) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('No chart data available')),
//           );
//         }
//         return;
//       }

//       _setupWebViewController();
//     } catch (e) {
//       print('❌ Error loading chart for ${widget.symbol}: $e');

//       if (widget.symbol != 'EURUSD') {
//         print('🔄 Trying fallback to EURUSD...');
//         try {
//           final data = await OHLCService.fetchOHLC(
//             symbol: 'EURUSD',
//             resolution: selectedTimeframe,
//           );

//           setState(() {
//             ohlcData = data;
//             isLoading = false;
//           });

//           _setupWebViewController();

//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(
//                   'Loaded EURUSD chart (${widget.symbol} unavailable)',
//                 ),
//                 backgroundColor: Colors.orange,
//               ),
//             );
//           }
//           return;
//         } catch (fallbackError) {
//           print('❌ Fallback to EURUSD also failed: $fallbackError');
//         }
//       }

//       setState(() => isLoading = false);

//       if (mounted) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Error loading chart: $e')));
//       }
//     }
//   }

//   void _changeTimeframe(String newTimeframe) async {
//     if (selectedTimeframe == newTimeframe) return;

//     print('🔄 Changing timeframe from $selectedTimeframe to $newTimeframe');

//     setState(() {
//       selectedTimeframe = newTimeframe;
//       isLoading = true;
//       _currentCandle = null; // Reset current candle
//     });

//     try {
//       final symbolToFetch = widget.symbol.isEmpty ? 'EURUSD' : widget.symbol;

//       final data = await OHLCService.fetchOHLC(
//         symbol: symbolToFetch,
//         resolution: newTimeframe,
//       );

//       print('✅ Fetched ${data.length} candles for timeframe $newTimeframe');

//       setState(() {
//         ohlcData = data;
//         isLoading = false;
//       });

//       if (data.isNotEmpty) {
//         controller.loadHtmlString(_generateHtml());
//       } else {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('No data available for $newTimeframe timeframe'),
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       print('❌ Error changing timeframe: $e');

//       setState(() {
//         isLoading = false;
//       });

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to load $newTimeframe data: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   void _changeIndicator(String newIndicator) {
//     setState(() {
//       selectedIndicator = newIndicator;
//     });

//     final jsCode = '''
//       if (typeof changeIndicator === 'function') {
//         changeIndicator('$newIndicator');
//       }
//     ''';

//     try {
//       controller.runJavaScript(jsCode);
//     } catch (e) {
//       print('Error changing indicator: $e');
//     }
//   }

//   String _generateHtml() {
//     final validData =
//         ohlcData.where((candle) {
//           return candle['time'] is int &&
//               candle['open'] is double &&
//               candle['high'] is double &&
//               candle['low'] is double &&
//               candle['close'] is double &&
//               !candle['open'].isNaN &&
//               !candle['high'].isNaN &&
//               !candle['low'].isNaN &&
//               !candle['close'].isNaN;
//         }).toList();

//     print('📊 Generating HTML with ${validData.length} candles');

//     return '''
//     <!DOCTYPE html>
//     <html>
//     <head>
//       <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
//       <script src="https://unpkg.com/lightweight-charts@4.1.3/dist/lightweight-charts.standalone.production.js"></script>
//       <style>
//         * { margin: 0; padding: 0; box-sizing: border-box; }
//         body { 
//           margin: 0; 
//           padding: 0; 
//           overflow: hidden;
//           font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
//           background: #ffffff;
//         }
//         #chart { width: 100vw; height: 100vh; }
//         #info {
//           position: absolute;
//           top: 10px;
//           left: 10px;
//           background: rgba(255, 255, 255, 0.95);
//           padding: 12px;
//           border-radius: 8px;
//           font-size: 13px;
//           pointer-events: none;
//           z-index: 1000;
//           box-shadow: 0 2px 8px rgba(0,0,0,0.15);
//         }
//         #live-indicator {
//           position: absolute;
//           top: 10px;
//           right: 10px;
//           background: rgba(38, 166, 154, 0.95);
//           color: white;
//           padding: 6px 12px;
//           border-radius: 20px;
//           font-size: 11px;
//           font-weight: bold;
//           z-index: 1000;
//           display: flex;
//           align-items: center;
//           gap: 6px;
//         }
//         .pulse {
//           width: 8px;
//           height: 8px;
//           background: white;
//           border-radius: 50%;
//           animation: pulse 2s infinite;
//         }
//         @keyframes pulse {
//           0%, 100% { opacity: 1; }
//           50% { opacity: 0.3; }
//         }
//         .price-up { color: #26a69a; font-weight: bold; }
//         .price-down { color: #ef5350; font-weight: bold; }
//       </style>
//     </head>
//     <body>
//       <div id="info">
//         <div id="symbol"><strong>${widget.symbol}</strong></div>
//         <div id="price">Loading...</div>
//       </div>
//       <div id="live-indicator">
//         <div class="pulse"></div>
//         LIVE
//       </div>
//       <div id="chart"></div>
//       <script>
//         let chartData = ${jsonEncode(validData)};
//         let chart, candlestickSeries, indicatorSeries;
//         let currentIndicator = 'none';
//         let isChartReady = false;
        
//         function initChart() {
//           try {
//             if (!chartData || chartData.length === 0) {
//               console.error('❌ No chart data available');
//               document.getElementById('price').innerHTML = '<div style="color: red;">No data</div>';
//               return;
//             }

//             const chartElement = document.getElementById('chart');
//             if (!chartElement) {
//               console.error('❌ Chart element not found');
//               return;
//             }

//             chart = LightweightCharts.createChart(chartElement, {
//               layout: {
//                 background: { color: '#FFFFFF' },
//                 textColor: '#333',
//               },
//               grid: {
//                 vertLines: { color: '#f0f0f0' },
//                 horzLines: { color: '#f0f0f0' },
//               },
//               width: window.innerWidth,
//               height: window.innerHeight,
//               timeScale: {
//                 timeVisible: true,
//                 secondsVisible: true,
//                 rightOffset: 12,
//                 barSpacing: 8,
//                 minBarSpacing: 4,
//                 fixLeftEdge: false,
//                 fixRightEdge: false,
//                 lockVisibleTimeRangeOnResize: true,
//                 rightBarStaysOnScroll: true,
//                 borderVisible: true,
//                 borderColor: '#e1e1e1',
//                 visible: true,
//               },
//               crosshair: {
//                 mode: LightweightCharts.CrosshairMode.Normal,
//                 vertLine: {
//                   width: 1,
//                   color: '#758696',
//                   style: LightweightCharts.LineStyle.Dashed,
//                   labelBackgroundColor: '#4682B4',
//                 },
//                 horzLine: {
//                   width: 1,
//                   color: '#758696',
//                   style: LightweightCharts.LineStyle.Dashed,
//                   labelBackgroundColor: '#4682B4',
//                 },
//               },
//               rightPriceScale: {
//                 borderVisible: true,
//                 borderColor: '#e1e1e1',
//                 visible: true,
//                 scaleMargins: {
//                   top: 0.1,
//                   bottom: 0.1,
//                 },
//               },
//             });

//             candlestickSeries = chart.addCandlestickSeries({
//               upColor: '#26a69a',
//               downColor: '#ef5350',
//               borderVisible: false,
//               wickUpColor: '#26a69a',
//               wickDownColor: '#ef5350',
//               priceFormat: {
//                 type: 'price',
//                 precision: 5,
//                 minMove: 0.00001,
//               },
//             });

//             candlestickSeries.setData(chartData);
//             chart.timeScale().fitContent();

//             chart.subscribeCrosshairMove((param) => {
//               if (param.time) {
//                 const data = param.seriesData.get(candlestickSeries);
//                 if (data) {
//                   updatePriceInfo(data);
//                 }
//               } else {
//                 showLatestPrice();
//               }
//             });

//             showLatestPrice();
            
//             // Mark chart as ready and notify Flutter
//             isChartReady = true;
//             if (window.FlutterChannel) {
//               window.FlutterChannel.postMessage('chart_initialized');
//             }
            
//             console.log('✅ Chart initialized successfully');
//           } catch (error) {
//             console.error('❌ Error initializing chart:', error);
//             document.getElementById('price').innerHTML = '<div style="color: red;">Error: ' + error.message + '</div>';
//           }
//         }

//         function updatePriceInfo(data) {
//           const priceElement = document.getElementById('price');
//           const isUp = data.close >= data.open;
//           priceElement.innerHTML = \`
//             <div class="\${isUp ? 'price-up' : 'price-down'}">
//               O: \${data.open.toFixed(5)} 
//               H: \${data.high.toFixed(5)} 
//               L: \${data.low.toFixed(5)} 
//               C: \${data.close.toFixed(5)}
//             </div>
//           \`;
//         }

//         function showLatestPrice() {
//           if (!chartData || chartData.length === 0) return;
//           const lastCandle = chartData[chartData.length - 1];
//           const isUp = lastCandle.close >= lastCandle.open;
//           document.getElementById('price').innerHTML = \`
//             <div class="\${isUp ? 'price-up' : 'price-down'}">
//               Latest: \${lastCandle.close.toFixed(5)}
//             </div>
//           \`;
//         }

//         function updateChart(newCandle) {
//           if (!isChartReady || !chartData || chartData.length === 0) {
//             console.warn('⚠️ Chart not ready or no data');
//             return;
//           }

//           const lastCandle = chartData[chartData.length - 1];
//           const newTime = Number(newCandle.time);
//           const lastTime = Number(lastCandle.time);
          
//           if (isNaN(newTime) || isNaN(lastTime)) {
//             console.error('❌ Invalid time values');
//             return;
//           }
          
//           // Ignore old data
//           if (newTime < lastTime) {
//             console.warn('⚠️ Ignoring old candle');
//             return;
//           }
          
//           if (newTime === lastTime) {
//             // Update existing candle
//             lastCandle.high = Math.max(lastCandle.high, newCandle.high);
//             lastCandle.low = Math.min(lastCandle.low, newCandle.low);
//             lastCandle.close = newCandle.close;
//             candlestickSeries.update(lastCandle);
//           } else if (newTime > lastTime) {
//             // New candle
//             const newCandleData = {
//               time: newTime,
//               open: newCandle.open,
//               high: newCandle.high,
//               low: newCandle.low,
//               close: newCandle.close
//             };
//             chartData.push(newCandleData);
//             candlestickSeries.update(newCandleData);
//           }
          
//           showLatestPrice();
//         }

//         function changeIndicator(indicator) {
//           currentIndicator = indicator;
          
//           if (indicatorSeries) {
//             chart.removeSeries(indicatorSeries);
//             indicatorSeries = null;
//           }

//           if (indicator === 'none') return;

//           if (indicator === 'sma20') {
//             addSMA(20);
//           } else if (indicator === 'sma50') {
//             addSMA(50);
//           } else if (indicator === 'ema20') {
//             addEMA(20);
//           }
//         }

//         function addSMA(period) {
//           const smaData = calculateSMA(chartData, period);
//           indicatorSeries = chart.addLineSeries({
//             color: '#2962FF',
//             lineWidth: 2,
//             title: \`SMA(\${period})\`,
//           });
//           indicatorSeries.setData(smaData);
//         }

//         function addEMA(period) {
//           const emaData = calculateEMA(chartData, period);
//           indicatorSeries = chart.addLineSeries({
//             color: '#FF6D00',
//             lineWidth: 2,
//             title: \`EMA(\${period})\`,
//           });
//           indicatorSeries.setData(emaData);
//         }

//         function calculateSMA(data, period) {
//           const result = [];
//           for (let i = period - 1; i < data.length; i++) {
//             let sum = 0;
//             for (let j = 0; j < period; j++) {
//               sum += data[i - j].close;
//             }
//             result.push({
//               time: data[i].time,
//               value: sum / period,
//             });
//           }
//           return result;
//         }

//         function calculateEMA(data, period) {
//           const result = [];
//           const multiplier = 2 / (period + 1);
//           let ema = data[0].close;

//           for (let i = 0; i < data.length; i++) {
//             if (i === 0) {
//               ema = data[i].close;
//             } else {
//               ema = (data[i].close - ema) * multiplier + ema;
//             }
//             result.push({
//               time: data[i].time,
//               value: ema,
//             });
//           }
//           return result;
//         }

//         window.addEventListener('resize', () => {
//           if (chart) {
//             chart.resize(window.innerWidth, window.innerHeight);
//           }
//         });

//         if (document.readyState === 'loading') {
//           document.addEventListener('DOMContentLoaded', initChart);
//         } else {
//           initChart();
//         }
//       </script>
//     </body>
//     </html>
//     ''';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('${widget.symbol} Chart'),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 1,
//         actions: [
//           PopupMenuButton<String>(
//             icon: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   selectedTimeframe,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const Icon(Icons.arrow_drop_down, size: 20),
//               ],
//             ),
//             onSelected: _changeTimeframe,
//             itemBuilder:
//                 (context) =>
//                     OHLCService.getTimeframes()
//                         .map(
//                           (tf) => PopupMenuItem<String>(
//                             value: tf['value'],
//                             child: Text(tf['label']!),
//                           ),
//                         )
//                         .toList(),
//           ),
//           PopupMenuButton<String>(
//             icon: const Icon(Icons.show_chart),
//             onSelected: _changeIndicator,
//             itemBuilder:
//                 (context) =>
//                     OHLCService.getIndicators()
//                         .map(
//                           (ind) => PopupMenuItem<String>(
//                             value: ind['value'],
//                             child: Row(
//                               children: [
//                                 if (selectedIndicator == ind['value'])
//                                   const Icon(
//                                     Icons.check,
//                                     size: 18,
//                                     color: Colors.green,
//                                   ),
//                                 const SizedBox(width: 8),
//                                 Text(ind['label']!),
//                               ],
//                             ),
//                           ),
//                         )
//                         .toList(),
//           ),
//         ],
//       ),
//       body:
//           isLoading
//               ? const Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     CircularProgressIndicator(),
//                     SizedBox(height: 16),
//                     Text('Loading chart...'),
//                   ],
//                 ),
//               )
//               : ohlcData.isEmpty
//               ? const Center(child: Text('No data available'))
//               : WebViewWidget(controller: controller),
//     );
//   }
// }
