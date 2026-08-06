import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/common/status_badge.dart';

/// Card for one bill in the Pending Payments list, with a progress
/// bar showing how much has been paid vs remaining.
class PendingPaymentCard extends StatelessWidget {
  const PendingPaymentCard({
    super.key,
    required this.customerName,
    required this.invoiceNumber,
    required this.vehicleNumber,
    required this.totalAmount,
    required this.paidAmount,
    required this.paymentStatus,
    this.onCollectPayment,
  });

  final String customerName;
  final String invoiceNumber;
  final String vehicleNumber;
  final double totalAmount;
  final double paidAmount;
  final String paymentStatus; // pending | partial
  final VoidCallback? onCollectPayment;

  double get remaining => totalAmount - paidAmount;
  double get progress => totalAmount > 0 ? (paidAmount / totalAmount).clamp(0, 1) : 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.inputFill,
                child: Icon(Icons.person, color: AppColors.textMuted),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(customerName,
                        style: AppTextStyles.bodyRegular
                            .copyWith(fontWeight: FontWeight.bold)),
                    Text('$invoiceNumber  •  $vehicleNumber',
                        style: AppTextStyles.caption),
                  ],
                ),
              ),
              StatusBadge(status: paymentStatus),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('TOTAL AMOUNT',
                  style: AppTextStyles.caption.copyWith(letterSpacing: 0.4)),
              Text('₹${totalAmount.toStringAsFixed(0)}',
                  style: AppTextStyles.heading3.copyWith(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppColors.inputFill,
              color: AppColors.limeAccent,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Paid: ₹${paidAmount.toStringAsFixed(0)}',
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.limeAccent)),
              Text('Remaining: ₹${remaining.toStringAsFixed(0)}',
                  style: AppTextStyles.caption),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onCollectPayment,
              icon: const Icon(Icons.point_of_sale, color: Colors.black, size: 18),
              label: const Text('Collect Payment'),
            ),
          ),
        ],
      ),
    );
  }
}