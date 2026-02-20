import 'package:flutter/material.dart';
import 'package:netdania/app/config/theme/app_color.dart';
import 'package:netdania/utils/animation_constants.dart';

class AnimatedProfitText extends StatefulWidget {
  final double profit;
  final Color profitColor;

  const AnimatedProfitText({required this.profit, required this.profitColor});

  @override
  State<AnimatedProfitText> createState() => _AnimatedProfitTextState();
}

class _AnimatedProfitTextState extends State<AnimatedProfitText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late double _previousValue;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.profit;
    _controller = AnimationController(
      duration: AnimationConstants.counterDuration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: widget.profit,
      end: widget.profit,
    ).animate(CurvedAnimation(parent: _controller, curve: AnimationConstants.curve));

  }

  @override
  void didUpdateWidget(AnimatedProfitText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profit != widget.profit) {
      _animation = Tween<double>(
        begin: _previousValue,
        end: widget.profit,
      ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
      _controller.forward(from: 0);
      _previousValue = widget.profit;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        final v = _animation.value;
        return AnimatedDefaultTextStyle(
          duration: AnimationConstants.colorDuration,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color:
                v > 0
                    ? AppColors.up
                    : v < 0
                    ? AppColors.down
                    : AppColors.textSecondary,
            letterSpacing: -0.3,
          ),
          child: Text(v.toStringAsFixed(2)),
        );
      },
    );
  }
}
