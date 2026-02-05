class ClosedOrder {
  final int settlementId;
  final int accountId;
  final String accountUuid;
  final int instrumentId;
  final int refPositionId;
  final int refClosingPositionId;
  final double settledQty;
  final double settledPl;
  final String settlementDate;
  final double? currencyRate;
  final double? accumulatingStorage;
  final double? commissionPaid;
  final double? otherCharges;
  final String lastUpdateTime;

  ClosedOrder({
    required this.settlementId,
    required this.accountId,
    required this.accountUuid,
    required this.instrumentId,
    required this.refPositionId,
    required this.refClosingPositionId,
    required this.settledQty,
    required this.settledPl,
    required this.settlementDate,
    this.currencyRate,
    this.accumulatingStorage,
    this.commissionPaid,
    this.otherCharges,
    required this.lastUpdateTime,
  });

  @override
  String toString() {
    return 'ClosedOrder('
        'settlementId: $settlementId, '
        'accountId: $accountId, '
        'accountUuid: $accountUuid, '
        'instrumentId: $instrumentId, '
        'refPositionId: $refPositionId, '
        'refClosingPositionId: $refClosingPositionId, '
        'settledQty: $settledQty, '
        'settledPl: $settledPl, '
        'settlementDate: $settlementDate, '
        'currencyRate: $currencyRate, '
        'accumulatingStorage: $accumulatingStorage, '
        'commissionPaid: $commissionPaid, '
        'otherCharges: $otherCharges, '
        'lastUpdateTime: $lastUpdateTime, '
        ')';
  }

  factory ClosedOrder.fromJson(Map<String, dynamic> json) {
    return ClosedOrder(
      settlementId: json['settlement_id'],
      accountId: json['account_id'],
      accountUuid: json['account_uuid'],
      instrumentId: json['instrument_id'],
      refPositionId: json['ref_position_id'],
      refClosingPositionId: json['ref_closing_position_id'],
      settledQty: json['settled_qty']?.toDouble() ?? 0.0,
      settledPl: json['settled_pl']?.toDouble() ?? 0.0,
      settlementDate: json['settlement_date'],
      currencyRate: json['currency_rate']?.toDouble(),
      accumulatingStorage: json['accumulating_storage']?.toDouble(),
      commissionPaid: json['commision_paid']?.toDouble(),
      otherCharges: json['other_charges']?.toDouble(),
      lastUpdateTime: json['last_update_time'],
    );
  }
}



// Widget _buildSummarySection(List<ClosedOrder> closedOrders) {
//   double profit = 0;
//   double commission = 0;
//   double swap = 0;

  // for (final o in closedOrders) {
  //   profit += o.settledPl;
  //   commission += o.commissionPaid ?? 0;
  //   swap += o.accumulatingStorage ?? 0;
  // }

//   return Column(
//     children: [
//       _summaryRow("Profit", profit),
//       _summaryRow("Swap", swap),
//       _summaryRow("Commission", commission),
//       _summaryRow("Net", profit + swap + commission),
//     ],
//   );
// }

// final profit = order.settledPl;
// final qty = order.settledQty;
// final date = order.settlementDate;
