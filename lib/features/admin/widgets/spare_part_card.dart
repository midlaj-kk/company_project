import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// One spare part row in the Inventory list: name, part number,
/// stock quantity (highlighted amber if at/below minimum), price,
/// and quick +/- stock adjustment buttons.
class SparePartCard extends StatelessWidget {
  const SparePartCard({
    super.key,
    required this.name,
    required this.partNumber,
    required this.stockQuantity,
    required this.unit,
    required this.sellingPrice,
    required this.isLowStock,
    this.onAddStock,
    this.onReduceStock,
    this.onTap,
  });

  final String name;
  final String partNumber;
  final String stockQuantity;
  final String unit;
  final String sellingPrice;
  final bool isLowStock;
  final VoidCallback? onAddStock;
  final VoidCallback? onReduceStock;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTextStyles.bodyRegular
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(partNumber, style: AppTextStyles.caption),
                    ],
                  ),
                ),
                Text(
                  '₹$sellingPrice',
                  style: AppTextStyles.bodySecondary,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$stockQuantity $unit',
                  style: AppTextStyles.heading3.copyWith(
                    color: isLowStock
                        ? AppColors.amberAccent
                        : AppColors.textPrimary,
                  ),
                ),
                Row(
                  children: [
                    _StepperButton(icon: Icons.remove, onTap: onReduceStock),
                    const SizedBox(width: 8),
                    _StepperButton(icon: Icons.add, onTap: onAddStock),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 16, color: AppColors.textPrimary),
      ),
    );
  }
}