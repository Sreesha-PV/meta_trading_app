
class PendingOrder {
  final int pendingOrderId;
  final int accountId;
  final int instrumentId;
  final int side;
  final double orderQty;
  final double remainingQty;
  final int orderStatus;
  double orderPrice;
  final int orderType;
  double? stopPrice;
  double? limitPrice;
  final int relatedPositionId;
  final int timeInForceId;
  final DateTime? createdAt;

  PendingOrder({
    required this.pendingOrderId,
    required this.accountId,
    required this.instrumentId,
    required this.side,
    required this.orderQty,
    required this.remainingQty,
    required this.orderStatus,
    required this.orderPrice,
    required this.relatedPositionId,
    required this.timeInForceId,
    required this.orderType,
    // required this.createdAt,
    this.createdAt,
    this.stopPrice,
    this.limitPrice,
  });

  @override
  String toString() {
    return 'PendingOrder('
        'id: $pendingOrderId, '
        'accountId: $accountId, '
        'instrumentId: $instrumentId, '
        'side: $side, '
        'type: $orderType, '
        'status: $orderStatus, '
        'qty: $orderQty, '
        'remainingQty: $remainingQty, '
        'price: $orderPrice, '
        'stopPrice: $stopPrice, '
        'limitPrice: $limitPrice, '
        'relatedPositionId: $relatedPositionId, '
        'timeInForceId: $timeInForceId'
        ')';
  }

  factory PendingOrder.fromJson(Map<String, dynamic> json) {
    return PendingOrder(
      pendingOrderId: json['pending_order_id'],
      accountId: json['account_id'],
      instrumentId: json['instrument_id'],
      side: json['side'],
      orderType: json['order_type'],
      orderStatus: json['order_status'],
      orderQty: (json['order_qty'] ?? 0).toDouble(),
      remainingQty: (json['remaining_qty'] ?? 0).toDouble(),
      orderPrice: (json['order_price'] ?? 0).toDouble(),
      // createdAt: DateTime.parse(json['created_at']),
          createdAt: json['created_at'] != null
        ? DateTime.tryParse(json['created_at'].toString())
        : null,
      stopPrice:
          json['stop_price'] != null
              ? (json['stop_price'] as num).toDouble()
              : null,
      limitPrice:
          json['limit_price'] != null
              ? (json['limit_price'] as num).toDouble()
              : null,
      // relatedPositionId: json['related_position_id'],
      relatedPositionId:
          int.tryParse(json['related_position_id'].toString()) ?? 0,
      //  relatedPositionId: json['related_position_id'] != null
      //   ? int.tryParse(json['related_position_id'].toString())
      //   : null,

      timeInForceId: json['time_in_force_id'] ?? 0,
    );
  }

  operator [](String other) {}
}

// class PendingOrder {
//   final int pendingOrderId;
//   final String pendingOrderUuid;
//   final int accountId;
//   final String accountUuid;
//   final int instrumentId;
//   final int side;
//   final int orderType;
//   final double orderQty;
//   final double remainingQty;
//   double orderPrice;
//   final int orderStatus;
//   final int? relatedPositionId;
//   final int timeInForceId;
//   final DateTime? createdAt;
//   double? stopPrice;
//   double? limitPrice;
//   final double? trailingStop;
//   final DateTime? expiryDateTime;
//   final double? executedQty;
//   final String? clientRemark;
//   final String? opRemark;
//   final String? sysRemark;
//   final DateTime? lastUpdateTime;
//   final int? orderTagId;
//   final int? orderSourceId;
//   final int? requestedByUserId;
//   final double? maxDeviation;
//   final double? serverAsk;
//   final double? serverBid;
//   final int? clientRequestDetailsId;
//   final double? clientAsk;
//   final double? clientBid;
//   final DateTime? priceLastUpdatedAtClient;
//   final DateTime? ticketTimeAtClient;
//   final int? itemStatusAtClient;
//   final double? touchQty;
//   final double? touchPrice;
//   final DateTime? touchTime;

