// import 'package:flutter/material.dart';
// import 'package:netdania/app/models/order_model.dart';

// class OrderSummarySection extends StatelessWidget {
//   final List<OrderModel> orders;

//   const OrderSummarySection({required this.orders});

//   @override
//   Widget build(BuildContext context) {
//     const deposit = 500.00;
//     const swap = -2.0;
//     const commission = -4.5;

//     double totalVolume = orders.fold(0, (sum, order) => sum + order.volume);
//     final balance = deposit + swap + commission;

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _summaryRow("Total Orders:", orders.length.toDouble()),
//           _summaryRow("Total Volume:", totalVolume),
//           _summaryRow("Net Change:", balance),
//         ],
//       ),
//     );
//   }
// }

// Widget _summaryRow(String label, double value) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 4),
//     child: Row(
//       children: [
//         Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
//         const SizedBox(width: 4),
//         Expanded(
//           child: LayoutBuilder(
//             builder: (context, constraints) {
//               final dotCount = (constraints.maxWidth / 3).floor();
//               return Text(
//                 List.generate(dotCount, (_) => '.').join(),
//                 maxLines: 1,
//                 overflow: TextOverflow.clip,
//                 style: const TextStyle(color: Colors.grey),
//               );
//             },
//           ),
//         ),
//         const SizedBox(width: 8),
//         Text(
//           value >= 0 ? '+${value.toStringAsFixed(2)}' : value.toStringAsFixed(2),
//           style: TextStyle(
//             color: value > 0 ? Colors.blue : value < 0 ? Colors.red : Colors.grey,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     ),
//   );
// }
