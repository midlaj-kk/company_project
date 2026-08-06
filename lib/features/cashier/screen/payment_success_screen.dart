import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/common/animated_checkmark.dart';
import '../../../widgets/common/status_badge.dart';

/// Confirmation screen shown right after a payment is recorded.
/// Shows a different subtitle depending on whether the bill is
/// now fully paid (→ ready for delivery) or still partial.
class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({
    super.key,
    required this.amountPaid,
    required this.fullyPaid,
    required this.invoiceNumber,
    required this.vehicleModel,
    required this.serviceType,
  });

  final double amountPaid;
  final bool fullyPaid;
  final String invoiceNumber;
  final String vehicleModel;
  final String serviceType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header ---
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back,
                        color: AppColors.limeAccent),
                  ),
                  Text('Record Payment',
                      style: AppTextStyles.heading3
                          .copyWith(color: AppColors.limeAccent)),
                  const Spacer(),
                  const Icon(Icons.history,
                      color: AppColors.textPrimary, size: 20),
                ],
              ),
              const SizedBox(height: 20),

              Center(
                child: Column(
                  children: [
                    const AnimatedCheckmark(filled: false),
                    const SizedBox(height: 20),
                    Text('Payment Recorded',
                        style: AppTextStyles.heading1
                            .copyWith(color: AppColors.limeAccent, fontSize: 24)),
                    const SizedBox(height: 6),
                    Text(
                      fullyPaid
                          ? 'Vehicle is now Ready for Delivery 🎉'
                          : 'Partial payment received successfully.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySecondary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // --- Transaction details card ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TRANSACTION DETAILS',
                        style:
                            AppTextStyles.caption.copyWith(letterSpacing: 0.5)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('INVOICE NUMBER',
                                style: AppTextStyles.caption
                                    .copyWith(letterSpacing: 0.4)),
                            const SizedBox(height: 4),
                            Text(invoiceNumber,
                                style: AppTextStyles.bodyRegular
                                    .copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('AMOUNT PAID',
                                style: AppTextStyles.caption
                                    .copyWith(letterSpacing: 0.4)),
                            const SizedBox(height: 4),
                            Text(
                              '₹${amountPaid.toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: AppColors.limeAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.inputFill,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.directions_car,
                                color: AppColors.textMuted, size: 18),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(vehicleModel,
                                    style: AppTextStyles.bodyRegular.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13)),
                                Text(serviceType, style: AppTextStyles.caption),
                              ],
                            ),
                          ),
                          const StatusBadge(status: 'paid'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () =>
                      Navigator.of(context).popUntil((route) => route.isFirst),
                  icon: const Icon(Icons.home_outlined, color: Colors.black),
                  label: const Text('Go to Home'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}