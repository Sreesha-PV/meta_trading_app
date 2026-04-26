// class InstrumentDetailsModel {
//   final int? instrumentId;
//   final String name;
//   final String code;
//   final int currencyId;
//   final bool enabled;
//   final int instrumentTypeId;
//   final int autoExecutionModeId;
//   final double autoExecutionTolerance;
//   final double tickSize;
//   final int point;
//   final int decimalPlaces;
//   final String? isin;
//   final String? monthCode;
//   final double contractSize;
//   final int unitId;
//   final int tradingStatusId;
//   final bool isAvailableForWatchList;
//   final bool isAvailableForTrading;
//   final int chartModeId;
//   final int marketId;
//   final String? exchangeName;
//   final int? underlyingInstrumentId;
//   final int? maxUpdateFrequency;
//   final int smoothingTicks;
//   final int ignoreWrongTickCount;
//   final double cutOffLimitPercentCp;
//   final String? fnd;
//   final String? ltd;
//   final String? creationDate;
//   final double? circuitLimit;
//   final double orderQtyStep;
//   final double maxOrderQty;
//   final double minOrderQty;
//   final double spreadBid;
//   final double spreadAsk;
//   final int spreadTypeId;
//   final double buyInterestRate;
//   final double sellInterestRate;
//   final int limitMinPips;
//   final int stopMinPips;
//   final bool allowShortSelling;
//   final double initialMargin;
//   final double limitOrderMargin;
//   final double liquidationMargin;
//   final double intradayOrderMargin;
//   final double btstOrderMargin;
//   final double overnightMargin;
//   final int marginCalcModeId;
//   final int plCalcModeId;
//   final double commission;
//   final int tradeRouteId;
//   final int defaultRouteId;
//   final String sourceCode;
//   final int calcModeId;
//   final int currentTradeSessionSettingId;
//   final int hedgeModeId;
//   final String lastUpdateTime;
//   final bool? isAvailableForRollover;
//   final bool? isStorageDisabled;
//   final bool? isNotAvailableForMarginOverride;
//   final double? minMarginLeverageLimit;
//   final double? rolloverPip;
//   final int? availableOrderTypes;
//   final int? highlightColor;  // Changed from String? to int?
//   final int? maxHoldingDays;
//   final int? maxSpreadLimit;
//   final String? settlementTimeframe;
//   final String? orderSettings;
//   final String? description;
//   final double? priceTick;
//   final int lsDigitLength;
//   final int msDigitLength;
//   final double? circuitLimitUp;
//   final double? circuitLimitDown;
//   final double? initialSellMargin;
//   final String? iconResource;
//   final int priceUnitId;
//   final double? priceUnitValue;
//   final String? extraInfo;
//   final bool? isLockedForDp;
//   final String? orderSettings2;
//   final int? quoteCurrencyId;  
//   final int? quoteCurrencyInstrumentId;  

