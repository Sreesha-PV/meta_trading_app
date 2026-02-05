// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:candlesticks/candlesticks.dart';
// import 'package:http/http.dart' as http;
// import 'package:netdania/app/modules/home/widgets/app_drawer.dart';
// import 'package:netdania/screens/services/socket_connection.dart';

// class LiveCandlestickChart extends StatefulWidget {
//   final String symbol;
//   final String interval;

//   const LiveCandlestickChart({
//     super.key,
//     required this.symbol,
//     this.interval = "1m",
//   });

//   @override
//   State<LiveCandlestickChart> createState() => _LiveCandlestickChartState();
// }

// class _LiveCandlestickChartState extends State<LiveCandlestickChart> {
//   final List<Candle> candles = [];
//   // BinanceWebSocketServiceKline? _webSocket;
//   LocalWebSocketService? _webSocket;

//   bool _isLoading = true;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   double? currentPrice;
//   late Timer _timer;
//   DateTime currentTime = DateTime.now();

//   @override
//   void initState() {
//     super.initState();
//     fetchInitialCandles();

//     // Connect to Binance WebSocket
//     // _webSocket = BinanceWebSocketServiceKline(
//     //   widget.symbol,
//     //   widget.interval,
//     //   _handleKline,
//     // );
//     // _webSocket = LocalWebSocketService(_handleKline);
//     _webSocket = LocalWebSocketService(
//       symbols: [widget.symbol],
//       onData: _handleKline,
//     );

//     // Start timer to update live time every second
//     _timer = Timer.periodic(const Duration(seconds: 1), (_) {
//       setState(() {
//         currentTime = DateTime.now();
//       });
//     });
//   }

//   // Future<void> fetchInitialCandles() async {
//   // final url = 'http://192.168.4.30:3500/api/v1/price?symbols=AUDCAD,EURUSD,GBPJPY';
//   // // final url = 'ws://192.168.4.30:8000/ticker';
//   // final response = await http.get(Uri.parse(url));

//   Future<void> fetchInitialCandles() async {
//     debugPrint("Fetching initial candles...");
//     final url =
//         'http://192.168.4.30:3500/api/v1/price?symbols=${widget.symbol}';
//     final response = await http.get(Uri.parse(url));
//     debugPrint("Status: ${response.statusCode}");
//     debugPrint("Body: ${response.body}");

//     if (response.statusCode == 200) {
//       final decoded = jsonDecode(response.body);
//       final List<dynamic> data = decoded['data'];

//       double parseDouble(dynamic value) {
//         if (value is double) return value;
//         if (value is int) return value.toDouble();
//         if (value is String) return double.tryParse(value) ?? 0.0;
//         return 0.0;
//       }

//       final List<Candle> fetchedCandles = data
//           .where((e) => e['item_code'] == widget.symbol)
//           .map<Candle>(
//             (e) => Candle(
//               date: DateTime.parse(e['time']),
//               open: parseDouble(e['open']),
//               high: parseDouble(e['high']),
//               low: parseDouble(e['low']),
//               close: parseDouble(e['last']),
//               volume: parseDouble(e['volume']),
//             ),
//           )
//           .toList();

//       setState(() {
//         candles.addAll(fetchedCandles.reversed); // reverse if newest last
//         currentPrice = candles.isNotEmpty ? candles.last.close : null;
//         _isLoading = false;
//       });
//     } else {
//       debugPrint(
//         'Failed to fetch initial candles. Status code: ${response.statusCode}',
//       );
//       debugPrint('Response body: ${response.body}');
//       setState(() => _isLoading = false);
//     }
//   }

//   // void _handleKline(Map<String, dynamic> kline) {
//   //   try {
//   //     if ([
//   //       kline['item_code'],
//   //       kline['time'],
//   //       kline['open'],
//   //       kline['high'],
//   //       kline['low'],
//   //       kline['last'],
//   //       kline['volume'],
//   //     ].any((x) => x == null)) {
//   //       debugPrint('Invalid kline data: $kline');
//   //       return;
//   //     }

//   //     if (kline['item_code'] != widget.symbol) {
//   //       return;
//   //     }

//   //     final candle = Candle(
//   //       date: DateTime.parse(kline['time']),
//   //       open: double.parse(kline['open']),
//   //       high: double.parse(kline['high']),
//   //       low: double.parse(kline['low']),
//   //       close: double.parse(kline['last']),
//   //       volume: double.parse(kline['volume']),
//   //     );

//   //     setState(() {
//   //       currentPrice = candle.close;

//   //       final existingIndex = candles.indexWhere((c) => c.date == candle.date);
//   //       if (existingIndex != -1) {
//   //         candles[existingIndex] = candle;
//   //       } else {
//   //         candles.insert(0, candle);
//   //       }

//   //       if (candles.length > 50) {
//   //         candles.removeLast();
//   //       }
//   //     });
//   //   } catch (e) {
//   //     debugPrint('Error parsing kline data: $e');
//   //   }
//   // }

//   void _handleKline(Map<String, dynamic> kline) {
//     try {
//       if (!kline.containsKey('item_code')) {
//         print('Ignoring unknown message: $kline');
//         return;
//       }

//       if (kline['item_code'] != widget.symbol) return;

