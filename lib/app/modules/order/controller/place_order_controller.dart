// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:netdania/app/getX/trading_getX.dart';
// import 'package:netdania/app/models/order_model.dart';
// import 'package:netdania/screens/services/order_services.dart';

// /// ---------------- CONTROLLER ---------------- ///
// class PlaceOrderController extends GetxController {
//   final symbol = ''.obs;
//   final currentBuyPrice = 0.0.obs;
//   final currentSellPrice = 0.0.obs;

//   final selectedOrderType = 'Buy Limit'.obs;
//   final selectedFillPolicy = 'Fill or Kill'.obs;
//   final volume = 0.2.obs;
//   final sl = 0.0.obs;
//   final tp = 0.0.obs;

//   final Map<String, String> slValues = {};
//   final Map<String, String> tpValues = {};
//   final isSlInitialized = false.obs;
//   final isTpInitialized = false.obs;

//   final slController = TextEditingController();
//   final tpController = TextEditingController();

//   late TradingChartController tradingController;

//  final RxList<Map<String, dynamic>> liveData = <Map<String, dynamic>>[].obs;

//   @override
//   void onInit() {
//     tradingController = Get.find<TradingChartController>();
//     super.onInit();
//   }

//   void changeVolume(double delta) {
//     volume.value = (volume.value + delta).clamp(0.01, double.infinity);
//   }

// //   void setSymbol(String newSymbol) {
// //   symbol.value = newSymbol;

// //   // Reset SL/TP
// //   isSlInitialized.value = false;
// //   isTpInitialized.value = false;

// //   sl.value = 0.0;
// //   tp.value = 0.0;

// //   slController.text = '';
// //   tpController.text = '';
// // }

// void setSymbol(String newSymbol) {
//   // Only reset when symbol actually changes
//   if (symbol.value != newSymbol) {
//     symbol.value = newSymbol;

//     // Reset SL/TP values
//     isSlInitialized.value = false;
//     isTpInitialized.value = false;
//     sl.value = 0.0;
//     tp.value = 0.0;
//     slController.text = '';
//     tpController.text = '';

//     // Optionally, update current buy/sell price for the new symbol
//     final ticker = tradingController.getTicker(newSymbol);
//     currentBuyPrice.value = double.tryParse(ticker?['ask']?.toString() ?? '0') ?? 0.0;
//     currentSellPrice.value = double.tryParse(ticker?['bid']?.toString() ?? '0') ?? 0.0;
//   }
// }

//   void adjustSl(double delta) {
//     final ticker = tradingController.getTicker(symbol.value);
//     final sellPrice = double.tryParse(ticker?['bid']?.toString() ?? '0') ?? 0.0;

//     if (!isSlInitialized.value) {
//       sl.value = sellPrice;
//       isSlInitialized.value = true;
//     } else {
//       sl.value = (sl.value + delta).clamp(0, double.infinity);
//     }
//     slController.text = sl.value.toStringAsFixed(2);
//   }

//   void adjustTp(double delta) {
//     final ticker = tradingController.getTicker(symbol.value);
//     final buyPrice = double.tryParse(ticker?['ask']?.toString() ?? '0') ?? 0.0;

//     if (!isTpInitialized.value) {
//       tp.value = buyPrice;
//       isTpInitialized.value = true;
//     } else {
//       tp.value = (tp.value + delta).clamp(0, double.infinity);
//     }
//     tpController.text = tp.value.toStringAsFixed(2);
//   }

// //   Future<void> placeOrder(bool isBuy) async {
// //     if (volume.value <= 0) {
// //       Get.snackbar('Error', 'Volume must be greater than 0');
// //       return;
// //     }

// //     final price = (tradingController.tickerData?['ask'] ??
// //             (isBuy ? currentBuyPrice.value : currentSellPrice.value))
// //         .toDouble();

// //     // final order = OrderModel(
// //     //   symbolCode: symbol.value,
// //     //   orderType: mapOrderTypeCode(selectedOrderType.value),
// //     //   volume: volume.value,
// //     //   price: price,
// //     //   stopLoss: sl.value > 0 ? sl.value : null,
// //     //   takeProfit: tp.value > 0 ? tp.value : null,
// //     //   fillPolicy: selectedFillPolicy.value,
// //     //   accountId: 5,
// //     //   side: isBuy ? 2 : 1,
// //     // );

// //     final ticker = tradingController.tickers[symbol.toUpperCase()];
// //     final orderPrice = isBuy
// //         ? double.tryParse(ticker?['ask']?.toString() ?? '0.0') ?? 0.0
// //         : double.tryParse(ticker?['bid']?.toString() ?? '0.0') ?? 0.0;

