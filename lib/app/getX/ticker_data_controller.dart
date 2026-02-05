// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// class TickerDataController extends GetxController {
//   var data = <Map<String, dynamic>>[].obs;  

//   late WebSocketChannel _channel;

//   @override
//   void onInit() {
//     super.onInit();
//     _channel = WebSocketChannel.connect(
//       Uri.parse('wss://stream.binance.com:9443/ws'),
//     );

//     _channel.sink.add(jsonEncode({
//       "method": "SUBSCRIBE",
//       "params": [
//         "btcusdt@ticker",
//         "ethusdt@ticker",
//         "bnbusdt@ticker",
//         "adausdt@ticker",
//         "xrpusdt@ticker",
//         "solusdt@ticker",
//       ],
//       "id": 1,
//     }));

//     _channel.stream.listen((event) {
//       final decoded = jsonDecode(event);
//       if (decoded['e'] == '24hrTicker') {
//         final updatedItem = {
//           'name': decoded['s'],
//           'last': decoded['c'],
//           'change': '${decoded['P']}%',
//           'bid': decoded['b'],
//           'ask': decoded['a'],
//           'high': decoded['h'],
//           'low': decoded['l'],
//           'close': decoded['c'],
//         };

//         final index = data.indexWhere((item) => item['name'] == decoded['s']);
//         if (index != -1) {
//           data[index] = updatedItem;
//         } else {
//           data.add(updatedItem);
//         }
//       }
//     });
//   }

//   @override
//   void onClose() {
//     _channel.sink.close();
//     super.onClose();
//   }
// }




