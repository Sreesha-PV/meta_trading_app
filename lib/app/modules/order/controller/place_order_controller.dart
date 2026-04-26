import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netdania/app/config/theme/app_color.dart';
import 'package:netdania/app/enum/ordertype_enum.dart';
import 'package:netdania/app/getX/account_getx.dart';
import 'package:netdania/app/getX/order_getX.dart';
import 'package:netdania/app/getX/position_getx.dart';
import 'package:netdania/app/getX/trading_getX.dart';
import 'package:netdania/app/getX/wallet_getX.dart';
import 'package:netdania/app/models/instrument_detail_model.dart';
import 'package:netdania/app/models/instrument_model.dart';
// import 'package:netdania/app/getX/user_getX.dart';
import 'package:netdania/app/models/order_model.dart';
import 'package:netdania/app/services/instrument_fetch_services.dart';
// import 'package:netdania/screens/services/notification_services.dart';
import 'package:netdania/app/services/order_services.dart';
import 'package:netdania/app/modules/main_tab/view/main_tab_view.dart';
import 'package:universal_html/js.dart';

/// ---------------- CONTROLLER ---------------- ///
class PlaceOrderController extends GetxController {
  final symbol = ''.obs;
  final currentBuyPrice = 0.0.obs;
  final currentSellPrice = 0.0.obs;
  final dotPosition = 5.obs;

  // final selectedOrderType = 'Market Execution'.obs;
  final selectedOrderType = 0.obs;
  // final selectedFillPolicy = 'Fill or Kill'.obs;
  final selectedFillPolicy = 'Fill or Kill'.obs;
  final selectedExpiration = 'GTC'.obs;
  var expirationDate = Rxn<DateTime>();
  final volume = 0.2.obs;
  final sl = 0.0.obs;
  final tp = 0.0.obs;
  final isEditingVolume = false.obs;
  final volumeTextController = TextEditingController();
  final FocusNode volumeFocusNode = FocusNode();
  // final expirationMonth = '01'.obs;
  // final expirationDay = '01'.obs;
  // final expirationYear = DateTime.now().year.toString().obs;
  // final expirationMinute = '00'.obs;
  // final expirationSecond = '00'.obs;

  final isSlInitialized = false.obs;
  final isTpInitialized = false.obs;

  final InstrumentService _instrumentService = InstrumentService();
  final instruments = <InstrumentModel>[].obs;
  final isLoadingInstruments = false.obs;
  final slController = TextEditingController();
  final tpController = TextEditingController();
  // final priceController = TextEditingController();

  // final selectedInstrumentDetails = <InstrumentDetailsModel>[].obs;
  
 final selectedInstrumentDetails = Rxn<InstrumentDetailsModel>();

  late TradingChartController tradingController;
  @override
  void onInit() {
    tradingController = Get.put(TradingChartController());

    ever<String>(symbol, (val) async {
      if (val.isEmpty) return;
      await setSymbol(val);
    });

    ever(symbol, (symbolName) {
      final ticker = tradingController.getTicker(symbolName);
      if (ticker != null) {
        dotPosition.value =
            int.tryParse(ticker['dot_position']?.toString() ?? '5') ?? 5;
        currentBuyPrice.value =
            double.tryParse(ticker['ask']?.toString() ?? '0') ?? 0;
        currentSellPrice.value =
            double.tryParse(ticker['bid']?.toString() ?? '0') ?? 0;
      }
    });
    ever(dotPosition, (pos) {
      if (isSlInitialized.value) {
        slController.text = sl.value.toStringAsFixed(pos);
      }
      if (isTpInitialized.value) {
        tpController.text = tp.value.toStringAsFixed(pos);
      }
      if (priceController.text.isNotEmpty) {
        priceController.text = price.value.toStringAsFixed(pos);
      }
    });

    ever(sl, (_) {
      if (!isSlInitialized.value) return;

      final text = sl.value.toStringAsFixed(dotPosition.value);
      if (slController.text != text) {
        slController.value = slController.value.copyWith(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
        );
      }
    });

    ever(tp, (_) {
      if (!isTpInitialized.value) return;

      final text = tp.value.toStringAsFixed(dotPosition.value);
      if (tpController.text != text) {
        tpController.value = tpController.value.copyWith(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
        );
      }
    });

    ever(selectedExpiration, (val) {
      if (val == 'GTC' || val == 'Today' || val == 'GTF') {
        expirationDate.value = null;
      }
    });

    super.onInit();
    volumeFocusNode.addListener(() {
      if (!volumeFocusNode.hasFocus) {
        final newVol = double.tryParse(volumeTextController.text);
        if (newVol != null && newVol >= 0.01) {
          volume.value = newVol;
        }
        isEditingVolume.value = false;
      }
    });
  }

Future<void> setSymbol(String newSymbol) async {
  // if (symbol.value == newSymbol) return;

  // symbol.value = newSymbol;
  if (symbol.value == newSymbol &&
      selectedInstrumentDetails.value != null) return;

  // Reset SL/TP
  sl.value = 0.0;
  tp.value = 0.0;
  slController.clear();
  tpController.clear();
  isSlInitialized.value = false;
  isTpInitialized.value = false;

  // Get ticker info
  final ticker = tradingController.getTicker(newSymbol);
  dotPosition.value =
      int.tryParse(ticker?['dot_position']?.toString() ?? '5') ?? 5;
  currentBuyPrice.value =
      double.tryParse(ticker?['ask']?.toString() ?? '0') ?? 0;
  currentSellPrice.value =
      double.tryParse(ticker?['bid']?.toString() ?? '0') ?? 0;

  // Get instrument
  final instrument = tradingController.getInstrumentByCode(newSymbol);
  if (instrument == null) {
    selectedInstrumentDetails.value = null;
    // Get.snackbar(
    //   'Error',
    //   'Instrument not found for $newSymbol',
    //   backgroundColor: AppColors.error,
    //   colorText: AppColors.background,
    // );
    return;
  }

  // Fetch instrument details
  final details = await _instrumentService.fetchInstrumentById(instrument.instrumentId);


  selectedInstrumentDetails.value = details;
}

