import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/common/app_button.dart';
import '../controller/create_bill_controller.dart';
import 'invoice_success_screen.dart';

/// Cashier "Create Bill" screen.
///
/// Usage once routing is set up:
///   CreateBillScreen(
///     jobId: job['id'],
///     jobNumber: job['job_number'],
///     vehicleLabel: job['vehicle_number'],
///     vehicleModel: job['service_type'],
///     customerName: job['customer_name'],
///   )
class CreateBillScreen extends StatelessWidget {
  const CreateBillScreen({
    super.key,
    required this.jobId,
    required this.jobNumber,
    required this.vehicleLabel,
    required this.vehicleModel,
    required this.customerName,
    this.initialLabourCharge = 0,
    this.initialPartsCharge = 0,
  });

  final int jobId;
  final String jobNumber;
  final String vehicleLabel;
  final String vehicleModel;
  final String customerName;
  final double initialLabourCharge;
  final double initialPartsCharge;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateBillController(
        jobId: jobId,
        jobNumber: jobNumber,
        vehicleLabel: vehicleLabel,
        vehicleModel: vehicleModel,
        customerName: customerName,
        initialLabourCharge: initialLabourCharge,
        initialPartsCharge: initialPartsCharge,
      ),
      child: const _CreateBillView(),
    );
  }
}

class _CreateBillView extends StatelessWidget {
  const _CreateBillView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CreateBillController>();

    if (controller.createdSuccessfully) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        final bill = controller.createdBill!;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => InvoiceSuccessScreen(
              invoiceNumber: bill['invoice_number'] ?? '',
              serviceEntity: controller.vehicleModel,
              totalAmount: (bill['total_amount'] as num?)?.toDouble() ?? 0,
              billId: bill['id'] as int,
            ),
          ),
        );
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // --- Header ---
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
              child: Row(
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
                        Text('Cashier - Create Bill',
                            style: AppTextStyles.heading3),
                        Text(controller.jobNumber, style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                  const Icon(Icons.notifications_outlined,
                      color: AppColors.textPrimary, size: 20),
                  const SizedBox(width: 10),
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.inputFill,
                    child: Icon(Icons.person,
                        size: 16, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Vehicle card ---
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.limeAccent.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.directions_car,
                                color: AppColors.limeAccent, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('VEHICLE',
                                    style: AppTextStyles.caption
                                        .copyWith(color: AppColors.limeAccent)),
                                Text(controller.vehicleModel,
                                    style: AppTextStyles.bodyRegular
                                        .copyWith(fontWeight: FontWeight.bold)),
                                Text(controller.vehicleLabel,
                                    style: AppTextStyles.caption),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // --- Customer card ---
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 18,
                            backgroundColor: AppColors.inputFill,
                            child: Icon(Icons.person,
                                size: 18, color: AppColors.textMuted),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('CUSTOMER',
                                  style: AppTextStyles.caption
                                      .copyWith(letterSpacing: 0.4)),
                              Text(controller.customerName,
                                  style: AppTextStyles.bodyRegular
                                      .copyWith(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // --- Billing breakdown ---
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('BILLING BREAKDOWN',
                                  style: AppTextStyles.caption
                                      .copyWith(letterSpacing: 0.6)),
                              const Icon(Icons.info_outline,
                                  color: AppColors.textMuted, size: 16),
                            ],
                          ),
                          const SizedBox(height: 16),

                          _BillField(
                            label: 'Labour Charge (₹)',
                            controller: controller.labourController,
                          ),
                          const SizedBox(height: 14),
                          _BillField(
                            label: 'Parts Charge (₹)',
                            controller: controller.partsController,
                          ),
                          const SizedBox(height: 14),
                          _BillField(
                            label: 'Tax (18% GST) (₹)',
                            controller: controller.taxController,
                          ),
                          const SizedBox(height: 14),
                          _BillField(
                            label: 'Discount (₹)',
                            controller: controller.discountController,
                            suffixIcon: Icons.percent,
                          ),

                          const SizedBox(height: 20),
                          const Divider(color: AppColors.divider),
                          const SizedBox(height: 12),

                          Text('FINAL SETTLEMENT',
                              style: AppTextStyles.caption
                                  .copyWith(letterSpacing: 0.6)),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Total\nAmount',
                                  style: AppTextStyles.heading2
                                      .copyWith(height: 1.1)),
                              Text(
                                '₹${controller.totalAmount.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  color: AppColors.limeAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    Row(
                      children: [
                        _MetaChip(icon: Icons.circle, label: 'DRAFT BILL'),
                        const SizedBox(width: 10),
                        const _MetaChip(
                            icon: Icons.inventory_2_outlined,
                            label: '3 items listed'),
                      ],
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
                      label: 'Generate Invoice',
                      icon: Icons.arrow_forward,
                      isLoading: controller.isSubmitting,
                      onPressed: () =>
                          context.read<CreateBillController>().submit(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BillField extends StatelessWidget {
  const _BillField({
    required this.label,
    required this.controller,
    this.suffixIcon,
  });

  final String label;
  final TextEditingController controller;
  final IconData? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyles.caption.copyWith(letterSpacing: 0.3)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            suffixIcon: Icon(suffixIcon ?? Icons.edit_outlined,
                color: AppColors.textMuted, size: 16),
          ),
        ),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: AppColors.amberAccent),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
        ],
      ),
    );
  }
}