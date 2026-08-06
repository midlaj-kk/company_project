import 'package:flutter/material.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/common/animated_checkmark.dart';
import '../../../widgets/common/role_bottom_nav.dart';

/// Full-screen confirmation shown right after an invoice is
/// generated. Pass the created bill's data in directly (no
/// Provider needed — this screen is stateless/display-only).
///
/// Usage:
///   Navigator.of(context).push(MaterialPageRoute(
///     builder: (_) => InvoiceSuccessScreen(
///       invoiceNumber: bill['invoice_number'],
///       serviceEntity: '${vehicleModel}',
///       totalAmount: bill['total_amount'],
///       billId: bill['id'],
///     ),
///   ));
class InvoiceSuccessScreen extends StatelessWidget {
  const InvoiceSuccessScreen({
    super.key,
    required this.invoiceNumber,
    required this.serviceEntity,
    required this.totalAmount,
    required this.billId,
  });

  final String invoiceNumber;
  final String serviceEntity;
  final double totalAmount;
  final int billId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // --- Top bar ---
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.inputFill,
                    child: Icon(Icons.person,
                        size: 18, color: AppColors.textMuted),
                  ),
                  const Spacer(),
                  const Icon(Icons.notifications_outlined,
                      color: AppColors.textPrimary),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const AnimatedCheckmark(filled: true),
                    const SizedBox(height: 24),
                    Text(
                      'Invoice Generated\nSuccessfully',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.heading1.copyWith(height: 1.2),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'The document has been finalized and is ready for '
                      'processing.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySecondary,
                    ),
                    const SizedBox(height: 28),

                    // --- Invoice details card ---
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        children: [
                          _DetailRow(
                            label: 'INVOICE NUMBER',
                            value: invoiceNumber,
                            valueColor: AppColors.limeAccent,
                          ),
                          const SizedBox(height: 14),
                          _DetailRow(
                            label: 'SERVICE ENTITY',
                            value: serviceEntity,
                          ),
                          const SizedBox(height: 14),
                          _DetailRow(
                            label: 'TOTAL AMOUNT',
                            value: '₹${totalAmount.toStringAsFixed(2)}',
                            valueColor: AppColors.textPrimary,
                            valueBold: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => AppRouter.toRecordPayment(
                          context,
                          billId: billId,
                        ),
                        child: const Text('Record Payment'),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.inputFill,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_outline,
                              color: AppColors.limeAccent, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'A copy of this invoice has been automatically '
                              'sent to the client\'s registered email address '
                              'and updated in their vehicle history log.',
                              style: AppTextStyles.caption,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          const RoleBottomNav(role: 'cashier', activeIndex: 2),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.valueBold = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool valueBold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: AppTextStyles.caption.copyWith(letterSpacing: 0.5)),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: valueColor ?? AppColors.textPrimary,
              fontWeight: valueBold ? FontWeight.bold : FontWeight.w600,
              fontSize: valueBold ? 16 : 14,
            ),
          ),
        ),
      ],
    );
  }
}
