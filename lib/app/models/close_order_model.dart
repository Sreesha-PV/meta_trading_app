// class CloseOrder {
//   final String symbol;
//   final String orderSide;
//   final int volume;
//   final double rate;
//   final DateTime createdAt;
//   final double margin;
//   final double roll;
//   final double fee;
//   final bool tracked;

//   CloseOrder({
//     required this.symbol,
//     required this.orderSide,
//     required this.volume,
//     required this.rate,
//     required this.createdAt,
//     required this.margin,
//     required this.roll,
//     required this.fee,
//     required this.tracked,
//   });

//     factory CloseOrder.fromJson(Map<String, dynamic> json) {
//       return CloseOrder(
//         symbol: json['symbol'] ?? '',
//         orderSide: json['orderSide'] ?? '',
//         volume: json['volume'] ?? 0,
//         rate: (json['rate'] ?? 0).toDouble(),
//         createdAt: DateTime.parse(json['createdAt']),
//         margin: (json['margin'] ?? 0).toDouble(),
//         roll: (json['roll'] ?? 0).toDouble(),
//         fee: (json['fee'] ?? 0).toDouble(),
//         tracked: json['tracked'] ?? false,
//       );
//     }

// }



class ClosePositionModel {
  final int instrumentId;
  final int side;
  final int orderType;
  final double orderPrice;
  final double orderQty;
  final int accountId;
  final int relatedPositionId;

  ClosePositionModel({
    required this.instrumentId,
    required this.side,
    required this.orderType,
    required this.orderPrice,
    required this.orderQty,
    required this.accountId,
    required this.relatedPositionId,
  });

  Map<String, dynamic> toJson() {
    return {
      'instrument_id': instrumentId,
      'side': side,
      'order_type': orderType,
      'order_qty': orderQty,
      'order_price': orderPrice,
      'account_id': accountId,
      'related_position_id': relatedPositionId,
    };
  }

  factory ClosePositionModel.fromJson(Map<String, dynamic> json) {
    return ClosePositionModel(
      instrumentId: json['instrument_id'],
      side: json['side'],
      orderType: json['order_type'],
      orderPrice: json['order_price'].toDouble(),
      orderQty: json['order_qty'],
      accountId: json['account_id'],
      relatedPositionId: json['related_position_id'],
    );
  }
}

