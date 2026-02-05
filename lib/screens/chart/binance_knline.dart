import 'dart:convert';
import 'package:netdania/app/core/constants/urls.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// class BinanceWebSocketServiceKline {
//   final String symbol;
//   final String interval;
//   final Function(Map<String, dynamic>) onKline;
//   // late IOWebSocketChannel _channel;
//   late WebSocketChannel _channel;

//   BinanceWebSocketServiceKline(this.symbol, this.interval, this.onKline) {
//     // final url = 'wss://stream.binance.com:9443/ws/${symbol.toLowerCase()}@kline_$interval';
//     // final url = 'ws://192.168.4.30:8000/ticker';
//     // _channel = IOWebSocketChannel.connect(Uri.parse(url));
//     // _channel = WebSocketChannel.connect(Uri.parse(url));
//     _channel = WebSocketChannel.connect(Uri.parse(ApiUrl.wstickerUrl));

//     // _channel.stream.listen((message) {
//     //   final data = jsonDecode(message);
//     //   final kline = data['k'];
//     //   if (kline != null) {
//     //     onKline(kline);
//     //   }
//     // },
//     // onError: (error) {
//     //   print('WebSocket error: $error');
//     // }, onDone: () {
//     //   print('WebSocket closed');
//     // });

//     _channel.stream.listen((message) {
//       // print('Raw WebSocket message: $message');

//       // Only try to decode if the message starts with '{' or '['
//       if (message.trim().startsWith('{') || message.trim().startsWith('[')) {
//         try {
//           final data = jsonDecode(message);

//           if (data is Map<String, dynamic> && data.containsKey('k')) {
//             final kline = data['k'];
//             if (kline != null) {
//               onKline(kline);
//             }
//           }
//         } catch (e) {
//           print('WebSocket JSON error: $e');
//         }
//       } else {
//         print('Ignored non-JSON WebSocket message');
//       }
//     });
//   }

//   void dispose() {
//     _channel.sink.close();
//   }
// }



// class BinanceWebSocketServiceKline {
//   final String symbol;
//   final String interval;
//   final Function(Map<String, dynamic>) onKline;
//   late WebSocketChannel _channel;

//   BinanceWebSocketServiceKline(
//     this.symbol,
//     this.interval,
//     this.onKline,
//     String token,
//   ) {
//     _channel = WebSocketChannel.connect(
//       Uri.parse(ApiUrl.wstickerUrl(token)),
//     );

//     _channel.stream.listen(
//       (message) {
//         if (message.trim().startsWith('{')) {
//           try {
//             final data = jsonDecode(message);
//             if (data is Map<String, dynamic> && data['k'] != null) {
//               onKline(data['k']);
//             }
//           } catch (e) {
//             print('WebSocket JSON error: $e');
//           }
//         }
//       },
//       onError: (e) => print('WebSocket error: $e'),
//       onDone: () => print('WebSocket closed'),
//     );
//   }

//   void dispose() {
//     _channel.sink.close();
//   }
// }



class BinanceWebSocketServiceKline {
  final String symbol;
  final String interval;
  final Function(Map<String, dynamic>) onKline;
  late WebSocketChannel _channel;

  BinanceWebSocketServiceKline(
    this.symbol,
    this.interval,
    this.onKline,
    String token,
  
  ) {
    final url = ApiUrl.wsTickerUrl;
    print('Connecting to WebSocket: $url');

    _channel = WebSocketChannel.connect(
      // Uri.parse(url)
      Uri.parse(ApiUrl.wsTickerUrl(token)),
      );

    _channel.stream.listen(
      (message) {
        if (message is String && message.trim().startsWith('{')) {
          try {
            final data = jsonDecode(message);
            if (data is Map<String, dynamic> && data['k'] != null) {
              onKline(data['k']);
            }
          } catch (e) {
            print('WebSocket JSON error: $e');
          }
        }
      },
      onError: (e) => print('WebSocket error: $e'),
      onDone: () => print('WebSocket closed'),
    );
  }

  void dispose() {
    _channel.sink.close();
  }
}