//   InstrumentDetailsModel({
//     required this.instrumentId,
//     required this.name,
//     required this.code,
//     required this.currencyId,
//     required this.enabled,
//     required this.instrumentTypeId,
//     required this.autoExecutionModeId,
//     required this.autoExecutionTolerance,
//     required this.tickSize,
//     required this.point,
//     required this.decimalPlaces,
//     this.isin,
//     this.monthCode,
//     required this.contractSize,
//     required this.unitId,
//     required this.tradingStatusId,
//     required this.isAvailableForWatchList,
//     required this.isAvailableForTrading,
//     required this.chartModeId,
//     required this.marketId,
//     this.exchangeName,
//     this.underlyingInstrumentId,
//     this.maxUpdateFrequency,
//     required this.smoothingTicks,
//     required this.ignoreWrongTickCount,
//     required this.cutOffLimitPercentCp,
//     this.fnd,
//     this.ltd,
//     this.creationDate,
//     this.circuitLimit,
//     required this.orderQtyStep,
//     required this.maxOrderQty,
//     required this.minOrderQty,
//     required this.spreadBid,
//     required this.spreadAsk,
//     required this.spreadTypeId,
//     required this.buyInterestRate,
//     required this.sellInterestRate,
//     required this.limitMinPips,
//     required this.stopMinPips,
//     required this.allowShortSelling,
//     required this.initialMargin,
//     required this.limitOrderMargin,
//     required this.liquidationMargin,
//     required this.intradayOrderMargin,
//     required this.btstOrderMargin,
//     required this.overnightMargin,
//     required this.marginCalcModeId,
//     required this.plCalcModeId,
//     required this.commission,
//     required this.tradeRouteId,
//     required this.defaultRouteId,
//     required this.sourceCode,
//     required this.calcModeId,
//     required this.currentTradeSessionSettingId,
//     required this.hedgeModeId,
//     required this.lastUpdateTime,
//     this.isAvailableForRollover,
//     this.isStorageDisabled,
//     this.isNotAvailableForMarginOverride,
//     this.minMarginLeverageLimit,
//     this.rolloverPip,
//     this.availableOrderTypes,
//     this.highlightColor,
//     this.maxHoldingDays,
//     this.maxSpreadLimit,
//     this.settlementTimeframe,
//     this.orderSettings,
//     this.description,
//     this.priceTick,
//     required this.lsDigitLength,
//     required this.msDigitLength,
//     this.circuitLimitUp,
//     this.circuitLimitDown,
//     this.initialSellMargin,
//     this.iconResource,
//     required this.priceUnitId,
//     this.priceUnitValue,
//     this.extraInfo,
//     this.isLockedForDp,
//     this.orderSettings2,
//     this.quoteCurrencyId,
//     this.quoteCurrencyInstrumentId,
//   });