  int getDotPositionForSymbol(String symbolName) {
    final ticker = tradingController.getTicker(symbolName);
    if (ticker != null && ticker['dot_position'] != null) {
      return int.tryParse(ticker['dot_position'].toString()) ?? 5;
    }
    return 5;
  }
  final priceController = TextEditingController();
  var price = 0.0.obs;

  void adjustPrice(double delta) {
    price.value = (price.value + delta).clamp(0, double.infinity);
    priceController.text = price.value.toStringAsFixed(5);
  }

  void syncTextWithPrice() {
    price.value = double.tryParse(priceController.text) ?? 0.0;
  }

  void changeVolume(double delta) {
    volume.value = (volume.value + delta).clamp(0.01, double.infinity);
  }

  /// ---------------- SL / TP ----------------
  void adjustSl(double delta) {
    final ticker = tradingController.getTicker(symbol.value);
    final sellPrice = double.tryParse(ticker?['bid']?.toString() ?? '0') ?? 0;

    if (!isSlInitialized.value) {
      sl.value = sellPrice;
      isSlInitialized.value = true;
    } else {
      sl.value = (sl.value + delta).clamp(0, double.infinity);
    }
  }

  void adjustTp(double delta) {
    final ticker = tradingController.getTicker(symbol.value);
    final buyPrice = double.tryParse(ticker?['ask']?.toString() ?? '0') ?? 0;

    if (!isTpInitialized.value) {
      tp.value = buyPrice;
      isTpInitialized.value = true;
    } else {
      tp.value = (tp.value + delta).clamp(0, double.infinity);
    }
  }


