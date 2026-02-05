
class OhlcCandle {
  final DateTime time;
  final double open;
  final double high;
  final double low;
  final double close;

  OhlcCandle({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });

  factory OhlcCandle.fromJson(Map<String, dynamic> json) {
    return OhlcCandle(
      time: DateTime.fromMillisecondsSinceEpoch(json['time'] * 1000),
      open: (json['open'] as num).toDouble(),
      high: (json['high'] as num).toDouble(),
      low: (json['low'] as num).toDouble(),
      close: (json['close'] as num).toDouble(),
    );
  }
}