// // final order = OrderModel(
// //   accountId: 5,
// //   symbolCode: symbol.value,
// //   price: orderPrice,
// //   side: isBuy ? 2 : 1,
// //   volume: volume.value,
// //   stopLoss: sl.value > 0 ?sl.value :null,
// //   takeProfit: tp.value > 0 ?tp.value :null,
// //   orderType: mapOrderTypeCode(selectedOrderType.value),
// //   fillPolicy: selectedFillPolicy.value
// // );

// //     final success = await OrderService.placeOrder(order);
// //     if (success) {
// //       Get.find<OrderController>().addOrder(order);
// //       sl.value = 0.0;
// //       tp.value = 0.0;
// //       slController.text = '';
// //       tpController.text = '';
// //       isSlInitialized.value = false;
// //       isTpInitialized.value = false;
// //       Get.back();
// //       Get.snackbar('Order Placed', 'Your order has been added to Trading page');
// //     } else {
// //       Get.snackbar('Error', 'Failed to place order');
// //     }
// //   }
// //

// // // new api
// Future<void> placeOrder(bool isBuy) async {
//   if (volume.value <= 0) {
//     Get.snackbar('Error', 'Volume must be greater than 0');
//     return;
//   }

//   // Fetch correct price
//   final ticker = tradingController.tickers[symbol.toUpperCase()];
//   final price = isBuy
//       ? double.tryParse(ticker?['ask']?.toString() ?? '0.0') ?? 0.0
//       : double.tryParse(ticker?['bid']?.toString() ?? '0.0') ?? 0.0;

//   final order = OrderModel(
//     // userId: 4,
//     // userUuid: "string",
//     accountId: 4,
//     accountUuid: "string",
//     instrumentId: 1001,
//     side: isBuy ? 2 : 1,
//     orderType: 2,
//     orderQty: volume.value,
//     timeInForceId: selectedFillPolicy.value == 'Fill or Kill' ? 1 : 2,
//     orderPrice: price,
//     stopPrice: sl.value > 0 ? sl.value : 0,
//     limitPrice: tp.value > 0 ? tp.value : 0,
//   );

//   final success = await OrderService.placeOrder(order);
//   if (success) {
//     Get.snackbar('Order Placed', 'Order placed successfully.');
//   } else {
//     Get.snackbar('Error', 'Failed to place order.');
//   }
// }

//   @override
//   void onClose() {
//     slController.dispose();
//     tpController.dispose();
//     super.onClose();
//   }

// }

// // // Test
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:netdania/app/enum/ordertype_enum.dart';
// import 'package:netdania/app/getX/order_getX.dart';
// import 'package:netdania/app/getX/trading_getX.dart';
// import 'package:netdania/app/models/order_model.dart';
// import 'package:netdania/screens/services/order_services.dart';

// /// ---------------- CONTROLLER ---------------- ///
// class PlaceOrderController extends GetxController {
//   final symbol = ''.obs;
//   final currentBuyPrice = 0.0.obs;
//   final currentSellPrice = 0.0.obs;

//   // final selectedOrderType = 'Buy Limit'.obs;
//   final selectedOrderType = 'Market Execution'.obs;
//   final selectedFillPolicy = 'Fill or Kill'.obs;
//   final volume = 0.2.obs;
//   final sl = 0.0.obs;
//   final tp = 0.0.obs;

//   final Map<String, String> slValues = {};
//   final Map<String, String> tpValues = {};
//   final isSlInitialized = false.obs;
//   final isTpInitialized = false.obs;

//   final slController = TextEditingController();
//   final tpController = TextEditingController();

//   final priceController = TextEditingController();

//   late TradingChartController tradingController;

//  final RxList<Map<String, dynamic>> liveData = <Map<String, dynamic>>[].obs;

//   @override
//   void onInit() {
//     tradingController = Get.find<TradingChartController>();
//   //    ever(sl, (_) => slController.text = sl.value.toStringAsFixed(5));
//   // ever(tp, (_) => tpController.text = tp.value.toStringAsFixed(5));
//   // ever(price, (_) => priceController.text = price.value.toStringAsFixed(5));
//     super.onInit();
//   }

//   void changeVolume(double delta) {
//     volume.value = (volume.value + delta).clamp(0.01, double.infinity);
//   }

// var price = 0.0.obs;
// // var priceStep = 0.0.obs;

// void syncTextWithPrice() {
//   priceController.text = price.value.toStringAsFixed(3);
// }

