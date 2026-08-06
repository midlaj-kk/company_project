import 'package:auto_care_app/widgets/common/status_badge.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// One row in a vehicle's Service History list.
class ServiceHistoryTile extends StatelessWidget {
  const ServiceHistoryTile({
    super.key,
    required this.jobNumber,
    required this.serviceType,
    required this.status,
    required this.date,
    required this.mechanicName,
    this.amount,
    this.onTap,
  });

  final String jobNumber;
  final String serviceType;
  final String status;
  final String date;
  final String mechanicName;
  final String? amount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(jobNumber, style: AppTextStyles.caption),
                StatusBadge(status: status),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              serviceType,
              style: AppTextStyles.bodyRegular
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined,
                    size: 12, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text(date, style: AppTextStyles.caption),
                const SizedBox(width: 14),
                const Icon(Icons.person_outline,
                    size: 12, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text(mechanicName, style: AppTextStyles.caption),
                const Spacer(),
                if (amount != null)
                  Text(
                    '₹$amount',
                    style: const TextStyle(
                      color: AppColors.limeAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}