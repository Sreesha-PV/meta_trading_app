// class TradeOrder {
//   // final String symbol;
//   final String side;
//   final double price;
//   final int quantity;
//   final DateTime time;

//   TradeOrder({
//     // required this.symbol,
//     required this.side,
//     required this.price,
//     required this.quantity,
//     required this.time,
//   });
// }




class TradeOrder {
  final String side;
  final double price;
  final int quantity;
  final DateTime time;

  TradeOrder({
    required this.side,
    required this.price,
    required this.quantity,
    required this.time,
  });

  // Convert TradeOrder to Map (for storage)
  Map<String, dynamic> toJson() {
    return {
      'side': side,
      'price': price,
      'quantity': quantity,
      'time': time.toIso8601String(),
    };
  }

  // Create TradeOrder from Map (from storage)
  factory TradeOrder.fromJson(Map<String, dynamic> json) {
    return TradeOrder(
      side: json['side'],
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'],
      time: DateTime.parse(json['time']),
    );
  }
}