// void adjustPrice(double delta) {
//   price.value = (price.value + delta).clamp(0, double.infinity);
// }

// void setSymbol(String newSymbol) {
//   // Only reset when symbol actually changes
//   if (symbol.value != newSymbol) {
//     symbol.value = newSymbol;

//     // Reset SL/TP values
//     isSlInitialized.value = false;
//     isTpInitialized.value = false;
//     sl.value = 0.0;
//     tp.value = 0.0;
//     slController.text = '';
//     tpController.text = '';

//     // Optionally, update current buy/sell price for the new symbol
//     final ticker = tradingController.getTicker(newSymbol);
//     currentBuyPrice.value = double.tryParse(ticker?['ask']?.toString() ?? '0') ?? 0.0;
//     currentSellPrice.value = double.tryParse(ticker?['bid']?.toString() ?? '0') ?? 0.0;
//   }
// }

//   void adjustSl(double delta) {
//     final ticker = tradingController.getTicker(symbol.value);
//     final sellPrice = double.tryParse(ticker?['bid']?.toString() ?? '0') ?? 0.0;

//     if (!isSlInitialized.value) {
//       sl.value = sellPrice;
//       isSlInitialized.value = true;
//     } else {
//       sl.value = (sl.value + delta).clamp(0, double.infinity);
//     }
//     slController.text = sl.value.toStringAsFixed(2);
//   }

//   void adjustTp(double delta) {
//     final ticker = tradingController.getTicker(symbol.value);
//     final buyPrice = double.tryParse(ticker?['ask']?.toString() ?? '0') ?? 0.0;

//     if (!isTpInitialized.value) {
//       tp.value = buyPrice;
//       isTpInitialized.value = true;
//     } else {
//       tp.value = (tp.value + delta).clamp(0, double.infinity);
//     }
//     tpController.text = tp.value.toStringAsFixed(2);
//   }

// OrderType mapDropdownToOrderType(String dropdownValue) {
//   switch (dropdownValue) {
//     case 'Market Execution':
//       return OrderType.Market;
//     case 'Buy Limit':
//     case 'Sell Limit':
//       return OrderType.Limit;
//     case 'Buy Stop':
//     case 'Sell Stop':
//       return OrderType.Stop;
//     default:
//       return OrderType.Unknown;
//   }
// }

// // // new api
// Future<void> placeOrder(bool isBuy) async {
//   if (volume.value <= 0) {
//     Get.snackbar('Error', 'Volume must be greater than 0');
//     return;
//   }

//   // Fetch correct price
//   final ticker = tradingController.tickers[symbol.toUpperCase()];
//   final price = isBuy
//       ? double.tryParse(ticker?['ask']?.toString() ?? '0.0') ?? 0.0
//       : double.tryParse(ticker?['bid']?.toString() ?? '0.0') ?? 0.0;
//   final orderType = mapDropdownToOrderType(selectedOrderType.value);
//   final order = OrderRequestModel(
//     // userId: 4,
//     // userUuid: "string",
//     accountId: 4,
//     accountUuid: "string",
//     instrumentId: 1001,
//     side: isBuy ? 1 : 2,
//     // orderType: 2,
//     orderType: orderType.index,
//        // orderType: selectedOrderType.value =='Market Execution' ? 1 : 2,

//     orderQty: volume.value,
//     timeInForceId: selectedFillPolicy.value == 'Fill or Kill' ? 1 : 2,
//     orderPrice: price,
//     stopPrice: sl.value > 0 ? sl.value : 0,
//     limitPrice: tp.value > 0 ? tp.value : 0,
//   );

//   final success = await OrderService.placeOrder(order);
//   if (success) {
//     final orderController = Get.find<OrderController>();
//     orderController.addOrder(order);

//     // Reset UI fields
//     sl.value = 0.0;
//     tp.value = 0.0;
//     slController.text = '';
//     tpController.text = '';
//     isSlInitialized.value = false;
//     isTpInitialized.value = false;

//     // Close modal if any
//     Get.back();

//     Get.snackbar('Order Placed', 'Order placed successfully.');
//   } else {
//     Get.snackbar('Error', 'Failed to place order.');
//   }
// }

//   @override
//   void onClose() {
//     slController.dispose();
//     tpController.dispose();
//     super.onClose();
//   }

// }

