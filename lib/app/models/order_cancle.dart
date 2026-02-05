class CancelOrderModel{
  final int accountId;
  final int refPendingOrderId;
  final double cancelledQty;

CancelOrderModel( {
  required this.accountId,
  required this.refPendingOrderId, 
  required this.cancelledQty,
});

 Map<String, dynamic> toJson() {
    return {
      'account_id': accountId,
      'ref_pending_order_id': refPendingOrderId,
      'cancelled_qty' : cancelledQty
    };
  }

  
  factory CancelOrderModel.fromJson(Map<String, dynamic> json) {
    return CancelOrderModel(
     accountId: json['account_id'],
     refPendingOrderId: json['ref_pending_order_id'],
     cancelledQty: json['cancelled_qty']
    );
  }
}





