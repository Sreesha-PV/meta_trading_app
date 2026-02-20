import 'package:flutter/material.dart';
import 'package:netdania/app/config/theme/app_color.dart';
import 'package:netdania/utils/animation_constants.dart';

class AnimatedAccountMetric extends StatefulWidget {
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
  State<AnimatedAccountMetric> createState() => _AnimatedAccountMetricState();
}

class _AnimatedAccountMetricState extends State<AnimatedAccountMetric>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late double _previousValue;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.value;
    _controller = AnimationController(
      duration: AnimationConstants.counterDuration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: widget.value,
      end: widget.value,
    ).animate(CurvedAnimation(parent: _controller, curve: AnimationConstants.curve));

  }

  @override
  void didUpdateWidget(AnimatedAccountMetric oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _animation = Tween<double>(
        begin: _previousValue,
        end: widget.value,
      ).animate(CurvedAnimation(parent: _controller, curve: AnimationConstants.curve));

      _controller.forward(from: 0);
      _previousValue = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, _) {
              return AnimatedDefaultTextStyle(
                duration: AnimationConstants.colorDuration,
                style: TextStyle(
                  color: widget.valueColor ?? AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                child: Text(
                  _animation.value.toStringAsFixed(widget.decimalPlaces),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}