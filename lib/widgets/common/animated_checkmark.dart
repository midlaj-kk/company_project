import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Animated lime checkmark circle used on every success/confirmation
/// screen across the app (Job Created, Payment Success, Delivery
/// Success, etc). Plays a scale + fade-in animation once on mount.
class AnimatedCheckmark extends StatefulWidget {
  const AnimatedCheckmark({super.key, this.size = 96, this.filled = false});

  final double size;

  /// If true, renders as a solid lime circle with a black check
  /// (used on Invoice/Payment/Delivery success screens). If false,
  /// renders as an outlined lime circle (used on Job Created).
  final bool filled;

  @override
  State<AnimatedCheckmark> createState() => _AnimatedCheckmarkState();
}

class _AnimatedCheckmarkState extends State<AnimatedCheckmark>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scale = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _opacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.4, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: FadeTransition(
        opacity: _opacity,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.filled ? AppColors.limeAccent : null,
            border: widget.filled
                ? null
                : Border.all(color: AppColors.limeAccent, width: 3),
            boxShadow: widget.filled
                ? [
                    BoxShadow(
                      color: AppColors.limeAccent.withOpacity(0.5),
                      blurRadius: 30,
                      spreadRadius: 4,
                    ),
                  ]
                : null,
          ),
          child: Icon(
            Icons.check,
            color: widget.filled ? Colors.black : AppColors.limeAccent,
            size: widget.size * 0.5,
          ),
        ),
      ),
    );
  }
}