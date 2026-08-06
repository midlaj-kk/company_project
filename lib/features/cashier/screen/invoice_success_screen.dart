import 'package:flutter/material.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/common/animated_checkmark.dart';

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
                            value: '\$${totalAmount.toStringAsFixed(2)}',
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
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // TODO: view invoice
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.divider),
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            icon: const Icon(Icons.visibility_outlined,
                                color: AppColors.textPrimary, size: 18),
                            label: const Text('View',
                                style:
                                    TextStyle(color: AppColors.textPrimary)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // TODO: download invoice PDF
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.divider),
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            icon: const Icon(Icons.download_outlined,
                                color: AppColors.textPrimary, size: 18),
                            label: const Text('PDF',
                                style:
                                    TextStyle(color: AppColors.textPrimary)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

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
      bottomNavigationBar: const _CashierBottomNav(),
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
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? AppColors.textPrimary,
            fontWeight: valueBold ? FontWeight.bold : FontWeight.w600,
            fontSize: valueBold ? 16 : 14,
          ),
        ),
      ],
    );
  }
}

class _CashierBottomNav extends StatelessWidget {
  const _CashierBottomNav();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.grid_view_rounded, color: AppColors.textMuted, size: 24),
          Icon(Icons.receipt_long_outlined,
              color: AppColors.limeAccent, size: 24),
          Icon(Icons.directions_car_outlined,
              color: AppColors.textMuted, size: 24),
          Icon(Icons.calendar_today_outlined,
              color: AppColors.textMuted, size: 24),
          Icon(Icons.settings_outlined, color: AppColors.textMuted, size: 24),
        ],
      ),
    );
  }
}