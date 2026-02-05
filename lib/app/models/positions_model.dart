// class Position {
//   final int accountId;
//   // final int status;
//   final int instrumentId;
//   final int side; // 1 = Sell, 2 = Buy
//   final int positionId;
//   final double positionQty;
//   final double positionInitialQty;
//   final double orderPrice;
//   final int? refPendingOrderId;
   
//   Position( {
//     required this.accountId,
//     // required this.status,
//     required this.instrumentId,
//     required this.side,
//     required this.positionId,
//     required this.positionQty,
//     required this.positionInitialQty,
//     required this.orderPrice,
//     required this.refPendingOrderId,
//   });

//   Position copyWith({
//   double? positionQty,
// }) {
//   return Position(
//     accountId: accountId,
//     // status: status,
//     instrumentId: instrumentId,
//     side: side,
//     positionId: positionId,
//     positionQty: positionQty ?? this.positionQty,
//     positionInitialQty: positionInitialQty,
//     orderPrice: orderPrice,
//     refPendingOrderId: refPendingOrderId,
//   );
// }


//   factory Position.fromJson(Map<String, dynamic> json) {
//     return Position(
//       accountId: json['account_id'] ?? 0,
//       // status: json['order_status'],
//       instrumentId: json['instrument_id'] ?? 0,
//       side: json['side'] ?? 0,
//       positionId: json['position_id'] ?? 0,
//       positionQty: (json['position_qty'] ?? 0).toDouble(),
//       positionInitialQty: (json['position_initial_qty'] ?? 0).toDouble(),
//       orderPrice: (json['order_price'] ?? 0).toDouble(),
//       refPendingOrderId: json['ref_pending_order_id'], 
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'account_id': accountId,
//         // 'order_status':status,
//         'instrument_id': instrumentId,
//         'side': side,
//         'position_id': positionId,
//         'position_qty': positionQty,
//         'position_initial_qty': positionInitialQty,
//         'order_price': orderPrice,
//       };

//   @override
//   String toString() {
//     return 'Position(accountId: $accountId, instrumentId: $instrumentId, side: $side, positionId: $positionId, positionQty: $positionQty,positionInitialQty: $positionInitialQty, orderPrice: $orderPrice)';
//   }
// }



class Position {
  final int accountId;
  final int instrumentId;
  final int side; // 1 = Sell, 2 = Buy
  final int positionId;
  final double positionQty;
  final double positionInitialQty;
  final double orderPrice;
  final int? refPendingOrderId;
   
  Position( {
    required this.accountId,

    required this.instrumentId,
    required this.side,
    required this.positionId,
    required this.positionQty,
    required this.positionInitialQty,
    required this.orderPrice,
    required this.refPendingOrderId,
  });

  Position copyWith({
  double? positionQty,
}) {
  return Position(
    accountId: accountId,

    instrumentId: instrumentId,
    side: side,
    positionId: positionId,
    positionQty: positionQty ?? this.positionQty,
    positionInitialQty: positionInitialQty,
    orderPrice: orderPrice,
    refPendingOrderId: refPendingOrderId,
  );
}


  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      accountId: json['account_id'] ?? 0,

      instrumentId: json['instrument_id'] ?? 0,
      side: json['side'] ?? 0,
      positionId: json['position_id'] ?? 0,
      positionQty: (json['position_qty'] ?? 0).toDouble(),
      positionInitialQty: (json['position_initial_qty'] ?? 0).toDouble(),
      orderPrice: (json['order_price'] ?? 0).toDouble(),
      refPendingOrderId: json['ref_pending_order_id'], 
    );
  }

  Map<String, dynamic> toJson() => {
        'account_id': accountId,

        'instrument_id': instrumentId,
        'side': side,
        'position_id': positionId,
        'position_qty': positionQty,
        'position_initial_qty': positionInitialQty,
        'order_price': orderPrice,
      };

  @override
  String toString() {
    return 'Position(accountId: $accountId, instrumentId: $instrumentId, side: $side, positionId: $positionId, positionQty: $positionQty,positionInitialQty: $positionInitialQty, orderPrice: $orderPrice)';
  }
}



// class Position {
//   final int positionId;
//   final int accountId;
//   final String accountUuid;
//   final int instrumentId;
//   final int side;
//   final int refPendingOrderId;
//   final int orderExecutionId;
//   final double positionInitialQty;
//   final double positionQty;
//   final double orderPrice;
//   // final double? commisionPaid;
//   // final DateTime positionDate;
//   // final DateTime lastUpdatedDate;
//   // final String? confirmedBy;
//   // final double? unrealisedPl;
//   // final double? accumulatingStorage;
//   // final DateTime? valueDate;
//   // final DateTime? expiryDate;
//   // final String? clientRemark;
//   // final String? opRemark;
//   // final String? sysRemark;

//   Position({
//     required this.positionId,
//     required this.accountId,
//     required this.accountUuid,
//     required this.instrumentId,
//     required this.side,
//     required this.refPendingOrderId,
//     required this.orderExecutionId,
//     required this.positionInitialQty,
//     required this.positionQty,
//     required this.orderPrice,
//     // this.commisionPaid,
//     // required this.positionDate,
//     // required this.lastUpdatedDate,
//     // this.confirmedBy,
//     // this.unrealisedPl,
//     // this.accumulatingStorage,
//     // this.valueDate,
//     // this.expiryDate,
//     // this.clientRemark,
//     // this.opRemark,
//     // this.sysRemark,
//   });

//   factory Position.fromJson(Map<String, dynamic> json) {
//     return Position(
//       positionId: json['position_id'],
//       accountId: json['account_id'],
//       accountUuid: json['account_uuid'],
//       instrumentId: json['instrument_id'],
//       side: json['side'],
//       refPendingOrderId: json['ref_pending_order_id'],
//       orderExecutionId: json['order_execution_id'],
//       positionInitialQty: (json['position_initial_qty'] ?? 0).toDouble(),
//       positionQty: (json['position_qty'] ?? 0).toDouble(),
//       orderPrice: (json['order_price'] ?? 0).toDouble(),
//       // commisionPaid: json['commision_paid'] != null
//       //     ? (json['commision_paid'] as num).toDouble()
//       //     : null,
//       // positionDate: DateTime.parse(json['position_date']),
//       // lastUpdatedDate: DateTime.parse(json['last_updated_date']),
//       // confirmedBy: json['confirmed_by'],
//       // unrealisedPl: json['unrealised_pl'] != null
//       //     ? (json['unrealised_pl'] as num).toDouble()
//       //     : null,
//       // accumulatingStorage: json['accumulating_storage'] != null
//       //     ? (json['accumulating_storage'] as num).toDouble()
//       //     : null,
//       // valueDate: json['value_date'] != null
//       //     ? DateTime.tryParse(json['value_date'])
//       //     : null,
//       // expiryDate: json['expiry_date'] != null
//       //     ? DateTime.tryParse(json['expiry_date'])
//       //     : null,
//       // clientRemark: json['client_remark'],
//       // opRemark: json['op_remark'],
//       // sysRemark: json['sys_remark'],
//     );
//   }

//   @override
//   String toString() {
//     return 'Position(id: $positionId, instrument: $instrumentId, qty: $positionQty, price: $orderPrice)';
//   }
// }