  String get expirationDisplayValue {
    final date = expirationDate.value;
    if (date == null) return selectedExpiration.value;

    if (selectedExpiration.value == 'Specified day') {
      return '${_two(date.day)}-${_two(date.month)}-${date.year}';
    }

    if (selectedExpiration.value == 'Specified') {
      return '${_two(date.day)}-${_two(date.month)}-${date.year} '
          '${_two(date.hour)}:${_two(date.minute)}';
    }

    return selectedExpiration.value;
  }


bool validateSlTp(bool isBuy) {
  final details = selectedInstrumentDetails.value;
  if (details == null) {
    print('inst details : $details');
    Get.snackbar(
      'Error',
      'Instrument details not loaded',
      backgroundColor: AppColors.error,
      colorText: AppColors.background(Get.context!),
    );
    return false;
  }



final tick = details.tickSize.abs();
final stopPips = details.stopMinPips.abs();
final limitPips = details.limitMinPips.abs();

final minStopDistance = tick * stopPips;
final minLimitDistance = tick * limitPips;

  // final currentAsk = currentBuyPrice.value;
  // final currentBid = currentSellPrice.value;

final ticker = tradingController.getTicker(symbol.value);

if (ticker == null) {
  Get.snackbar(
    'Error',
    'Market price not available',
    backgroundColor: AppColors.error,
    colorText: AppColors.background(Get.context!),
  );
  return false;
}

final currentAsk =
    double.tryParse(ticker['ask']?.toString() ?? '0') ?? 0;
final currentBid =
    double.tryParse(ticker['bid']?.toString() ?? '0') ?? 0;

if (currentAsk == 0 || currentBid == 0) {
  Get.snackbar(
    'Error',
    'Invalid market price',
    backgroundColor: AppColors.error,
    colorText: AppColors.background(Get.context!),
  );
  return false;
}
  final stopPrice = double.tryParse(slController.text) ?? 0;
  final limitPrice = double.tryParse(tpController.text) ?? 0;
if (isBuy) {
print('tickSize: ${details.tickSize}');
print('stopMinPips: ${details.stopMinPips}');
print('limitMinPips: ${details.limitMinPips}');

  final minAllowedSL = currentBid - minStopDistance;
  final minAllowedTP = currentAsk + minLimitDistance;
  print('sl validation : ${stopPrice}, SL must be at least $stopPips pips below market price (${minAllowedSL.toStringAsFixed(dotPosition.value)})' );

  if (stopPrice > 0 && stopPrice > minAllowedSL) {
    Get.snackbar(
      'Error',
      'SL must be below '
      '${minAllowedSL.toStringAsFixed(dotPosition.value)} '
      '($stopPips pips)',
      backgroundColor: AppColors.error,
      colorText: AppColors.background(Get.context!),
    );
    return false;
  }

  if (limitPrice > 0 && limitPrice < minAllowedTP) {
    Get.snackbar(
      'Error',
      'TP must be above '
      '${minAllowedTP.toStringAsFixed(dotPosition.value)} '
      '($limitPips pips)',
      backgroundColor: AppColors.error,
      colorText: AppColors.background(Get.context!),
    );
    return false;
  }
}
 else {
  final minAllowedSL = currentAsk + minStopDistance;

if (stopPrice > 0 && stopPrice < minAllowedSL) {
  Get.snackbar(
    'Error',
    'SL must be at least $stopPips pips above market price '
    '(${minAllowedSL.toStringAsFixed(dotPosition.value)})',
    backgroundColor: AppColors.error,
    colorText: AppColors.background(Get.context!),
  );
  return false;
}
  final minAllowedTP = currentBid - minLimitDistance;

if (limitPrice > 0 && limitPrice > minAllowedTP) {
  Get.snackbar(
    'Error',
    'TP must be at least $limitPips pips below market price '
    '(${minAllowedTP.toStringAsFixed(dotPosition.value)})',
    backgroundColor: AppColors.error,
    colorText: AppColors.background(Get.context!),
  );
  return false;
}
}
  return true;
}


// bool validateVolume() {
//   final details = selectedInstrumentDetails.value;
//   if (details == null) {
//     Get.snackbar('Error', 'Instrument details not loaded',
//         backgroundColor: AppColors.error, colorText: AppColors.background);
//     return false;
//   }

//   final minVolume = details.minOrderQty > 0 ? details.minOrderQty : 0.01;
//   final maxVolume = details.maxOrderQty > 0 ? details.maxOrderQty : double.infinity;

//   syncVolumeFromText(); // parse from TextController

//   if (volume.value < minVolume) {
//     Get.snackbar(
//       'Error',
//       'Volume must be at least $minVolume',
//       backgroundColor: AppColors.error,
//       colorText: AppColors.background,
//     );
//     return false;
//   }

//   if (volume.value > maxVolume) {
//     Get.snackbar(
//       'Error',
//       'Volume must be less than $maxVolume',
//       backgroundColor: AppColors.error,
//       colorText: AppColors.background,
//     );
//     return false;
//   }

//   return true;
// }

  String _two(int v) => v.toString().padLeft(2, '0');

  /// ---------------- ORDER TYPE ----------------
  OrderType mapDropdownToOrderType(String dropdownValue) {
    switch (dropdownValue) {
      case 'Market Execution':
        return OrderType.Market;
      case 'Buy Limit':
      case 'Sell Limit':
        return OrderType.Limit;
      case 'Buy Stop':
      case 'Sell Stop':
        return OrderType.Stop;
      default:
        return OrderType.Unknown;
    }
  }


  void syncVolumeFromText() {
  final parsed = double.tryParse(volumeTextController.text);
  if (parsed == null || parsed <= 0) {
    volume.value = 0.0;
    Get.snackbar(
      'Error',
      'Order quantity must be greater than 0',
      backgroundColor: AppColors.error,
      colorText: Colors.white,
    );
  } else {

    volume.value = double.parse(parsed.toStringAsFixed(2));
  }
}

