import 'package:auto_care_app/widgets/common/status_badge.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Job card for the Mechanic's "My Jobs" list. A colored left
/// border reflects the job's status at a glance (lime = in
/// progress, red = rework required, gray = waiting).
class MechanicJobCard extends StatelessWidget {
  const MechanicJobCard({
    super.key,
    required this.jobNumber,
    required this.vehicleInfo,
    required this.vehicleModel,
    required this.complaint,
    required this.status,
    required this.timeAgo,
    this.onTap,
  });

  final String jobNumber;
  final String vehicleInfo;
  final String vehicleModel;
  final String complaint;
  final String status;
  final String timeAgo;
  final VoidCallback? onTap;

  Color get _borderColor {
    switch (status) {
      case 'rework_required':
        return AppColors.statusError;
      case 'waiting':
        return AppColors.statusNeutral;
      case 'in_progress':
      default:
        return AppColors.limeAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border(left: BorderSide(color: _borderColor, width: 4)),
        ),
        padding: const EdgeInsets.all(14),
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
              vehicleInfo,
              style: AppTextStyles.bodyRegular
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Text(
              vehicleModel,
              style: AppTextStyles.caption
                  .copyWith(color: AppColors.limeAccent),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.inputFill,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Complaint: $complaint',
                style: AppTextStyles.caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time,
                        size: 12, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text(timeAgo, style: AppTextStyles.caption),
                  ],
                ),
                Row(
                  children: [
                    Text('View Details',
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.limeAccent)),
                    const Icon(Icons.chevron_right,
                        size: 14, color: AppColors.limeAccent),
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