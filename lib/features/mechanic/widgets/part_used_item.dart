import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// One row in the "Parts Used" list on Job Detail (Mechanic view).
class PartUsedItem extends StatelessWidget {
  const PartUsedItem({
    super.key,
    required this.partName,
    required this.quantity,
    required this.unit,
    required this.price,
    this.onDelete,
  });

  final String partName;
  final String quantity;
  final String unit;
  final String price;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.settings_outlined,
                size: 18, color: AppColors.textMuted),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  partName,
                  style: AppTextStyles.bodyRegular
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text('$quantity $unit', style: AppTextStyles.caption),
              ],
            ),
          ),
          Text('₹$price',
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13)),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline,
                size: 18, color: AppColors.statusError),
          ),
        ],
      ),
    );
  }
}