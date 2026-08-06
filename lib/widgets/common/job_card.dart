import 'package:auto_care_app/core/theme/app_colors.dart';
import 'package:auto_care_app/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'status_badge.dart';

/// Job summary card shown in list views across multiple roles
/// (Admin recent jobs, Advisor job list, Mechanic "my jobs").
///
/// Example:
///   JobCard(
///     jobNumber: "SJ-2026-00001",
///     vehicleInfo: "Porsche 911 · MH-12-A...",
///     customerName: "Vikram Malhotra",
///     status: "active",
///     onTap: () {},
///   )
class JobCard extends StatelessWidget {
  const JobCard({
    super.key,
    required this.jobNumber,
    required this.vehicleInfo,
    required this.customerName,
    required this.status,
    this.onTap,
    this.thumbnailUrl,
  });

  final String jobNumber;
  final String vehicleInfo;
  final String customerName;
  final String status;
  final VoidCallback? onTap;
  final String? thumbnailUrl;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 52,
                height: 52,
                color: AppColors.inputFill,
                child: thumbnailUrl != null
                    ? Image.network(thumbnailUrl!, fit: BoxFit.cover)
                    : const Icon(Icons.directions_car,
                        color: AppColors.textMuted),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    jobNumber,
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    vehicleInfo,
                    style: AppTextStyles.bodyRegular
                        .copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(customerName, style: AppTextStyles.bodySecondary),
                ],
              ),
            ),
            StatusBadge(status: status),
          ],
        ),
      ),
    );
  }
}