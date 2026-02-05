// class OrderModifyModel {
//   final int accountId;
//   final int positionId;
//   final double orderPrice;
//   final double stopPrice;
//   final double limitPrice;
//   final int timeinForce;

//   OrderModifyModel({
//   required this.accountId, 
//   required this.positionId, 
//   required this.orderPrice, 
//   required this.stopPrice,
//   required this.limitPrice,
//   required this.timeinForce    

//   });
// }



class ModifyLimitModel {
  final int accountId;
  final int positionId;
  final double orderPrice;
  final double stopPrice;
  final double limitPrice;
  final int timeInForceId;

  ModifyLimitModel({
    required this.accountId,
    required this.positionId,
    required this.orderPrice,
    required this.stopPrice,
    required this.limitPrice,
    required this.timeInForceId,
  });

  
  Map<String, dynamic> toJson() {
    return {
      'account_id': accountId,
      'pending_order_id': positionId,
      'order_price': orderPrice,
      'stop_price': stopPrice,
      'limit_price': limitPrice,
      'time_in_force_id': timeInForceId,
    };
  }

  
  factory ModifyLimitModel.fromJson(Map<String, dynamic> json) {
    return ModifyLimitModel(
      accountId: json['account_id'],
      positionId: json['pending_order_id'],
      orderPrice: (json['order_price'] as num).toDouble(),
      stopPrice: (json['stop_price'] as num).toDouble(),
      limitPrice: (json['limit_price'] as num).toDouble(),
      timeInForceId: json['time_in_force_id'],
    );
  }
}
