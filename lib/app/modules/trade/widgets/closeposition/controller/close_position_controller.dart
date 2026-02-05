// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:netdania/app/getX/close_position.gettx.dart';
// import 'package:netdania/app/models/close_order_model.dart';
// import 'package:netdania/screens/services/close_position_services.dart';

// class ClosePositionUIController extends GetxController {
//   var symbol = "".obs;
//   var volume = 0.01.obs;
//   var side = 0.obs;

//   var policy = "FOK".obs;

//   final slController = TextEditingController();
//   final tpController = TextEditingController();

//   void changeVolume(double v) {
//     volume.value = (volume.value + v).clamp(0.01, 1000);
//   }

//   Future<void> submitClose(ClosePositionRequest req) async {
//     await Get.find<ClosePositionController>().closePosition(req);
//   }
// }