  Future<void> placeOrder(bool isBuy, {bool navigateAway = true}) async {




    syncVolumeFromText();
    // if (volume.value <= 0) {
    //   Get.snackbar(
    //     'Error',
    //     'Volume must be greater than 0',
    //     backgroundColor: AppColors.error,
    //   );
    //   return;
    // }

    




    final accountController = Get.find<AccountController>();
    final walletController = Get.find<WalletController>();

    if (walletController.balance <= 0) {
      Get.snackbar(
        'X Error',
        'Insufficient margin to trade',
        backgroundColor: AppColors.error,
        colorText: AppColors.background(Get.context!),
      );
      return;
    }

    if (accountController.selectedAccountId.value <= 0) {
      Get.snackbar('Error', 'No account selected');
      return;
    }

    final accountId = accountController.selectedAccountId.value;

    print("Placing order for Type: ${selectedOrderType.value}");

    if (accountId == 0) {
      Get.snackbar('Error', 'No account selected');
      return;
    }

    await tradingController.subscribeToSymbols([symbol.value.toUpperCase()]);

    final instrument = tradingController.getInstrumentByCode(symbol.value);
    if (instrument == null) {
      Get.snackbar('Error', 'Instrument not found for ${symbol.value}');
      return;
    }
    final instrumentId = instrument.instrumentId;


// final instrumentDetails = selectedInstrumentDetails.value;

// if (instrumentDetails == null) {
//   Get.snackbar(
//     'Error',
//     'Instrument details not loaded',
//     backgroundColor: AppColors.error,
//     colorText: AppColors.background,
//   );
//   return;
// }



    final ticker = tradingController.tickers[symbol.value.toUpperCase()];

    final stopPrice = double.tryParse(slController.text) ?? 0.0;
    final limitPrice = double.tryParse(tpController.text) ?? 0.0;

    final typeSide = mapIntToTypeSide(selectedOrderType.value);
    final orderType = typeSide.type;
    int side = typeSide.side;
    double orderPrice;

    if (orderType == OrderType.Market) {
      side = isBuy ? 1 : 2;
      orderPrice =
          isBuy
              ? double.tryParse(ticker?['ask']?.toString() ?? '0') ?? 0
              : double.tryParse(ticker?['bid']?.toString() ?? '0') ?? 0;
    } else {
      orderPrice = double.tryParse(priceController.text) ?? 0;
      if (orderPrice <= 0) {
        Get.snackbar(
          'X Error',
          'Please enter a valid price for your order',
          backgroundColor: AppColors.error,
          colorText: AppColors.background(Get.context!),
        );
        return;
      }
    }
    final int timeInForceId =
        orderType == OrderType.Market
            ? mapFillPolicyToTIF(selectedFillPolicy.value)
            : mapExpirationToTIF(selectedExpiration.value);

    String? expiryDateTime;

    final tif = timeInForceId;
    final exp = expirationDate.value;

    if (tif == 3 || tif == 4) {
      if (exp == null) {
        Get.snackbar(
          'X Validation error',
          'Expiration date is required',
          backgroundColor: AppColors.error,
          colorText: AppColors.background(Get.context!),
        );
        return;
      }

      if (tif == 3) {
        expiryDateTime =
            DateTime(
              exp.year,
              exp.month,
              exp.day,
              23,
              59,
              59,
            ).toUtc().toIso8601String();
      } else {
        expiryDateTime = exp.toUtc().toIso8601String();
      }
    }

    print('TIF: $timeInForceId');
    print('expiryDateTime: $expiryDateTime');

    final currentAsk = double.tryParse(ticker?['ask']?.toString() ?? '0') ?? 0;
    final currentBid = double.tryParse(ticker?['bid']?.toString() ?? '0') ?? 0;

    //  final instrument = selectedInstrumentDetails.value;
  // if (instrument == null) return;
  if (!validateSlTp(isBuy)) return;

if (ticker == null) {
  Get.snackbar(
    'Error',
    'Market price not available',
    backgroundColor: AppColors.error,
    colorText: AppColors.background(Get.context!),
  );
  return;
}



    final order = OrderRequestModel(
      accountId: accountId,
      instrumentId: instrumentId,
      side: side,
      orderType: orderType.index,
      orderQty: volume.value,
      timeInForceId: timeInForceId,
      orderPrice: orderPrice,
      stopPrice: stopPrice,
      limitPrice: limitPrice,
      expiryDateTime: expiryDateTime,
    );

    final success = await OrderService.placeOrder(order);

    if (success) {
      final orderController = Get.find<OrderController>();
      orderController.addOrder(order);
      sl.value = 0.0;
      tp.value = 0.0;
      slController.clear();
      tpController.clear();
      isSlInitialized.value = false;
      isTpInitialized.value = false;

      Get.snackbar(
        'Success',
        'Order placed successfully',
        backgroundColor: AppColors.success,
        colorText: AppColors.background(Get.context!),
      );
      if (navigateAway) {
        Get.until((route) => route.isFirst);
        MainTabView.selectedIndexNotifier.value = 2;
      }
    } else {
      Get.snackbar(
        'X Error',
        'Order placement failed',
        backgroundColor: AppColors.error,
        colorText: AppColors.background(Get.context!),
      );
    }
  }

  void changeSymbol(InstrumentModel instrument) async{
    symbol.value = instrument.code;
    await setSymbol(instrument.code);
  }

  @override
  void onClose() {
    volumeFocusNode.dispose();
    slController.dispose();
    tpController.dispose();
    priceController.dispose();
    super.onClose();
  }

