// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:netdania/app/getX/order_getX.dart';
// import 'package:netdania/app/models/order_model.dart';

// import 'empty_state.dart';
// import 'order_summary_section.dart';

// class OrdersTab extends StatelessWidget {
//   final OrderController orderController;

//   const OrdersTab({required this.orderController});

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final orders = orderController.orderHistory;

//       if (orders.isEmpty) {
//         return const EmptyState(text: 'No orders yet');
//       }

//       return Column(
//         children: [
//           OrderSummarySection(orders: orders),
//           const Divider(height: 0),
//           Expanded(
//             child: ListView.builder(
//               itemCount: orders.length,
//               itemBuilder: (context, index) {
//                 final order = orders[index];
//                 return ListTile(
//                   title: Text('${order.symbolCode} - ${order.orderType}'),
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
