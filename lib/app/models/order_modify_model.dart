// class OrderModifyModel {
//   final int accountId;
//   final int pendingOrderId;
//   final double orderPrice;
//   final double stopPrice;
//   final double limitPrice;
//   final int timeinForce;

//   OrderModifyModel({
//   required this.accountId, 
//   required this.pendingOrderId, 
//   required this.orderPrice, 
//   required this.stopPrice,
//   required this.limitPrice,
//   required this.timeinForce    

//   });
// }



class ModifyOrderModel {
  final int accountId;
  final int pendingOrderId;
  final double orderPrice;
  final double stopPrice;
  final double limitPrice;
  final int timeInForceId;
  final String?expiryDateTime;

  ModifyOrderModel({
    required this.accountId,
    required this.pendingOrderId,
    required this.orderPrice,
    required this.stopPrice,
    required this.limitPrice,
    required this.timeInForceId,
    required this.expiryDateTime
  });

  
  Map<String, dynamic> toJson() {
    return {
      'account_id': accountId,
      'pending_order_id': pendingOrderId,
      'order_price': orderPrice,
      'stop_price': stopPrice,
      'limit_price': limitPrice,
      'time_in_force_id': timeInForceId,
      if (expiryDateTime != null)
      'expiry_date_time': expiryDateTime,
    };
  }

  
  factory ModifyOrderModel.fromJson(Map<String, dynamic> json) {
    return ModifyOrderModel(
      accountId: json['account_id'],
      pendingOrderId: json['pending_order_id'],
      orderPrice: (json['order_price'] as num).toDouble(),
      stopPrice: (json['stop_price'] as num).toDouble(),
      limitPrice: (json['limit_price'] as num).toDouble(),
      timeInForceId: json['time_in_force_id'],
      expiryDateTime: json['expiry_date_time']
    );
  }
}