  int mapFillPolicyToTIF(String policy) {
    switch (policy) {
      case 'Fill or Kill':
        return 11;
      case 'Immediate or Cancel':
        return 12;
      default:
        return 11;
    }
  }

  int mapExpirationToTIF(String expiration) {
    switch (expiration) {
      case 'GTC':
        return 1;
      case 'GTF':
        return 2;
      case 'Today':
        return 5; // Day
      case 'Specified day':
        return 3; // GTD
      case 'Specified':
        return 4; // GTDT
      default:
        return 1;
    }
  }
}

class OrderTypeSide {
  final OrderType type;
  final int side; // 1 = Buy, 2 = Sell, 0 = Market/undefined
  OrderTypeSide(this.type, this.side);
}

OrderTypeSide mapIntToTypeSide(int code) {
  switch (code) {
    case 1:
      return OrderTypeSide(OrderType.Limit, 1); // Buy Limit
    case 2:
      return OrderTypeSide(OrderType.Limit, 2); // Sell Limit
    case 3:
      return OrderTypeSide(OrderType.Stop, 1); // Buy Stop
    case 4:
      return OrderTypeSide(OrderType.Stop, 2); // Sell Stop
    case 0:
      return OrderTypeSide(OrderType.Market, 0); // Market Execution
    default:
      return OrderTypeSide(OrderType.Unknown, 0); // Unknown
  }
}


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:netdania/app/config/theme/app_color.dart';
// import 'package:netdania/app/enum/ordertype_enum.dart';
// import 'package:netdania/app/getX/account_getx.dart';
// import 'package:netdania/app/getX/order_getX.dart';
// import 'package:netdania/app/getX/position_getx.dart';
// import 'package:netdania/app/getX/trading_getX.dart';
// import 'package:netdania/app/getX/wallet_getX.dart';
// import 'package:netdania/app/models/instrument_detail_model.dart';
// import 'package:netdania/app/models/instrument_model.dart';
// // import 'package:netdania/app/getX/user_getX.dart';
// import 'package:netdania/app/models/order_model.dart';
// import 'package:netdania/screens/services/instrument_fetch_services.dart';
// // import 'package:netdania/screens/services/notification_services.dart';
// import 'package:netdania/screens/services/order_services.dart';
// import 'package:netdania/app/modules/main_tab/view/main_tab_view.dart';

// /// ---------------- CONTROLLER ---------------- ///
// class PlaceOrderController extends GetxController {
//   final symbol = ''.obs;
//   final currentBuyPrice = 0.0.obs;
//   final currentSellPrice = 0.0.obs;
//   final dotPosition = 5.obs;

//   // final selectedOrderType = 'Market Execution'.obs;
//   final selectedOrderType = 0.obs;
//   // final selectedFillPolicy = 'Fill or Kill'.obs;
//   final selectedFillPolicy = 'Fill or Kill'.obs;
//   final selectedExpiration = 'GTC'.obs;
//   var expirationDate = Rxn<DateTime>();
//   final volume = 0.2.obs;
//   final sl = 0.0.obs;
//   final tp = 0.0.obs;
//   final isEditingVolume = false.obs;
//   final volumeTextController = TextEditingController();
//   final FocusNode volumeFocusNode = FocusNode();
//   // final expirationMonth = '01'.obs;
//   // final expirationDay = '01'.obs;
//   // final expirationYear = DateTime.now().year.toString().obs;
//   // final expirationMinute = '00'.obs;
//   // final expirationSecond = '00'.obs;

//   final isSlInitialized = false.obs;
//   final isTpInitialized = false.obs;

//   final InstrumentService _instrumentService = InstrumentService();
//   final instruments = <InstrumentModel>[].obs;
//   final isLoadingInstruments = false.obs;
//   final slController = TextEditingController();
//   final tpController = TextEditingController();
//   // final priceController = TextEditingController();

//   // final instDetails = <InstrumentDetailsModel>[].obs;
  
//  final selectedInstrumentDetails = Rxn<InstrumentDetailsModel>();

//   late TradingChartController tradingController;
//   @override
//   void onInit() {
//     tradingController = Get.put(TradingChartController());

//     ever(symbol, (symbolName) {
//       final ticker = tradingController.getTicker(symbolName);
//       if (ticker != null) {
//         dotPosition.value =
//             int.tryParse(ticker['dot_position']?.toString() ?? '5') ?? 5;
//         currentBuyPrice.value =
//             double.tryParse(ticker['ask']?.toString() ?? '0') ?? 0;
//         currentSellPrice.value =
//             double.tryParse(ticker['bid']?.toString() ?? '0') ?? 0;
//       }
//     });

//     ever(dotPosition, (pos) {
//       if (isSlInitialized.value) {
//         slController.text = sl.value.toStringAsFixed(pos);
//       }
//       if (isTpInitialized.value) {
//         tpController.text = tp.value.toStringAsFixed(pos);
//       }
//       if (priceController.text.isNotEmpty) {
//         priceController.text = price.value.toStringAsFixed(pos);
//       }
//     });

