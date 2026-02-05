// // // market_controller.dart
// // import 'package:get/get.dart';
// // import 'package:netdania/app/getX/trading_getX.dart';

// // class MarketController extends GetxController {
// //   final tradingController = Get.find<TradingChartController>();

// //   final sl = 0.0.obs;
// //   final tp = 0.0.obs;
// //   final volume = 0.1.obs;

// //   final slInitialized = false.obs;
// //   final tpInitialized = false.obs;


// //   void adjustSl(double change, double currentPrice) {
// //     if (!slInitialized.value) {
// //       sl.value = currentPrice;
// //       slInitialized.value = true;
// //     } else {
// //       sl.value = (sl.value + change).clamp(0, double.infinity);
// //     }
// //   }

// //   void adjustTp(double change, double currentPrice) {
// //     if (!tpInitialized.value) {
// //       tp.value = currentPrice;
// //       tpInitialized.value = true;
// //     } else {
// //       tp.value = (tp.value + change).clamp(0, double.infinity);
// //     }
// //   }

// //   void changeVolume(double delta) {
// //     volume.value += delta;
// //     if (volume.value < 0.01) volume.value = 0.01;
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:netdania/app/getX/trading_getX.dart';

// class MarketController extends GetxController {
//   final tradingController = Get.find<TradingChartController>();

//   final sl = 0.7.obs;
//   final tp = 0.5.obs;
//   final volume = 0.2.obs;

//   final isSlInitialized = false.obs;
//   final isTpInitialized = false.obs;

//   final slController = TextEditingController();
//   final tpController = TextEditingController();

//   /// Update Stop Loss
//   void updateSl(double delta, String symbol) {
//     final ticker = tradingController.tickers[symbol.toUpperCase()];
//     final sellPrice = double.tryParse(ticker?['b'] ?? '1') ?? 0.0;

//     if (!isSlInitialized.value) {
//       sl.value = sellPrice;
//       isSlInitialized.value = true;
//     } else {
//       sl.value = (sl.value + delta).clamp(0, double.infinity);
//     }

//     slController.text = sl.value.toStringAsFixed(2);
//   }

//   /// Update Take Profit
//   void updateTp(double delta, String symbol) {
//     final ticker = tradingController.tickers[symbol.toUpperCase()];
//     final buyPrice = double.tryParse(ticker?['a'] ?? '1') ?? 0.0;

//     if (!isTpInitialized.value) {
//       tp.value = buyPrice;
//       isTpInitialized.value = true;
//     } else {
//       tp.value = (tp.value + delta).clamp(0, double.infinity);
//     }

//     tpController.text = tp.value.toStringAsFixed(2);
//   }

//   /// Change volume
//   void changeVolume(double delta) {
//     volume.value += delta;
//     if (volume.value < 0.01) volume.value = 0.01;
//   }

//   @override
//   void onClose() {
//     slController.dispose();
//     tpController.dispose();
//     super.onClose();
//   }
// }




import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class MarketController extends GetxController {
  final RxDouble sl = 0.7.obs;
  final RxDouble tp = 0.5.obs;
  final RxDouble volume = 0.2.obs;

  final RxBool isSlInitialized = false.obs;
  final RxBool isTpInitialized = false.obs;

  final TextEditingController slController = TextEditingController();
  final TextEditingController tpController = TextEditingController();

  final expandedIndex = Rx<int?>(null);

void toggleExpand(int index) {
  if (expandedIndex.value == index) {
    expandedIndex.value = null;
  } else {
    expandedIndex.value = index;
  }
}


  void updateSl(double sellPrice, {bool increment = true}) {
    if (!isSlInitialized.value) {
      sl.value = sellPrice;
      isSlInitialized.value = true;
    } else {
      sl.value = (sl.value + (increment ? 1 : -1)).clamp(0, double.infinity);
    }
    slController.text = sl.value.toStringAsFixed(2);
  }

  void updateTp(double buyPrice, {bool increment = true}) {
    if (!isTpInitialized.value) {
      tp.value = buyPrice;
      isTpInitialized.value = true;
    } else {
      tp.value = (tp.value + (increment ? 1 : -1)).clamp(0, double.infinity);
    }
    tpController.text = tp.value.toStringAsFixed(2);
  }

  void updateVolume(double change) {
    volume.value += change;
    if (volume.value < 0.01) volume.value = 0.01;
  }
}






