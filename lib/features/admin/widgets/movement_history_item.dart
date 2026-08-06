import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// One entry in the Stock History movement timeline.
/// movementType is "in" (green, up-arrow) or "out" (red, down-arrow).
class MovementHistoryItem extends StatelessWidget {
  const MovementHistoryItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.quantityChange,
    required this.movementType,
  });

  final String title;
  final String subtitle;
  final String quantityChange; // e.g. "+50.00" or "-5.00"
  final String movementType; // "in" | "out"

  @override
  Widget build(BuildContext context) {
    final isIn = movementType == 'in';
    final color = isIn ? AppColors.statusSuccess : AppColors.statusError;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isIn ? Icons.arrow_upward : Icons.arrow_downward,
              color: color,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyRegular
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.caption),
              ],
            ),
          ),
          Text(
            quantityChange,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}