//     ever(sl, (_) {
//       if (!isSlInitialized.value) return;

//       final text = sl.value.toStringAsFixed(5);
//       if (slController.text != text) {
//         slController.value = slController.value.copyWith(
//           text: text,
//           selection: TextSelection.collapsed(offset: text.length),
//         );
//       }
//     });

//     ever(tp, (_) {
//       if (!isTpInitialized.value) return;

//       final text = tp.value.toStringAsFixed(5);
//       if (tpController.text != text) {
//         tpController.value = tpController.value.copyWith(
//           text: text,
//           selection: TextSelection.collapsed(offset: text.length),
//         );
//       }
//     });

//     ever(selectedExpiration, (val) {
//       if (val == 'GTC' || val == 'Today') {
//         expirationDate.value = null;
//       }
//     });

//     super.onInit();
//     volumeFocusNode.addListener(() {
//       if (!volumeFocusNode.hasFocus) {
//         final newVol = double.tryParse(volumeTextController.text);
//         if (newVol != null && newVol >= 0.01) {
//           volume.value = newVol;
//         }
//         isEditingVolume.value = false;
//       }
//     });
//   }



//   void setSymbol(String newSymbol) {
//     if (symbol.value != newSymbol) {
//       symbol.value = newSymbol;
//       final ticker = tradingController.getTicker(newSymbol);

//       dotPosition.value =
//           int.tryParse(ticker?['dot_position']?.toString() ?? '5') ?? 5;
//       sl.value = 0.0;
//       tp.value = 0.0;
//       slController.clear();
//       tpController.clear();
//       isSlInitialized.value = false;
//       isTpInitialized.value = false;

//       currentBuyPrice.value =
//           double.tryParse(ticker?['ask']?.toString() ?? '0') ?? 0;
//       currentSellPrice.value =
//           double.tryParse(ticker?['bid']?.toString() ?? '0') ?? 0;
//     }
//   }

//   int getDotPositionForSymbol(String symbolName) {
//     final ticker = tradingController.getTicker(symbolName);
//     if (ticker != null && ticker['dot_position'] != null) {
//       return int.tryParse(ticker['dot_position'].toString()) ?? 5;
//     }
//     return 5;
//   }

//   // void setSL(double value) {
//   //   sl.value = value;
//   //   slController.text = value.toStringAsFixed(5);
//   // }

//   // void setTP(double value) {
//   //   tp.value = value;
//   //   tpController.text = value.toStringAsFixed(5);
//   // }

//   // void adjustPrice(double delta) {
//   //   priceController.text = (double.tryParse(priceController.text) ?? 0 + delta)
//   //       .clamp(0, double.infinity)
//   //       .toStringAsFixed(5);
//   // }

//   final priceController = TextEditingController();
//   var price = 0.0.obs;

//   void adjustPrice(double delta) {
//     price.value = (price.value + delta).clamp(0, double.infinity);
//     priceController.text = price.value.toStringAsFixed(5);
//   }

//   void syncTextWithPrice() {
//     price.value = double.tryParse(priceController.text) ?? 0.0;
//   }

//   void changeVolume(double delta) {
//     volume.value = (volume.value + delta).clamp(0.01, double.infinity);
//   }

//   /// ---------------- SL / TP ----------------
//   void adjustSl(double delta) {
//     final ticker = tradingController.getTicker(symbol.value);
//     final sellPrice = double.tryParse(ticker?['bid']?.toString() ?? '0') ?? 0;

//     if (!isSlInitialized.value) {
//       sl.value = sellPrice;
//       isSlInitialized.value = true;
//     } else {
//       sl.value = (sl.value + delta).clamp(0, double.infinity);
//     }
//   }

//   void adjustTp(double delta) {
//     final ticker = tradingController.getTicker(symbol.value);
//     final buyPrice = double.tryParse(ticker?['ask']?.toString() ?? '0') ?? 0;

//     if (!isTpInitialized.value) {
//       tp.value = buyPrice;
//       isTpInitialized.value = true;
//     } else {
//       tp.value = (tp.value + delta).clamp(0, double.infinity);
//     }
//   }


//   String get expirationDisplayValue {
//     final date = expirationDate.value;
//     if (date == null) return selectedExpiration.value;

//     if (selectedExpiration.value == 'Specified day') {
//       return '${_two(date.day)}-${_two(date.month)}-${date.year}';
//     }

//     if (selectedExpiration.value == 'Specified') {
//       return '${_two(date.day)}-${_two(date.month)}-${date.year} '
//           '${_two(date.hour)}:${_two(date.minute)}';
//     }

//     return selectedExpiration.value;
//   }


