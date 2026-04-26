// class CandleData {
//   final DateTime time;
//   final double open;
//   final double high;
//   final double low;
//   final double close;

//   CandleData({
//     required this.time,
//     required this.open,
//     required this.high,
//     required this.low,
//     required this.close,
//   });
// }


// class OHLCData {
//   final DateTime time;
//   final double open;
//   final double high;
//   final double low;
//   final double close;

//   OHLCData({
//     required this.time,
//     required this.open,
//     required this.high,
//     required this.low,
//     required this.close,
//   });

//   factory OHLCData.fromJson(Map<String, dynamic> json) {
//     return OHLCData(
//       time: DateTime.parse(json['time']),
//       open: (json['open'] as num).toDouble(),
//       high: (json['high'] as num).toDouble(),
//       low: (json['low'] as num).toDouble(),
//       close: (json['close'] as num).toDouble(),
//     );
//   }
// }
