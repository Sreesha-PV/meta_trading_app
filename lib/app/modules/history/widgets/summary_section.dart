// import 'package:flutter/material.dart';
// import 'package:netdania/app/models/order_model.dart';

// class SummarySection extends StatelessWidget {
//   final List<OrderModel> orders;

//   const SummarySection({required this.orders});

//   @override
//   Widget build(BuildContext context) {
//     // dummy values
//     const deposit = 500.00;
//     const swap = -1.23;
//     const commission = -3.50;

//     double profit = 0.0;

//     for (var order in orders) {
//       final entryPrice = order.price;
//       final volume = order.volume;
//       final isBuy = order.side == 2;
//       final currentPrice = entryPrice + (isBuy ? 0.01 : -0.01);
//       profit += (currentPrice - entryPrice) * volume * (isBuy ? 1 : -1);
//     }

//     final balance = deposit + profit + swap + commission;

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _summaryRow("Profit:", profit),
//           _summaryRow("Deposit:", deposit),
//           _summaryRow("Swap:", swap),
//           _summaryRow("Commission:", commission),
//           _summaryRow("Balance:", balance),
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