// double getPipValue(InstrumentDetailsModel instrumentDetails) {
//   final tickSize = instrumentDetails.tickSize ?? 0.0;
//   final point = instrumentDetails.point ?? 10;

//   if (tickSize == 0) return 0;

//   if (point > 0) {
//     return tickSize * point;
//   }

//   return tickSize * 10;
// }



//   String _two(int v) => v.toString().padLeft(2, '0');

//   /// ---------------- ORDER TYPE ----------------
//   OrderType mapDropdownToOrderType(String dropdownValue) {
//     switch (dropdownValue) {
//       case 'Market Execution':
//         return OrderType.Market;
//       case 'Buy Limit':
//       case 'Sell Limit':
//         return OrderType.Limit;
//       case 'Buy Stop':
//       case 'Sell Stop':
//         return OrderType.Stop;
//       default:
//         return OrderType.Unknown;
//     }
//   }


//   void syncVolumeFromText() {
//   final parsed = double.tryParse(volumeTextController.text);
//   if (parsed == null || parsed <= 0) {
//     volume.value = 0.0;
//     Get.snackbar(
//       'Error',
//       'Volume must be greater than 0',
//       backgroundColor: AppColors.error,
//       colorText: Colors.white,
//     );
//   } else {

//     volume.value = double.parse(parsed.toStringAsFixed(2));
//   }
// }

//   Future<void> placeOrder(bool isBuy, {bool navigateAway = true}) async {





//     syncVolumeFromText();
//     // if (volume.value <= 0) {
//     //   Get.snackbar(
//     //     'Error',
//     //     'Volume must be greater than 0',
//     //     backgroundColor: AppColors.error,
//     //   );
//     //   return;
//     // }

    




//     final accountController = Get.find<AccountController>();
//     final walletController = Get.find<WalletController>();

//     if (walletController.balance <= 0) {
//       Get.snackbar(
//         'X Error',
//         'Insufficient margin to trade',
//         backgroundColor: AppColors.error,
//         colorText: AppColors.background,
//       );
//       return;
//     }

//     if (accountController.selectedAccountId.value <= 0) {
//       Get.snackbar('Error', 'No account selected');
//       return;
//     }

//     final accountId = accountController.selectedAccountId.value;

//     print("Placing order for Type: ${selectedOrderType.value}");

//     if (accountId == 0) {
//       Get.snackbar('Error', 'No account selected');
//       return;
//     }

//     await tradingController.subscribeToSymbols([symbol.value.toUpperCase()]);

//     final instrument = tradingController.getInstrumentByCode(symbol.value);
//     if (instrument == null) {
//       Get.snackbar('Error', 'Instrument not found for ${symbol.value}');
//       return;
//     }
//     final instrumentId = instrument.instrumentId;


// // final instrumentDetails = selectedInstrumentDetails.value;

// // if (instrumentDetails == null) {
// //   Get.snackbar(
// //     'Error',
// //     'Instrument details not loaded',
// //     backgroundColor: AppColors.error,
// //     colorText: AppColors.background,
// //   );
// //   return;
// // }



//     final ticker = tradingController.tickers[symbol.value.toUpperCase()];

//     final stopPrice = double.tryParse(slController.text) ?? 0.0;
//     final limitPrice = double.tryParse(tpController.text) ?? 0.0;

//     final typeSide = mapIntToTypeSide(selectedOrderType.value);
//     final orderType = typeSide.type;
//     int side = typeSide.side;
//     double orderPrice;

//     if (orderType == OrderType.Market) {
//       side = isBuy ? 1 : 2;
//       orderPrice =
//           isBuy
//               ? double.tryParse(ticker?['ask']?.toString() ?? '0') ?? 0
//               : double.tryParse(ticker?['bid']?.toString() ?? '0') ?? 0;
//     } else {
//       orderPrice = double.tryParse(priceController.text) ?? 0;
//       if (orderPrice <= 0) {
//         Get.snackbar(
//           'X Error',
//           'Please enter a valid price for your order',
//           backgroundColor: AppColors.error,
//           colorText: AppColors.background,
//         );
//         return;
//       }
//     }
//     final int timeInForceId =
//         orderType == OrderType.Market
//             ? mapFillPolicyToTIF(selectedFillPolicy.value)
//             : mapExpirationToTIF(selectedExpiration.value);

//     String? expiryDateTime;

//     final tif = timeInForceId;
//     final exp = expirationDate.value;

//     if (tif == 3 || tif == 4) {
//       if (exp == null) {
//         Get.snackbar(
//           'X Validation error',
//           'Expiration date is required',
//           backgroundColor: AppColors.error,
//           colorText: AppColors.background,
//         );
//         return;
//       }

//       if (tif == 3) {
//         expiryDateTime =
//             DateTime(
//               exp.year,
//               exp.month,
//               exp.day,
//               23,
//               59,
//               59,
//             ).toUtc().toIso8601String();
//       } else {
//         expiryDateTime = exp.toUtc().toIso8601String();
//       }
//     }

