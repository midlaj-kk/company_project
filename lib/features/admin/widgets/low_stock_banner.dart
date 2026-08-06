import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Amber warning banner shown on Admin dashboard when spare parts
/// are running low. Only render this widget if lowStockCount > 0.
class LowStockBanner extends StatelessWidget {
  const LowStockBanner({
    super.key,
    required this.itemCount,
    this.onTap,
  });

  final int itemCount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.amberAccent.withOpacity(0.15),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.amberAccent.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded,
                color: AppColors.amberAccent),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Low Stock Alert',
                    style: AppTextStyles.bodyRegular
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$itemCount item${itemCount == 1 ? '' : 's'} running low in inventory',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.amberAccent),
          ],
        ),
      ),
    );
  }
}