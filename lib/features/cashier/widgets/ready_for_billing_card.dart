import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Horizontal-scroll card shown in "Ready for Billing" on Cashier
/// Home. Tapping "Create Bill" should navigate to the Create Bill
/// screen for this job.
class ReadyForBillingCard extends StatelessWidget {
  const ReadyForBillingCard({
    super.key,
    required this.jobNumber,
    required this.customerName,
    required this.vehicleInfo,
    this.onCreateBill,
  });

  final String jobNumber;
  final String customerName;
  final String vehicleInfo;
  final VoidCallback? onCreateBill;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(right: 12),
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
              const Icon(Icons.receipt_long_outlined,
                  color: AppColors.textMuted, size: 18),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            customerName,
            style: AppTextStyles.bodyRegular
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(vehicleInfo, style: AppTextStyles.caption, maxLines: 1),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onCreateBill,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
              ),
              child: const Text('Create Bill', style: TextStyle(fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }
}
