import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Rounded-square logo mark with a soft lime glow behind it,
/// matching the Stitch splash screen design.
///
/// Swap the Icon() below for your real logo (SVG/PNG) later —
/// e.g. using flutter_svg: SvgPicture.asset('assets/logo.svg').
class GlowingLogo extends StatelessWidget {
  const GlowingLogo({super.key, this.size = 96});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(size * 0.28),
        border: Border.all(color: AppColors.limeAccent.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: AppColors.limeAccent.withOpacity(0.35),
            blurRadius: 40,
            spreadRadius: 6,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.directions_car_filled_rounded,
          color: AppColors.limeAccent,
          size: size * 0.42,
        ),
      ),
    );
  }
}