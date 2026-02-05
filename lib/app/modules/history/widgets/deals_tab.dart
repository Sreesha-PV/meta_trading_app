// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:netdania/app/getX/order_getX.dart';
// import 'package:netdania/app/modules/history/view/utils/side_label.dart';

// import 'empty_state.dart';
// import 'summary_section.dart';

// class DealsTab extends StatelessWidget {
//   final OrderController orderController;

//   const DealsTab({required this.orderController});

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final closedOrders = orderController.closedOrders;
//       final orders = orderController.orders;

//       if (orders.isEmpty) {
//         return const EmptyState(text: "No orders yet");
//       }

//       return Column(
//         children: [
//           SummarySection(orders: closedOrders),
//           const Divider(height: 0),
//           Expanded(
//             child: ListView.builder(
//               itemCount: orders.length,
//               itemBuilder: (context, index) {
//                 final order = orders[index];
//                 return ListTile(
//                   title: Text('${order.symbolCode} - ${getSideLabel(order.side)}'),
//                   subtitle: Text(
//                     '${order.volume}/${order.volume} at market',
//                     style: const TextStyle(
//                       color: Colors.grey,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       );
//     });
//   }
// }