//     print('TIF: $timeInForceId');
//     print('expiryDateTime: $expiryDateTime');

//     final currentAsk = double.tryParse(ticker?['ask']?.toString() ?? '0') ?? 0;
//     final currentBid = double.tryParse(ticker?['bid']?.toString() ?? '0') ?? 0;

//     if (isBuy) {
//       if (stopPrice > 0 && stopPrice >= currentBid) {
//         Get.snackbar(
//           'X Error',
//           'SL must be below market price',
//           backgroundColor: AppColors.error,
//           colorText: AppColors.background,
//         );
//         return;
//       }
//       if (limitPrice > 0 && limitPrice <= currentAsk) {
//         Get.snackbar(
//           'X Error',
//           'TP must be above market price',
//           backgroundColor: AppColors.error,
//           colorText: AppColors.background,
//         );
//         return;
//       }
//     }

//      else {
//       if (stopPrice > 0 && stopPrice <= currentAsk) {
//         Get.snackbar(
//           'X Error',
//           'SL must be above market price',
//           backgroundColor: AppColors.error,
//           colorText: AppColors.background,
//         );
//         return;
//       }
//       if (limitPrice > 0 && limitPrice >= currentBid) {
//         Get.snackbar(
//           'X Error',
//           'TP must be below market price',
//           backgroundColor: AppColors.error,
//           colorText: AppColors.background,
//         );
//         return;
//       }
//     }



//     final order = OrderRequestModel(
//       accountId: accountId,
//       // accountUuid: accountController.selectedAccountUuid.value,
//       instrumentId: instrumentId, // ⬅️ Dynamic
//       side: side,
//       orderType: orderType.index,
//       orderQty: volume.value,
//       // timeInForceId: selectedFillPolicy.value == 'Fill or Kill' ? 1 : 2,
//       timeInForceId: timeInForceId,
//       orderPrice: orderPrice,
//       stopPrice: stopPrice,
//       limitPrice: limitPrice,
//       // expiryDateTime: expiryDateTime
//       expiryDateTime: expiryDateTime,
//       // expiryDateTime: null
//     );

//     final success = await OrderService.placeOrder(order);

//     if (success) {
//       final orderController = Get.find<OrderController>();
//       orderController.addOrder(order);
//       sl.value = 0.0;
//       tp.value = 0.0;
//       slController.clear();
//       tpController.clear();
//       isSlInitialized.value = false;
//       isTpInitialized.value = false;

//       Get.snackbar(
//         'Success',
//         'Order placed successfully',
//         backgroundColor: AppColors.success,
//         colorText: AppColors.background,
//       );
//       if (navigateAway) {
//         Get.until((route) => route.isFirst);
//         MainTabView.selectedIndexNotifier.value = 2;
//       }
//     } else {
//       Get.snackbar(
//         'X Error',
//         'Order placement failed',
//         backgroundColor: AppColors.error,
//         colorText: AppColors.background,
//       );
//     }
//   }

//   void changeSymbol(InstrumentModel instrument) {
//     symbol.value = instrument.code;
//   }

//   @override
//   void onClose() {
//     volumeFocusNode.dispose();
//     slController.dispose();
//     tpController.dispose();
//     priceController.dispose();
//     super.onClose();
//   }
//   int mapFillPolicyToTIF(String policy) {
//     switch (policy) {
//       case 'Fill or Kill':
//         return 11;
//       case 'Immediate or Cancel':
//         return 12;
//       default:
//         return 11;
//     }
//   }

//   int mapExpirationToTIF(String expiration) {
//     switch (expiration) {
//       case 'GTC':
//         return 1;
//       case 'Today':
//         return 5; // Day
//       case 'Specified day':
//         return 3; // GTD
//       case 'Specified':
//         return 4; // GTDT
//       default:
//         return 1;
//     }
//   }
// }

// class OrderTypeSide {
//   final OrderType type;
//   final int side; // 1 = Buy, 2 = Sell, 0 = Market/undefined
//   OrderTypeSide(this.type, this.side);
// }

// OrderTypeSide mapIntToTypeSide(int code) {
//   switch (code) {
//     case 1:
//       return OrderTypeSide(OrderType.Limit, 1); // Buy Limit
//     case 2:
//       return OrderTypeSide(OrderType.Limit, 2); // Sell Limit
//     case 3:
//       return OrderTypeSide(OrderType.Stop, 1); // Buy Stop
//     case 4:
//       return OrderTypeSide(OrderType.Stop, 2); // Sell Stop
//     case 0:
//       return OrderTypeSide(OrderType.Market, 0); // Market Execution
//     default:
//       return OrderTypeSide(OrderType.Unknown, 0); // Unknown
//   }
// }