//       final candle = Candle(
//         date: DateTime.parse(kline['time']),
//         open: double.parse(kline['open'].toString()),
//         high: double.parse(kline['high'].toString()),
//         low: double.parse(kline['low'].toString()),
//         close: double.parse(kline['last'].toString()),
//         volume: double.parse(kline['volume'].toString()),
//       );

//       setState(() {
//         currentPrice = candle.close;

//         final existingIndex = candles.indexWhere((c) => c.date == candle.date);
//         if (existingIndex != -1) {
//           candles[existingIndex] = candle;
//         } else {
//           candles.insert(0, candle);
//         }

//         if (candles.length > 50) {
//           candles.removeLast();
//         }
//       });
//     } catch (e) {
//       print('Error parsing kline data: $e');
//     }
//   }

//   @override
//   void dispose() {
//     _webSocket?.dispose();
//     _timer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,

//       // appBar: AppBar(
//       // backgroundColor: Colors.white,

//       //   title: Row(
//       //     children: [

//       //         // CommonMenuIcon(scaffoldKey: _scaffoldKey)
//       //     ],
//       //   ),
//       // ),
//       appBar: _buildAppBar(context),
//       drawer: CommonDrawer(),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           if (currentPrice != null)
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 '${widget.symbol.toUpperCase()} Price: \$${currentPrice!.toStringAsFixed(2)}',
//                 style: const TextStyle(
//                   // fontSize: 20,
//                   // fontWeight: FontWeight.bold,
//                   color: Colors.blue,
//                 ),
//               ),
//             ),
//           // Padding(
//           //   padding: const EdgeInsets.all(8.0),
//           //   child: Text(
//           //     'Live Time: ${currentTime.toLocal().toString().split('.')[0]}',
//           //     style: const TextStyle(fontSize: 16),
//           //   ),
//           // ),
//           Expanded(
//             child: _isLoading || candles.isEmpty
//                 ? const Center(child: CircularProgressIndicator())
//                 : candles.length < 14
//                     ? const Center(
//                         child: Text("Not enough data to display the chart."),
//                       )
//                     : Theme(
//                         data: ThemeData.light().copyWith(
//                           scaffoldBackgroundColor: Colors.white,
//                           canvasColor: Colors.white,
//                           cardColor: Colors.white,
//                           // dialogTheme: const DialogTheme(
//                           //   backgroundColor: Colors.white,
//                           // ),
//                         ),
//                         child: Container(
//                           color: Colors.white,
//                           child:
//                               Candlesticks(candles: candles.reversed.toList()),
//                         ),
//                       ),
//           ),

//           // Expanded(
//           //   child:
//           //   _isLoading || candles.isEmpty
//           //       ?
//           //         const Center(child: CircularProgressIndicator())
//           //       // : Candlesticks(candles: candles),
//           //       : Theme(
//           //         data: ThemeData.light().copyWith(
//           //           scaffoldBackgroundColor: Colors.white,
//           //           canvasColor: Colors.white,
//           //           cardColor: Colors.white, dialogTheme: DialogThemeData(backgroundColor: Colors.white)
//           //         ),
//           //         child: Container(
//           //           color: Colors.white,
//           //           child: Candlesticks(candles: candles.reversed.toList())
//           //           ),
//           //       )
//           // ),
//         ],
//       ),
//     );
//     // );
//   }

//   String formatTime(DateTime dt) {
//     return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}";
//   }

//   PreferredSizeWidget _buildAppBar(BuildContext context) {
//     return AppBar(
//       backgroundColor: Colors.white,
//       automaticallyImplyLeading: false,
//       title: Row(
//         children: [
//           // Icon(Icons.add),
//           Expanded(child: IconButton(onPressed: () {}, icon: Icon(Icons.add))),
//           IconButton(onPressed: () {}, icon: Icon(Icons.add)),
//           IconButton(onPressed: () {}, icon: Icon(Icons.swap_calls_rounded)),
//           TextButton(onPressed: () {}, child: Text('D1')),
//         ],
//       ),
//     );
//   }
// }








// import 'package:flutter/material.dart';
// import 'package:netdania/screens/chart/chart_controller.dart';
// import 'package:netdania/screens/chart/chart_model.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:get/get.dart';

// class CandlestickChartWidget extends StatelessWidget {
//   final CandlestickController controller = Get.put(CandlestickController());

//   CandlestickChartWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       return SfCartesianChart(
//         primaryXAxis: DateTimeAxis(),
//         primaryYAxis: NumericAxis(),
//         series: <CandleSeries>[
//           CandleSeries<Candle, DateTime>(
//             dataSource: controller.candles,
//             xValueMapper: (Candle candle, _) => candle.time,
//             lowValueMapper: (Candle candle, _) => candle.low,
//             highValueMapper: (Candle candle, _) => candle.high,
//             openValueMapper: (Candle candle, _) => candle.open,
//             closeValueMapper: (Candle candle, _) => candle.close,
//           ),
//         ],
//       );
//     });
//   }
// }


// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:netdania/utils/tradingview_mobchart.dart';
// import 'package:netdania/utils/tradingview_webchart.dart';


// class TradingViewChart extends StatelessWidget {
//   final String symbol;

//   const TradingViewChart({super.key, required this.symbol});

//   @override
//   Widget build(BuildContext context) {
//     if (kIsWeb) {
//       return TradingViewWeb(symbol: symbol);
//     } else {
//       return TradingViewMobile(symbol: symbol);
//     }
//   }
// }

