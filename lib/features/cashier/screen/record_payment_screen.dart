import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/common/app_button.dart';
import '../../../widgets/common/status_badge.dart';
import '../controller/record_payment_controller.dart';
import '../widgets/payment_method_selector.dart';
import 'payment_success_screen.dart';

/// Cashier "Record Payment" screen.
///
/// Usage once routing is set up:
///   RecordPaymentScreen(billId: bill['id'])
class RecordPaymentScreen extends StatelessWidget {
  const RecordPaymentScreen({super.key, required this.billId});

  final int billId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RecordPaymentController(billId: billId)..load(),
      child: const _RecordPaymentView(),
    );
  }
}

class _RecordPaymentView extends StatelessWidget {
  const _RecordPaymentView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RecordPaymentController>();
    final bill = controller.bill;

    if (controller.paidSuccessfully) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => PaymentSuccessScreen(
              amountPaid: double.tryParse(controller.amountController.text) ?? 0,
              fullyPaid: controller.fullyPaid,
              invoiceNumber: bill?['invoice_number'] ?? '',
              vehicleModel: bill?['job_number'] ?? '',
              serviceType: 'Service Payment',
            ),
          ),
        );
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: controller.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.limeAccent),
              )
            : controller.errorMessage != null && bill == null
                ? Center(
                    child: Text(controller.errorMessage!,
                        style: AppTextStyles.bodySecondary),
                  )
                : SingleChildScrollView(
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
                                  color: AppColors.textPrimary),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Record Payment',
                                      style: AppTextStyles.heading3
                                          .copyWith(color: AppColors.limeAccent)),
                                  Text(bill?['invoice_number'] ?? '',
                                      style: AppTextStyles.caption),
                                ],
                              ),
                            ),
                            const Icon(Icons.history,
                                color: AppColors.textPrimary, size: 20),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // --- Bill summary card ---
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('BILL SUMMARY',
                                      style: AppTextStyles.caption
                                          .copyWith(letterSpacing: 0.5)),
                                  StatusBadge(
                                      status:
                                          bill?['payment_status'] ?? 'pending'),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _AmountBlock(
                                    label: 'Total Amount',
                                    value: controller.totalAmount
                                        .toStringAsFixed(0),
                                  ),
                                  _AmountBlock(
                                    label: 'Amount Paid',
                                    value:
                                        controller.amountPaid.toStringAsFixed(0),
                                    align: CrossAxisAlignment.end,
                                  ),
                                ],
                              ),
                              const Divider(color: AppColors.divider, height: 24),
                              Text('Remaining',
                                  style: AppTextStyles.caption
                                      .copyWith(letterSpacing: 0.4)),
                              const SizedBox(height: 4),
                              Text(
                                '₹${controller.remaining.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  color: AppColors.limeAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        Text('Select Payment Method',
                            style: AppTextStyles.caption
                                .copyWith(letterSpacing: 0.4)),
                        const SizedBox(height: 10),
                        PaymentMethodSelector(
                          selectedMethod: controller.selectedMethod,
                          onSelected: (method) => context
                              .read<RecordPaymentController>()
                              .selectMethod(method),
                        ),
                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Amount to Pay',
                                style: AppTextStyles.caption
                                    .copyWith(letterSpacing: 0.4)),
                            TextButton(
                              onPressed: () => context
                                  .read<RecordPaymentController>()
                                  .payFullAmount(),
                              child: const Text('Pay Full Amount',
                                  style: TextStyle(
                                      color: AppColors.limeAccent, fontSize: 12)),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.inputFill,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.currency_rupee,
                                  color: AppColors.limeAccent, size: 22),
                              Expanded(
                                child: TextField(
                                  controller: controller.amountController,
                                  keyboardType: const TextInputType
                                      .numberWithOptions(decimal: true),
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.heading1
                                      .copyWith(fontSize: 30),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '0',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined,
                                  color: AppColors.textMuted, size: 16),
                              const SizedBox(width: 10),
                              Text('Payment Date', style: AppTextStyles.caption),
                              const Spacer(),
                              Text(
                                '${controller.paymentDate.day.toString().padLeft(2, '0')}-'
                                '${_monthAbbr(controller.paymentDate.month)}-'
                                '${controller.paymentDate.year}',
                                style: const TextStyle(
                                    color: AppColors.limeAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.calendar_today_outlined,
                                  color: AppColors.textMuted, size: 14),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.amberAccent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.info_outline,
                                  color: AppColors.amberAccent, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Funds will be credited to the main '
                                  'dealership account. Ensure the customer '
                                  'has received their digital copy of the '
                                  'invoice.',
                                  style: AppTextStyles.caption,
                                ),
                              ),
                            ],
                          ),
                        ),

                        if (controller.errorMessage != null) ...[
                          const SizedBox(height: 14),
                          Text(
                            controller.errorMessage!,
                            style: const TextStyle(
                                color: AppColors.statusError, fontSize: 13),
                          ),
                        ],

                        const SizedBox(height: 24),
                        AppButton(
                          label: 'Confirm Payment',
                          icon: Icons.check_circle_outline,
                          isLoading: controller.isSubmitting,
                          onPressed: () => context
                              .read<RecordPaymentController>()
                              .confirmPayment(),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  String _monthAbbr(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}

class _AmountBlock extends StatelessWidget {
  const _AmountBlock({
    required this.label,
    required this.value,
    this.align = CrossAxisAlignment.start,
  });

  final String label;
  final String value;
  final CrossAxisAlignment align;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 4),
        Text('₹$value',
            style: AppTextStyles.heading3.copyWith(fontSize: 18)),
      ],
    );
  }
}