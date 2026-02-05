import 'package:flutter/material.dart';
import 'package:netdania/app/config/theme/app_color.dart';

class AnimatedAccountMetric extends StatelessWidget {
  final String label;
  final double value;
  final Color? valueColor;
  final int decimalPlaces;

  const AnimatedAccountMetric({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.decimalPlaces = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            tween: Tween<double>(begin: value, end: value),
            builder: (context, animatedValue, child) {
              return Text(
                animatedValue.toStringAsFixed(decimalPlaces),
                style: TextStyle(
                  color: valueColor ?? AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}