//   PendingOrder({
//     required this.pendingOrderId,
//     required this.pendingOrderUuid,
//     required this.accountId,
//     required this.accountUuid,
//     required this.instrumentId,
//     required this.side,
//     required this.orderType,
//     required this.orderQty,
//     required this.remainingQty,
//     required this.orderPrice,
//     required this.orderStatus,
//     this.relatedPositionId,
//     required this.timeInForceId,
//     this.createdAt,
//     this.stopPrice,
//     this.limitPrice,
//     this.trailingStop,
//     this.expiryDateTime,
//     this.executedQty,
//     this.clientRemark,
//     this.opRemark,
//     this.sysRemark,
//     this.lastUpdateTime,
//     this.orderTagId,
//     this.orderSourceId,
//     this.requestedByUserId,
//     this.maxDeviation,
//     this.serverAsk,
//     this.serverBid,
//     this.clientRequestDetailsId,
//     this.clientAsk,
//     this.clientBid,
//     this.priceLastUpdatedAtClient,
//     this.ticketTimeAtClient,
//     this.itemStatusAtClient,
//     this.touchQty,
//     this.touchPrice,
//     this.touchTime,
//   });

//   factory PendingOrder.fromJson(Map<String, dynamic> json) {
//     DateTime? parseDate(String? dateStr) =>
//         dateStr != null ? DateTime.tryParse(dateStr) : null;

//     double? parseDouble(dynamic value) =>
//         value != null ? (value as num).toDouble() : null;

//     return PendingOrder(
//       pendingOrderId: json['pending_order_id'],
//       pendingOrderUuid: json['pending_order_uuid'],
//       accountId: json['account_id'],
//       accountUuid: json['account_uuid'],
//       instrumentId: json['instrument_id'],
//       side: json['side'],
//       orderType: json['order_type'],
//       orderQty: (json['order_qty'] ?? 0).toDouble(),
//       remainingQty: (json['remaining_qty'] ?? 0).toDouble(),
//       orderPrice: (json['order_price'] ?? 0).toDouble(),
//       orderStatus: json['order_status'],
//       relatedPositionId: json['related_position_id'],
//       timeInForceId: json['time_in_force_id'] ?? 0,
//       createdAt: parseDate(json['order_time']),
//       stopPrice: parseDouble(json['stop_price']),
//       limitPrice: parseDouble(json['limit_price']),
//       trailingStop: parseDouble(json['trailing_stop']),
//       expiryDateTime: parseDate(json['expiry_date_time']),
//       executedQty: parseDouble(json['executed_qty']),
//       clientRemark: json['client_remark'],
//       opRemark: json['op_remark'],
//       sysRemark: json['sys_remark'],
//       lastUpdateTime: parseDate(json['last_update_time']),
//       orderTagId: json['order_tag_id'],
//       orderSourceId: json['order_source_id'],
//       requestedByUserId: json['requested_by_user_id'],
//       maxDeviation: parseDouble(json['max_deviation']),
//       serverAsk: parseDouble(json['server_ask']),
//       serverBid: parseDouble(json['server_bid']),
//       clientRequestDetailsId: json['client_request_details_id'],
//       clientAsk: parseDouble(json['client_ask']),
//       clientBid: parseDouble(json['client_bid']),
//       priceLastUpdatedAtClient: parseDate(json['price_last_updated_at_client']),
//       ticketTimeAtClient: parseDate(json['ticket_time_at_client']),
//       itemStatusAtClient: json['item_status_at_client'],
//       touchQty: parseDouble(json['touch_qty']),
//       touchPrice: parseDouble(json['touch_price']),
//       touchTime: parseDate(json['touch_time']),
//     );
//   }

//   @override
//   String toString() {
//     return 'PendingOrder(id: $pendingOrderId, uuid: $pendingOrderUuid, account: $accountId, instrument: $instrumentId, side: $side, type: $orderType, status: $orderStatus, qty: $orderQty, remainingQty: $remainingQty, price: $orderPrice)';
//   }
// }
