import 'package:auto_care_app/features/admin/controller/staff_management_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../widgets/role_filter_tabs.dart';
import '../widgets/staff_card.dart';

/// Admin "Staff Management" screen — list, search, and filter staff
/// by role, with a floating button to add new staff.
class StaffManagementScreen extends StatelessWidget {
  const StaffManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StaffManagementController()..loadStaff(),
      child: const _StaffManagementView(),
    );
  }
}

class _StaffManagementView extends StatelessWidget {
  const _StaffManagementView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<StaffManagementController>();

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
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back,
                        color: AppColors.textPrimary),
                  ),
                  Expanded(
                    child: Text(
                      'Admin - Staff Management',
                      style: AppTextStyles.heading3,
                    ),
                  ),
                  IconButton(
                    onPressed: () => AppRouter.toAddMechanic(context),
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppColors.limeAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add,
                          color: Colors.black, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // --- Role filter tabs ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RoleFilterTabs(
                selectedRole: controller.selectedRole,
                onRoleSelected: (role) =>
                    context.read<StaffManagementController>().onRoleSelected(role),
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
                    context.read<StaffManagementController>().onSearchChanged,
                decoration: const InputDecoration(
                  hintText: 'Search by name or email',
                  prefixIcon: Icon(Icons.search, color: AppColors.textMuted),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- Staff list ---
            Expanded(
              child: RefreshIndicator(
                onRefresh: () =>
                    context.read<StaffManagementController>().loadStaff(),
                color: AppColors.limeAccent,
                backgroundColor: AppColors.surface,
                child: controller.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.limeAccent),
                      )
                    : controller.errorMessage != null
                        ? _ErrorState(message: controller.errorMessage!)
                        : controller.staffList.isEmpty
                            ? ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                children: [
                                  const SizedBox(height: 80),
                                  Center(
                                    child: Text('No staff found',
                                        style: AppTextStyles.bodySecondary),
                                  ),
                                ],
                              )
                            : ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: const EdgeInsets.fromLTRB(
                                    20, 0, 20, 100),
                                itemCount: controller.staffList.length,
                                itemBuilder: (context, index) {
                                  final staff = controller.staffList[index];
                                  return StaffCard(
                                    name: staff['name'] ?? '',
                                    role: staff['role'] ?? '',
                                    email: staff['email'] ?? '',
                                    phone: staff['phone'] ?? '',
                                    isActive: staff['status'] == 'active',
                                    onTap: () {
                                      // TODO: navigate to staff detail/edit screen
                                    },
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
        onPressed: () => AppRouter.toAddMechanic(context),
        backgroundColor: AppColors.limeAccent,
        label: const Text(
          'Add New Staff',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        icon: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 100),
        Icon(Icons.cloud_off, color: AppColors.textMuted, size: 40)
            .withCenter(),
        const SizedBox(height: 12),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySecondary,
            ),
          ),
        ),
      ],
    );
  }
}

extension on Widget {
  Widget withCenter() => Center(child: this);
}