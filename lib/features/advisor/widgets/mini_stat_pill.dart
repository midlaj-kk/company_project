import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Small stat pill used in the Advisor Home "Waiting / In Progress /
/// QC Pending" row. Simpler than the dashboard StatCard — just a
/// label and a big number.
class MiniStatPill extends StatelessWidget {
  const MiniStatPill({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.isHighlighted = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: isHighlighted ? AppColors.limeAccent : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            label.toUpperCase(),
            style: AppTextStyles.caption.copyWith(
              color: isHighlighted
                  ? Colors.black.withOpacity(0.6)
                  : AppColors.textMuted,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.heading2.copyWith(
              color: isHighlighted ? Colors.black : (valueColor ?? AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}