import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controller/pending_payments_controller.dart';
import '../widgets/pending_payment_card.dart';
import 'record_payment_screen.dart';

/// Cashier "Pending Payments" screen.
class PendingPaymentsScreen extends StatelessWidget {
  const PendingPaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PendingPaymentsController()..load(),
      child: const _PendingPaymentsView(),
    );
  }
}

class _PendingPaymentsView extends StatelessWidget {
  const _PendingPaymentsView();

  static const _tabs = [
    ('all', 'All'),
    ('pending', 'Pending'),
    ('partial', 'Partial'),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PendingPaymentsController>();

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
                    child: Text('Cashier - Pending Payments',
                        style: AppTextStyles.heading3),
                  ),
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.inputFill,
                    child: Icon(Icons.person,
                        size: 16, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // --- Filter tabs ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: _tabs.map((entry) {
                  final (value, label) = entry;
                  final isSelected = value == controller.selectedFilter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => context
                          .read<PendingPaymentsController>()
                          .setFilter(value),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.limeAccent
                              : AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.black
                                : AppColors.textSecondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // --- List ---
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => context.read<PendingPaymentsController>().load(),
                color: AppColors.limeAccent,
                backgroundColor: AppColors.surface,
                child: controller.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.limeAccent),
                      )
                    : controller.errorMessage != null
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              const SizedBox(height: 80),
                              Center(
                                child: Text(controller.errorMessage!,
                                    style: AppTextStyles.bodySecondary),
                              ),
                            ],
                          )
                        : controller.filteredBills.isEmpty
                            ? ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                children: [
                                  const SizedBox(height: 80),
                                  Center(
                                    child: Text('No pending payments',
                                        style: AppTextStyles.bodySecondary),
                                  ),
                                ],
                              )
                            : ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: const EdgeInsets.fromLTRB(
                                    20, 0, 20, 20),
                                itemCount: controller.filteredBills.length,
                                itemBuilder: (context, index) {
                                  final bill = controller.filteredBills[index];
                                  return PendingPaymentCard(
                                    customerName: bill['customer_name'] ?? '',
                                    invoiceNumber:
                                        bill['invoice_number'] ?? '',
                                    vehicleNumber:
                                        bill['vehicle_number'] ?? '',
                                    totalAmount: (bill['total_amount'] as num?)
                                            ?.toDouble() ??
                                        0,
                                    paidAmount: (bill['amount_paid'] as num?)
                                            ?.toDouble() ??
                                        0,
                                    paymentStatus:
                                        bill['payment_status'] ?? 'pending',
                                    onCollectPayment: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => RecordPaymentScreen(
                                            billId: bill['id'],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
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
          Icon(Icons.receipt_long_outlined,
              color: AppColors.textMuted, size: 24),
          Icon(Icons.point_of_sale, color: AppColors.limeAccent, size: 24),
          Icon(Icons.bar_chart_outlined, color: AppColors.textMuted, size: 24),
          Icon(Icons.settings_outlined, color: AppColors.textMuted, size: 24),
        ],
      ),
    );
  }
}