//   factory InstrumentDetailsModel.fromJson(Map<String, dynamic> json) {
//     return InstrumentDetailsModel(
//       instrumentId: json['instrument_id'],
//       name: json['name'],
//       code: json['code'],
//       currencyId: json['base_currency_id'] ?? 0,
//       enabled: json['enabled'] ?? false,
//       instrumentTypeId: json['instrument_type_id']??0,
//       autoExecutionModeId: json['auto_execution_mode_id'] ??0,
//       autoExecutionTolerance: (json['auto_execution_tolerance'] ?? 0).toDouble(),
//       tickSize: (json['tick_size'] ?? 0).toDouble(),
//       point: json['point']?? 0,
//       decimalPlaces: json['decimal_places']?? 0,
//       isin: json['isin'],
//       monthCode: json['month_code'],
//       contractSize: (json['contract_size'] ?? 0).toDouble(),
//       unitId: json['unit_id'] ?? 0,
//       tradingStatusId: json['trading_status_id'],
//       isAvailableForWatchList: json['is_available_for_watch_list'],
//       isAvailableForTrading: json['is_available_for_trading'],
//       chartModeId: json['chart_mode_id']?? 0,
//       marketId: json['market_id']??0,
//       exchangeName: json['exchange_name'],
//       underlyingInstrumentId: json['underlying_instrument_id'],
//       maxUpdateFrequency: json['max_update_frequency'],
//       smoothingTicks: json['smoothing_ticks']??0,
//       ignoreWrongTickCount: json['ignore_wrong_tick_count']??0,
//       cutOffLimitPercentCp: (json['cut_off_limit_percent_cp'] ?? 0).toDouble(),
//       fnd: json['fnd'],
//       ltd: json['ltd'],
//       creationDate: json['creation_date'],
//       circuitLimit: (json['circuit_limit'] != null) ? json['circuit_limit'].toDouble() : null,
//       orderQtyStep: (json['order_qty_step'] ?? 0).toDouble(),
//       maxOrderQty: (json['max_order_qty'] ?? 0).toDouble(),
//       minOrderQty: (json['min_order_qty'] ?? 0).toDouble(),
//       spreadBid: (json['spread_bid'] ?? 0).toDouble(),
//       spreadAsk: (json['spread_ask'] ?? 0).toDouble(),
//       spreadTypeId: json['spread_type_id']?? 0,
//       buyInterestRate: (json['buy_interest_rate'] ?? 0).toDouble(),
//       sellInterestRate: (json['sell_interest_rate'] ?? 0).toDouble(),
//       limitMinPips: json['limit_min_pips']??0,
//       stopMinPips: json['stop_min_pips']??0,
//       allowShortSelling: json['allow_short_selling'] ?? false,
//       initialMargin: (json['initial_margin'] ?? 0).toDouble(),
//       limitOrderMargin: (json['limit_order_margin'] ?? 0).toDouble(),
//       liquidationMargin: (json['liquidation_margin'] ?? 0).toDouble(),
//       intradayOrderMargin: (json['intraday_order_margin'] ?? 0).toDouble(),
//       btstOrderMargin: (json['btst_order_margin'] ?? 0).toDouble(),
//       overnightMargin: (json['overnight_margin'] ?? 0).toDouble(),
//       marginCalcModeId: json['margin_calc_mode_id']?? 0,
//       plCalcModeId: json['pl_calc_mode_id']?? 0,
//       commission: (json['commission'] ?? 0).toDouble(),
//       tradeRouteId: json['trade_route_id']??0,
//       defaultRouteId: json['default_route_id']??0,
//       sourceCode: json['source_code'],
//       calcModeId: json['calc_mode_id']?? 0,
//       currentTradeSessionSettingId: json['current_trade_session_setting_id']??0,
//       hedgeModeId: json['hedge_mode_id']??0,
//       lastUpdateTime: json['last_update_time'],
//       isAvailableForRollover: json['is_available_for_rollover'],
//       isStorageDisabled: json['is_storage_disabled'],
//       isNotAvailableForMarginOverride: json['is_not_available_for_margin_override'],
//       minMarginLeverageLimit: (json['min_margin_leverage_limit'] != null) ? json['min_margin_leverage_limit'].toDouble() : null,
//       rolloverPip: (json['rollover_pip'] != null) ? json['rollover_pip'].toDouble() : null,
//       availableOrderTypes: json['available_order_types'] as int?,
//       highlightColor: json['highlight_color'] as int?,  // Changed to int
//       maxHoldingDays: json['max_holding_days'],
//       maxSpreadLimit: json['max_spread_limit'],
//       settlementTimeframe: json['settlement_timeframe'],
//       orderSettings: json['order_settings'],
//       description: json['description'],
//       priceTick: (json['price_tick'] != null) ? json['price_tick'].toDouble() : null,
//       lsDigitLength: json['ls_digit_length']?? 0,
//       msDigitLength: json['ms_digit_length']?? 0,
//       circuitLimitUp: (json['circuit_limit_up'] != null) ? json['circuit_limit_up'].toDouble() : null,
//       circuitLimitDown: (json['circuit_limit_down'] != null) ? json['circuit_limit_down'].toDouble() : null,
//       initialSellMargin: (json['initial_sell_margin'] != null) ? json['initial_sell_margin'].toDouble() : null,
//       iconResource: json['icon_resource'],
//       priceUnitId: json['price_unit_id']?? 0,
//       priceUnitValue: (json['price_unit_value'] != null) ? json['price_unit_value'].toDouble() : null,
//       extraInfo: json['extra_info'],
//       isLockedForDp: json['is_locked_for_dp'],
//       orderSettings2: json['order_settings2'],
//       quoteCurrencyId: json['quote_currency_id'] as int?,
//       quoteCurrencyInstrumentId: json['quote_currency_instrument_id'] as int?,
//     );
//   }
// }









class InstrumentDetailsModel {
  final int? instrumentId;
  final String name;
  final String code;
  final int currencyId;
  final bool enabled;
  final int instrumentTypeId;

  final double tickSize;
  final int point;
  final int decimalPlaces;

  final double contractSize;
  final int tradingStatusId;

  final bool isAvailableForWatchList;
  final bool isAvailableForTrading;
  final String? firstNoticeDay;
  final String? lastNoticeDay;
  final int marketId;

  final double orderQtyStep;
  final double maxOrderQty;
  final double minOrderQty;

  final double buyInterestRate;
  final double sellInterestRate;
  final int limitMinPips;
  final int stopMinPips;
  final bool allowShortSelling;
 
  final double liquidationMargin;

