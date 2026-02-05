// class MarketData {
//   final String symbol;
//   final String sell;
//   final String buy;
//   final String spread;
//   final bool sellUp;
//   final bool buyUp;
//   final String time;
//   final String high;
//   final String low;
//   final String close;

//   MarketData({
//     required this.symbol,
//     required this.sell,
//     required this.buy,
//     required this.spread,
//     required this.sellUp,
//     required this.buyUp,
//     required this.time,
//     required this.high,
//     required this.low,
//     required this.close,
//   });

//   factory MarketData.fromWebSocket(Map<String, dynamic> data, Map<String, String> oldPrice) {
//     final symbol = data['s'];
//     final buy = data['a'];
//     final sell = data['b'];
//     final close = data['c'];
//     final high = data['h'];
//     final low = data['l'];

//     final oldSell = double.tryParse(oldPrice['sell'] ?? '0') ?? 0;
//     final oldBuy = double.tryParse(oldPrice['buy'] ?? '0') ?? 0;

//     final newSell = double.tryParse(sell) ?? 0;
//     final newBuy = double.tryParse(buy) ?? 0;

//     return MarketData(
//       symbol: symbol,
//       sell: sell,
//       buy: buy,
//       spread: (newBuy - newSell).toStringAsFixed(2),
//       sellUp: newSell >= oldSell,
//       buyUp: newBuy >= oldBuy, 
//       time: DateTime.now().toLocal().toIso8601String().substring(11, 19),
//       high: high,
//       low: low,
//       close: close,
//     );
//   }
// }