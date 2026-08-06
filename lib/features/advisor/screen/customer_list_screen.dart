// import 'package:auto_care_app/features/advisor/controller/customer_list_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../core/theme/app_colors.dart';
// import '../../../core/theme/app_text_styles.dart';
// import '../widgets/customer_card.dart';

// /// Advisor "Customers" list screen.
// class CustomerListScreen extends StatelessWidget {
//   const CustomerListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => CustomerListController()..loadCustomers(),
//       child: const _CustomerListView(),
//     );
//   }
// }

// class _CustomerListView extends StatelessWidget {
//   const _CustomerListView();

//   @override
//   Widget build(BuildContext context) {
//     final controller = context.watch<CustomerListController>();

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // --- Header ---
//             Padding(
//               padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Text('Customers', style: AppTextStyles.heading2),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.all(7),
//                     decoration: const BoxDecoration(
//                       color: AppColors.limeAccent,
//                       shape: BoxShape.circle,
//                     ),
//                     child: IconButton(
//                       padding: EdgeInsets.zero,
//                       constraints: const BoxConstraints(),
//                       onPressed: () => AppRouter.toAddCustomer(context),
//                       icon: const Icon(Icons.add,
//                           color: Colors.black, size: 20),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),

//             // --- Search bar ---
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: TextField(
//                 controller: controller.searchController,
//                 style: const TextStyle(color: AppColors.textPrimary),
//                 onSubmitted:
//                     context.read<CustomerListController>().onSearchSubmitted,
//                 decoration: const InputDecoration(
//                   hintText: 'Search by name or phone',
//                   prefixIcon: Icon(Icons.search, color: AppColors.textMuted),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),

//             // --- Directory count row ---
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'CLIENT DIRECTORY',
//                     style: AppTextStyles.caption.copyWith(letterSpacing: 0.6),
//                   ),
//                   Text(
//                     '${controller.totalCount} Total',
//                     style: AppTextStyles.caption.copyWith(
//                       color: AppColors.limeAccent,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 10),

//             // --- Customer list ---
//             Expanded(
//               child: RefreshIndicator(
//                 onRefresh: () =>
//                     context.read<CustomerListController>().loadCustomers(),
//                 color: AppColors.limeAccent,
//                 backgroundColor: AppColors.surface,
//                 child: controller.isLoading
//                     ? const Center(
//                         child: CircularProgressIndicator(
//                             color: AppColors.limeAccent),
//                       )
//                     : controller.errorMessage != null
//                         ? ListView(
//                             physics: const AlwaysScrollableScrollPhysics(),
//                             children: [
//                               const SizedBox(height: 80),
//                               Center(
//                                 child: Text(controller.errorMessage!,
//                                     style: AppTextStyles.bodySecondary),
//                               ),
//                             ],
//                           )
//                         : controller.customers.isEmpty
//                             ? ListView(
//                                 physics: const AlwaysScrollableScrollPhysics(),
//                                 children: [
//                                   const SizedBox(height: 80),
//                                   Center(
//                                     child: Text('No customers found',
//                                         style: AppTextStyles.bodySecondary),
//                                   ),
//                                 ],
//                               )
//                             : ListView.builder(
//                                 physics: const AlwaysScrollableScrollPhysics(),
//                                 padding: const EdgeInsets.fromLTRB(
//                                     20, 0, 20, 100),
//                                 itemCount: controller.customers.length,
//                                 itemBuilder: (context, index) {
//                                   final customer = controller.customers[index];
//                                   return CustomerCard(
//                                     name: customer['name'] ?? '',
//                                     phone: customer['phone'] ?? '',
//                                     vehicleCount:
//                                         customer['vehicle_count'] ?? 0,
//                                     onTap: () {
//                                       // TODO: navigate to customer's
//                                       // vehicle list / detail screen
//                                     },
//                                   );
//                                 },
//                               ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () => AppRouter.toAddCustomer(context),
//         backgroundColor: AppColors.limeAccent,
//         label: const Text(
//           'Add Customer',
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         icon: const Icon(Icons.person_add_alt_1, color: Colors.black),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controller/customer_list_controller.dart';
import '../widgets/customer_card.dart';

/// Advisor "Customers" list screen.
class CustomerListScreen extends StatelessWidget {
  const CustomerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CustomerListController()..loadCustomers(),
      child: const _CustomerListView(),
    );
  }
}

class _CustomerListView extends StatelessWidget {
  const _CustomerListView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CustomerListController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // --- Header ---
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text('Customers', style: AppTextStyles.heading2),
                  ),
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: const BoxDecoration(
                      color: AppColors.limeAccent,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => AppRouter.toAddCustomer(context),
                      icon: const Icon(Icons.add,
                          color: Colors.black, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // --- Search bar ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: controller.searchController,
                style: const TextStyle(color: AppColors.textPrimary),
                onSubmitted:
                    context.read<CustomerListController>().onSearchSubmitted,
                decoration: const InputDecoration(
                  hintText: 'Search by name or phone',
                  prefixIcon: Icon(Icons.search, color: AppColors.textMuted),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- Directory count row ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CLIENT DIRECTORY',
                    style: AppTextStyles.caption.copyWith(letterSpacing: 0.6),
                  ),
                  Text(
                    '${controller.totalCount} Total',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.limeAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // --- Customer list ---
            Expanded(
              child: RefreshIndicator(
                onRefresh: () =>
                    context.read<CustomerListController>().loadCustomers(),
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
                        : controller.customers.isEmpty
                            ? ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                children: [
                                  const SizedBox(height: 80),
                                  Center(
                                    child: Text('No customers found',
                                        style: AppTextStyles.bodySecondary),
                                  ),
                                ],
                              )
                            : ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: const EdgeInsets.fromLTRB(
                                    20, 0, 20, 100),
                                itemCount: controller.customers.length,
                                itemBuilder: (context, index) {
                                  final customer = controller.customers[index];
                                  return CustomerCard(
                                    name: customer['name'] ?? '',
                                    phone: customer['phone'] ?? '',
                                    vehicleCount:
                                        customer['vehicle_count'] ?? 0,
                                    onTap: () => AppRouter.toVehicleDetail(
                                      context,
                                      vehicleId: 1,
                                    ),
                                  );
                                },
                              ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => AppRouter.toAddCustomer(context),
        backgroundColor: AppColors.limeAccent,
        label: const Text(
          'Add Customer',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        icon: const Icon(Icons.person_add_alt_1, color: Colors.black),
      ),
    );
  }
}