import 'package:auto_care_app/widgets/common/status_badge.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Job card used in the Advisor's "Today's Jobs" list.
/// Shows the job number, vehicle info, status badge, customer name,
/// and the assigned mechanic (or an "Unassigned" indicator).
class AdvisorJobCard extends StatelessWidget {
  const AdvisorJobCard({
    super.key,
    required this.jobNumber,
    required this.vehicleInfo,
    required this.customerName,
    required this.status,
    this.mechanicName,
    this.onTap,
  });

  final String jobNumber;
  final String vehicleInfo;
  final String customerName;
  final String status;
  final String? mechanicName;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isAssigned = mechanicName != null && mechanicName!.isNotEmpty;

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(jobNumber, style: AppTextStyles.caption),
                StatusBadge(status: status),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              vehicleInfo,
              style: AppTextStyles.bodyRegular
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const CircleAvatar(
                  radius: 12,
                  backgroundColor: AppColors.inputFill,
                  child: Icon(Icons.person, size: 14, color: AppColors.textMuted),
                ),
                const SizedBox(width: 8),
                Text(customerName, style: AppTextStyles.bodySecondary),
                const Spacer(),
                if (isAssigned) ...[
                  const CircleAvatar(
                    radius: 12,
                    backgroundColor: AppColors.inputFill,
                    child: Icon(Icons.build, size: 12, color: AppColors.limeAccent),
                  ),
                  const SizedBox(width: 6),
                  Text('Tech: $mechanicName', style: AppTextStyles.caption),
                ] else
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.statusNeutral,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text('Unassigned', style: AppTextStyles.caption),
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