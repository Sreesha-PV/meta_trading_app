import 'package:flutter/material.dart';

class PriceWidget extends StatelessWidget {
  final String price;
  final bool isUp;
  final String limitStr;
  final bool isSell;
  final int dotPosition;

  const PriceWidget({
    super.key,
    required this.price,
    required this.isUp,
    required this.limitStr,
    this.isSell = false,
    required this.dotPosition,
  });

  @override
  Widget build(BuildContext context) {
    final parsed = double.tryParse(price)?.toStringAsFixed(dotPosition) ?? '--.--';

    return Column(
      crossAxisAlignment: isSell ? CrossAxisAlignment.center : CrossAxisAlignment.end,
      children: [
        Text(
          parsed,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: isUp ? Colors.blue : Colors.red,
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}