// sl/tp fix

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netdania/app/config/theme/app_color.dart';
import 'package:netdania/app/enum/ordertype_enum.dart';
import 'package:netdania/app/getX/account_getx.dart';
import 'package:netdania/app/getX/order_getX.dart';
import 'package:netdania/app/getX/trading_getX.dart';
import 'package:netdania/app/models/instrument_model.dart';
// import 'package:netdania/app/getX/user_getX.dart';
import 'package:netdania/app/models/order_model.dart';
import 'package:netdania/screens/services/instrument_fetch_services.dart';
// import 'package:netdania/screens/services/notification_services.dart';
import 'package:netdania/screens/services/order_services.dart';
import 'package:netdania/app/modules/main_tab/view/main_tab_view.dart';

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

  late TradingChartController tradingController;
  @override
  void onInit() {
    tradingController = Get.put(TradingChartController());

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

      final text = sl.value.toStringAsFixed(5);
      if (slController.text != text) {
        slController.value = slController.value.copyWith(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
        );
      }
    });

    ever(tp, (_) {
      if (!isTpInitialized.value) return;

      final text = tp.value.toStringAsFixed(5);
      if (tpController.text != text) {
        tpController.value = tpController.value.copyWith(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
        );
      }
    });

    ever(selectedExpiration, (val) {
      if (val == 'GTC' || val == 'Today') {
        expirationDate.value = null;
      }
    });

    super.onInit();
  }

  void setSymbol(String newSymbol) {
    if (symbol.value != newSymbol) {
      symbol.value = newSymbol;
      final ticker = tradingController.getTicker(newSymbol);

      dotPosition.value =
          int.tryParse(ticker?['dot_position']?.toString() ?? '5') ?? 5;
      sl.value = 0.0;
      tp.value = 0.0;
      slController.clear();
      tpController.clear();
      isSlInitialized.value = false;
      isTpInitialized.value = false;

      currentBuyPrice.value =
          double.tryParse(ticker?['ask']?.toString() ?? '0') ?? 0;
      currentSellPrice.value =
          double.tryParse(ticker?['bid']?.toString() ?? '0') ?? 0;
    }
  }

  int getDotPositionForSymbol(String symbolName) {
    final ticker = tradingController.getTicker(symbolName);

    // Get dot_position from ticker
    if (ticker != null && ticker['dot_position'] != null) {
      return int.tryParse(ticker['dot_position'].toString()) ?? 5;
    }

    // Fallback to default
    return 5;
  }

  // void setSL(double value) {
  //   sl.value = value;
  //   slController.text = value.toStringAsFixed(5);
  // }

  // void setTP(double value) {
  //   tp.value = value;
  //   tpController.text = value.toStringAsFixed(5);
  // }

  // void adjustPrice(double delta) {
  //   priceController.text = (double.tryParse(priceController.text) ?? 0 + delta)
  //       .clamp(0, double.infinity)
  //       .toStringAsFixed(5);
  // }

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

  // String get expirationDisplayValue {
  //   final exp = selectedExpiration.value;

  //   final date = expirationDate.value;

  //   if (date == null) return exp;

  //   switch (exp) {
  //     case 'Specified day':
  //       return '$exp (${date.year}-${_two(date.month)}-${_two(date.day)})';
  //     case 'Specified':
  //       return '$exp (${_two(date.day)}-${_two(date.month)}-${date.year} '
  //           '${_two(date.hour)}:${_two(date.minute)})';
  //     default:
  //       return exp;
  //   }
  // }

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

  Future<void> placeOrder(bool isBuy) async {
    if (volume.value <= 0) {
      Get.snackbar('Error', 'Volume must be greater than 0');
      return;
    }

    final accountController = Get.find<AccountController>();

    if (accountController.selectedAccountId.value <= 0) {
      Get.snackbar('Error', 'No account selected');
      return;
    }

    final accountId = accountController.selectedAccountId.value;

    print("Placing order for Type: ${selectedOrderType.value}");

    // If no account is selected
    if (accountId == 0) {
      Get.snackbar('Error', 'No account selected');
      return;
    }

    await tradingController.subscribeToSymbols([symbol.value.toUpperCase()]);

    // -------------------------------------------------------
    // Get instrument dynamically
    final instrument = tradingController.getInstrumentByCode(symbol.value);
    if (instrument == null) {
      Get.snackbar('Error', 'Instrument not found for ${symbol.value}');
      return;
    }

    final instrumentId = instrument.instrumentId;

    // final orderType = mapDropdownToOrderType(selectedOrderType.value);

    // ---------------- Get Price ----------------
    final ticker = tradingController.tickers[symbol.value.toUpperCase()];

    // final price =
    //     isBuy
    //         ? double.tryParse(ticker?['ask']?.toString() ?? '0') ?? 0
    //         : double.tryParse(ticker?['bid']?.toString() ?? '0') ?? 0;

    // ---------------- Parse SL / TP from TextFields ----------------
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
        Get.snackbar('Error', 'Please enter a valid price for your order');
        return;
      }
    }

    // ---------------- Create Order Model ----------------
    // final int timeInForceId =
    // orderType == OrderType.Market
    //     ? mapFillPolicyToTIF(selectedFillPolicy.value)
    //     : mapExpirationToTIF(selectedExpiration.value);
    final int timeInForceId =
        orderType == OrderType.Market
            ? mapFillPolicyToTIF(selectedFillPolicy.value)
            : mapExpirationToTIF(selectedExpiration.value);

    String? expiryDateTime;

    final tif = timeInForceId;
    final exp = expirationDate.value;

    if (tif == 3 || tif == 4) {
      if (exp == null) {
        Get.snackbar('Validation error', 'Expiration date is required');
        return;
      }

      if (tif == 3) {
        // GTD → end of day
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
        // GTDT → exact datetime
        expiryDateTime = exp.toUtc().toIso8601String();
      }
    }

    print('TIF: $timeInForceId');
    print('expiryDateTime: $expiryDateTime');

    final currentAsk = double.tryParse(ticker?['ask']?.toString() ?? '0') ?? 0;
    final currentBid = double.tryParse(ticker?['bid']?.toString() ?? '0') ?? 0;

    if (isBuy) {
      if (stopPrice > 0 && stopPrice >= currentBid) {
        Get.snackbar('Error', 'SL must be below market price');
        return;
      }
      if (limitPrice > 0 && limitPrice <= currentAsk) {
        Get.snackbar('Error', 'TP must be above market price');
        return;
      }
    } else {
      if (stopPrice > 0 && stopPrice <= currentAsk) {
        Get.snackbar('Error', 'SL must be above market price');
        return;
      }
      if (limitPrice > 0 && limitPrice >= currentBid) {
        Get.snackbar('Error', 'TP must be below market price');
        return;
      }
    }

    final order = OrderRequestModel(
      accountId: accountId,
      // accountUuid: accountController.selectedAccountUuid.value,
      instrumentId: instrumentId, // ⬅️ Dynamic
      side: side,
      orderType: orderType.index,
      orderQty: volume.value,
      // timeInForceId: selectedFillPolicy.value == 'Fill or Kill' ? 1 : 2,
      timeInForceId: timeInForceId,
      orderPrice: orderPrice,
      stopPrice: stopPrice,
      limitPrice: limitPrice,
      // expiryDateTime: expiryDateTime
      expiryDateTime: expiryDateTime,
      // expiryDateTime: null
    );

    // ---------------- Send Order ----------------
    final success = await OrderService.placeOrder(order);
    //     final orderService = OrderService();
    // final success = await orderService.placeOrder(order);

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
      );
      // Get.until((route) => route.settings.name == '/main' || route.isFirst);
      Get.until((route) => route.isFirst);
      MainTabView.selectedIndexNotifier.value = 2;
    } else {
      Get.snackbar(
        'Error',
        'Order placement failed',
        backgroundColor: AppColors.error,
      );
    }
  }

  void changeSymbol(InstrumentModel instrument) {
    symbol.value = instrument.code;
  }

  @override
  void onClose() {
    slController.dispose();
    tpController.dispose();
    priceController.dispose();
    super.onClose();
  }

  int mapFillPolicyToTIF(String policy) {
    switch (policy) {
      case 'Fill or Kill':
        return 11; // FOK
      case 'Immediate or Cancel':
        return 12; // IOC
      default:
        return 11;
    }
  }

  int mapExpirationToTIF(String expiration) {
    switch (expiration) {
      case 'GTC':
        return 1;
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

// class OrderTypeSide {
//   final OrderType type;
//   final int side;
//   OrderTypeSide(this.type, this.side);
// }

// OrderTypeSide mapDropdownToTypeSide(String dropdownValue) {
//   switch (dropdownValue) {
//     case 'Buy Limit':
//     case 'Buy Stop':
//       return OrderTypeSide(OrderType.Limit, 1);
//     case 'Sell Limit':
//     case 'Sell Stop':
//       return OrderTypeSide(OrderType.Limit, 2); // SELL
//     case 'Market Execution':
//       return OrderTypeSide(OrderType.Market, 0);
//     default:
//       return OrderTypeSide(OrderType.Unknown, 0);
//   }
// }

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
