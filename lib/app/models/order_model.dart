import 'package:netdania/app/models/positions_model.dart';

class OrderRequestModel {
  final int accountId;
  // final String accountUuid;
  final int instrumentId;
  final int side; // 1 = Buy , 2 =Sell,
  final int orderType; // 1 = Market, 2 = Limit, etc.
  final double orderQty;
  final int timeInForceId; //  1 = Fill or Kill
  final double orderPrice;
  final double? stopPrice;
  final double ?limitPrice;
  final String clientRemark;
  final String opRemark;
  final String sysRemark;
  final int? related_position_id;
  final String?expiryDateTime;


  OrderRequestModel({
    // required this.userId,
    // required this.userUuid,
    required this.accountId,
    // required this.accountUuid,
    required this.instrumentId,
    required this.side,
    required this.orderType,
    required this.orderQty,
    required this.timeInForceId,
    required this.orderPrice,
    // this.stopPrice = 0.0, //S/L
    // this.limitPrice = 0.0, //T/P
     this.stopPrice,
     this.limitPrice,
    this.clientRemark = '',
    this.opRemark = '',
    this.sysRemark = '',
    this.related_position_id,
    required this.expiryDateTime,
  });

  // Map<String, dynamic> toJson() => {
  //   // 'user_id': userId,
  //   // 'user_uuid': userUuid,
  //   'account_id': accountId,
  //   // 'account_uuid': accountUuid,
  //   'instrument_id': instrumentId,
  //   'side': side,
  //   'order_type': orderType,
  //   'order_qty': orderQty,
  //   'time_in_force_id': timeInForceId,
  //   'order_price': orderPrice,
  //   'stop_price': stopPrice,
  //   'limit_price': limitPrice,
  //   'client_remark': clientRemark,
  //   'op_remark': opRemark,
  //   'sys_remark': sysRemark,
  //   'related_position_id': related_position_id,
  //   // 'expiry_date_time': expiryDateTime

    
  // };

 
 
Map<String, dynamic> toJson() {
  final map = {
    'account_id': accountId,
    'instrument_id': instrumentId,
    'side': side,
    'order_type': orderType,
    'order_qty': orderQty,
    'time_in_force_id': timeInForceId,
    'order_price': orderPrice,
    'stop_price': stopPrice,
    'limit_price': limitPrice,
    'client_remark': clientRemark,
    'op_remark': opRemark,
    'sys_remark': sysRemark,
    'related_position_id': related_position_id,
  };

  if (expiryDateTime != null) {
    map['expiry_date_time'] = expiryDateTime;
  }

  return map;
}
  Position toPositionFromServer(Map<String, dynamic> serverData) {
    return Position.fromJson(serverData);
  }


  @override
  String toString() {
    return 'OrderModel(instrumentId: $instrumentId, side: $side, orderType: $orderType, orderQty: $orderQty,limit_price:$limitPrice related_position_id: $related_position_id)';
  }
}



