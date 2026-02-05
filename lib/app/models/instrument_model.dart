class InstrumentModel {
  final int instrumentId;
  final String name;
  final String code;          // EURUSD, USDJPY, etc.
  // final int decimalPlaces;
  // final double tickSize;
  // final double orderQtyStep;
  // final double minOrderQty;
  // final double maxOrderQty;

  InstrumentModel({
    required this.instrumentId,
    required this.name,
    required this.code,
    // required this.decimalPlaces,
    // required this.tickSize,
    // required this.contractSize,
    // required this.orderQtyStep,
    // required this.minOrderQty,
    // required this.maxOrderQty,
  });

  factory InstrumentModel.fromJson(Map<String, dynamic> json) {
    return InstrumentModel(
      instrumentId: json["instrument_id"],
      name: json["name"],
      code: json["code"],
      // decimalPlaces: json["decimal_places"],
      // tickSize: (json["tick_size"] ?? 0).toDouble(),
      // contractSize: json["contract_size"] ?? 0,
      // orderQtyStep: (json["order_qty_step"] ?? 0).toDouble(),
      // minOrderQty: (json["min_order_qty"] ?? 0).toDouble(),
      // maxOrderQty: (json["max_order_qty"] ?? 0).toDouble(),
    );
  }
}
