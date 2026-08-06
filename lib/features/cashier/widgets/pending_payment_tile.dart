import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/common/status_badge.dart';

/// One row in the "Pending Payments" list on Cashier Home.
class PendingPaymentTile extends StatelessWidget {
  const PendingPaymentTile({
    super.key,
    required this.customerName,
    required this.invoiceNumber,
    required this.amount,
    required this.paymentStatus,
    this.onTap,
  });

  final String customerName;
  final String invoiceNumber;
  final String amount;
  final String paymentStatus; // pending | partial
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
        child: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.inputFill,
              child: Icon(Icons.person, size: 18, color: AppColors.textMuted),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customerName,
                    style: AppTextStyles.bodyRegular
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(invoiceNumber, style: AppTextStyles.caption),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹$amount',
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                const SizedBox(height: 4),
                StatusBadge(status: paymentStatus),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
