import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/common/role_bottom_nav.dart';
import '../controller/delivery_ready_controller.dart';
import '../widgets/delivery_ready_card.dart';
import 'complete_delivery_screen.dart';

/// Cashier "Delivery Ready List" screen.
class DeliveryReadyScreen extends StatelessWidget {
  const DeliveryReadyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DeliveryReadyController()..load(),
      child: const _DeliveryReadyView(),
    );
  }
}

class _DeliveryReadyView extends StatelessWidget {
  const _DeliveryReadyView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DeliveryReadyController>();

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
                    child: Text(
                      'Cashier - Delivery Ready List',
                      style: AppTextStyles.heading3
                          .copyWith(color: AppColors.limeAccent),
                    ),
                  ),
                  const Icon(Icons.notifications_outlined,
                      color: AppColors.textPrimary, size: 20),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // --- Search bar ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: controller.searchController,
                style: const TextStyle(color: AppColors.textPrimary),
                onChanged: (value) =>
                    context.read<DeliveryReadyController>().onSearchChanged(value),
                decoration: const InputDecoration(
                  hintText: 'Search by vehicle or name...',
                  prefixIcon: Icon(Icons.search, color: AppColors.textMuted),
                  suffixIcon:
                      Icon(Icons.tune, color: AppColors.textMuted, size: 18),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- List ---
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => context.read<DeliveryReadyController>().load(),
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
                        : controller.filteredVehicles.isEmpty
                            ? ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                children: [
                                  const SizedBox(height: 80),
                                  Center(
                                    child: Text(
                                        'No vehicles ready for delivery',
                                        style: AppTextStyles.bodySecondary),
                                  ),
                                ],
                              )
                            : ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: const EdgeInsets.fromLTRB(
                                    20, 0, 20, 20),
                                itemCount: controller.filteredVehicles.length,
                                itemBuilder: (context, index) {
                                  final job =
                                      controller.filteredVehicles[index];
                                  return DeliveryReadyCard(
                                    jobNumber: job['job_number'] ?? '',
                                    vehicleModel:
                                        '${job['vehicle_number'] ?? ''} ${job['service_type'] ?? ''}',
                                    customerName: job['customer_name'] ?? '',
                                    customerPhone:
                                        job['customer_phone'] ?? '',
                                    footnote: index == controller
                                                .filteredVehicles.length -
                                            1
                                        ? 'Quality Check Cleared • Final detailing complete'
                                        : null,
                                    onMarkDelivered: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              CompleteDeliveryScreen(
                                            jobId: job['id'],
                                            jobNumber:
                                                job['job_number'] ?? '',
                                            vehicleLabel:
                                                job['vehicle_number'] ?? '',
                                            customerName:
                                                job['customer_name'] ?? '',
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
      bottomNavigationBar: const RoleBottomNav(role: 'cashier', activeIndex: 2),
    );
  }
}