  final int plCalcModeId;
  final int marginCalcType;
  final int marginCalcFormulaId;
  final int currentTradeSessionSettingId;
  final int hedgeModeId;
  
  final int? availableOrderTypes;
  final int? highlightColor;  // Changed from String? to int?
 
  final int lsDigitLength;
  final int msDigitLength;

  final String? iconResource;

  final int? quoteCurrencyId;  
  final int? quoteCurrencyInstrumentId;  

  InstrumentDetailsModel({
    required this.instrumentId,
    required this.name,
    required this.code,
    required this.currencyId,
    required this.enabled,
    required this.instrumentTypeId,
    required this.tickSize,
    required this.point,
    required this.decimalPlaces,
  
    required this.contractSize,
    required this.tradingStatusId,
    required this.isAvailableForWatchList,
    required this.isAvailableForTrading,
    required this.firstNoticeDay,
    required this.lastNoticeDay,

    required this.marketId,
  
    required this.orderQtyStep,
    required this.maxOrderQty,
    required this.minOrderQty,


    required this.buyInterestRate,
    required this.sellInterestRate,
    required this.limitMinPips,
    required this.stopMinPips,
    required this.allowShortSelling,
    
    required this.liquidationMargin,

    required this.plCalcModeId,
    required this.marginCalcType,
    required this.marginCalcFormulaId,

    required this.currentTradeSessionSettingId,
    required this.hedgeModeId,
   
    this.availableOrderTypes,
    this.highlightColor,

    required this.lsDigitLength,
    required this.msDigitLength,

    this.iconResource,
 
    this.quoteCurrencyId,
    this.quoteCurrencyInstrumentId,
  });

  factory InstrumentDetailsModel.fromJson(Map<String, dynamic> json) {
    return InstrumentDetailsModel(
      instrumentId: json['instrument_id'],
      name: json['name'],
      code: json['code'],
      currencyId: json['base_currency_id'] ?? 0,
      enabled: json['enabled'] ?? false,
      instrumentTypeId: json['instrument_type_id']??0,

      tickSize: (json['tick_size'] ?? 0).toDouble(),
      point: json['point']?? 0,
      decimalPlaces: json['decimal_places']?? 0,

      contractSize: (json['contract_size'] ?? 0).toDouble(),

      tradingStatusId: json['trading_status_id']??0,
      isAvailableForWatchList: json['is_available_for_watch_list'],
      isAvailableForTrading: json['is_available_for_trading'],
      firstNoticeDay : json['first_notice_day'],
      lastNoticeDay : json['last_notice_dat'],
      marketId: json['market_id']??0,

      orderQtyStep: (json['order_qty_step'] ?? 0).toDouble(),
      maxOrderQty: (json['max_order_qty'] ?? 0).toDouble(),
      minOrderQty: (json['min_order_qty'] ?? 0).toDouble(),
    
      buyInterestRate: (json['buy_interest_rate'] ?? 0).toDouble(),
      sellInterestRate: (json['sell_interest_rate'] ?? 0).toDouble(),
      limitMinPips: json['limit_min_pips']??0,
      stopMinPips: json['stop_min_pips']??0,
      allowShortSelling: json['allow_short_selling'] ?? false,

      liquidationMargin: (json['liquidation_margin'] ?? 0).toDouble(),

      plCalcModeId: json['pl_calc_mode_id']?? 0,
      
      marginCalcType : json['margin_calc_type']?? 0,
      marginCalcFormulaId : json['margin_cal_formula_id']?? 0,


      currentTradeSessionSettingId: json['current_trade_session_setting_id']??0,
      hedgeModeId: json['hedge_mode_id']??0,
      
      availableOrderTypes: json['available_order_types'] as int?,
      highlightColor: json['highlight_color'] as int?,  // Changed to int


      lsDigitLength: json['ls_digit_length']?? 0,
      msDigitLength: json['ms_digit_length']?? 0,
      iconResource: json['icon_resource'],

      quoteCurrencyId: json['quote_currency_id'] as int?,
      quoteCurrencyInstrumentId: json['quote_currency_instrument_id'] as int?,
    );
  }
}
