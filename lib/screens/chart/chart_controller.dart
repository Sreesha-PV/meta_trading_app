// import 'package:get/get.dart';
// import 'package:netdania/screens/chart/chart_model.dart';
// import 'package:netdania/screens/services/authservices.dart';
// import 'package:netdania/screens/services/socket_connection.dart';


// class CandlestickController extends GetxController {
//   final symbol = ''.obs;
//   final candles = <Candle>[].obs;
//   late LocalWebSocketService wsService;

//   void setSymbol(String newSymbol)async {
//     symbol.value = newSymbol;
//     candles.clear();

//     // wsService = LocalWebSocketService(
//     //   symbols: [newSymbol],
//     //   onData: (data) => _updateCandle(data),
//     // );

//      final token = await AuthService().getToken();
//     if (token == null) {
//       print(" No token found — cannot open WebSocket");
//       return;
//     }

//     wsService.dispose(); // close previous connection if any

//     wsService = LocalWebSocketService(
//       symbols: [newSymbol],
//       onData: (data) => _updateCandle(data),
//       token: token,        // <-- FIXED
//     );
//   }
// The named parameter 'symbols' isn't defined.
// Try correcting the name to an existing named parameter's name, or defining a named parameter with the name 'symbols'.

// The named parameter 'token' isn't defined.
// Try correcting the name to an existing named parameter's name, or defining a named parameter with the name 'token'.
//   void _updateCandle(Map<String, dynamic> data) {
//     // Example: data = { "symbol": "EURUSD", "price": 1.1234, "time": 1690000000 }
//     final price = double.tryParse(data['price'].toString()) ?? 0.0;
//     final timestamp = DateTime.fromMillisecondsSinceEpoch(data['time'] * 1000);

//     // Check last candle
//     if (candles.isEmpty || candles.last.time.day != timestamp.day) {
//       // Create new candle
//       candles.add(Candle(
//         time: timestamp,
//         open: price,
//         high: price,
//         low: price,
//         close: price,
//       ));
//     } else {
//       // Update last candle
//       final last = candles.last;
//       candles[candles.length - 1] = Candle(
//         time: last.time,
//         open: last.open,
//         high: price > last.high ? price : last.high,
//         low: price < last.low ? price : last.low,
//         close: price,
//       );
//     }
//   }

//   @override
//   void onClose() {
//     wsService.dispose();
//     super.onClose();
//   }
// }





import 'package:get/get.dart';
import 'package:netdania/screens/chart/chart_model.dart';
import 'package:netdania/screens/services/authservices.dart';
import 'package:netdania/screens/services/socket_connection.dart';

class CandlestickController extends GetxController {
  final symbol = ''.obs;
  final candles = <Candle>[].obs;
  LocalWebSocketService? wsService;

  Future<void> setSymbol(String newSymbol) async {
    symbol.value = newSymbol;
    candles.clear();

    final token = await AuthService().getToken();
    if (token == null || token.isEmpty) {
      print(' No token found — cannot open WebSocket');
      return;
    }

 
    wsService?.dispose();

  //   wsService = LocalWebSocketService(
  //     onData: (data) => _updateCandle(data), 
  //   );

  //   wsService!.connect(
  //     token: token,
  //     symbols: [newSymbol],
  //   );
  // }

  void updateCandle(Map<String, dynamic> data) {
    final price = double.tryParse(data['price']?.toString() ?? '') ?? 0.0;
    final timestamp = DateTime.fromMillisecondsSinceEpoch(
      (data['time'] ?? 0) * 1000,
    );

    if (candles.isEmpty ||
        candles.last.time.minute != timestamp.minute) {
      candles.add(Candle(
        time: timestamp,
        open: price,
        high: price,
        low: price,
        close: price,
      ));
    } else {
      final last = candles.last;
      candles[candles.length - 1] = Candle(
        time: last.time,
        open: last.open,
        high: price > last.high ? price : last.high,
        low: price < last.low ? price : last.low,
        close: price,
      );
    }
  }

  @override
  void onClose() {
    wsService?.dispose();
    super.onClose();
  }
}
}


