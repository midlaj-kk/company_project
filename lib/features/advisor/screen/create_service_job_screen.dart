import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/common/app_button.dart';
import '../controller/create_service_job_controller.dart';
import '../widgets/mechanic_picker.dart';
import 'job_creation_confirmation_screen.dart';

/// Advisor "Create Service Job" screen.
///
/// Usage once routing is set up:
///   CreateServiceJobScreen(
///     vehicleId: vehicle['id'],
///     vehicleLabel: vehicle['vehicle_number'],
///     customerName: vehicle['customer_name'],
///   )
class CreateServiceJobScreen extends StatelessWidget {
  const CreateServiceJobScreen({
    super.key,
    required this.vehicleId,
    required this.vehicleLabel,
    required this.customerName,
  });

  final int vehicleId;
  final String vehicleLabel;
  final String customerName;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateServiceJobController(
        vehicleId: vehicleId,
        vehicleLabel: vehicleLabel,
        customerName: customerName,
      )..loadMechanics(),
      child: const _CreateServiceJobView(),
    );
  }
}

class _CreateServiceJobView extends StatelessWidget {
  const _CreateServiceJobView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CreateServiceJobController>();

    if (controller.createdSuccessfully) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider.value(
              value: controller,
              child: const JobCreationConfirmationScreen(),
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
                    child: Text(
                      'Advisor - Create Service Job',
                      style: AppTextStyles.heading3,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Vehicle chip ---
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
                                Text(
                                  controller.vehicleLabel,
                                  style: AppTextStyles.bodyRegular
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(controller.customerName,
                                    style: AppTextStyles.caption),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).maybePop(),
                            child: const Text('Change',
                                style: TextStyle(color: AppColors.limeAccent)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    _FieldLabel('Complaint / Issue'),
                    TextField(
                      controller: controller.complaintController,
                      maxLines: 3,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        hintText:
                            'Describe the problem reported by the customer...',
                      ),
                    ),
                    const SizedBox(height: 16),

                    _FieldLabel('Service Type'),
                    TextField(
                      controller: controller.serviceTypeController,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        hintText: 'e.g. Full Service + Brake Pad Replacement',
                        prefixIcon:
                            Icon(Icons.build_outlined, color: AppColors.textMuted),
                      ),
                    ),
                    const SizedBox(height: 16),

                    _FieldLabel('Odometer Reading'),
                    TextField(
                      controller: controller.odometerController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        hintText: '45,200',
                        prefixIcon:
                            Icon(Icons.speed_outlined, color: AppColors.textMuted),
                        suffixText: 'km',
                        suffixStyle: TextStyle(color: AppColors.textMuted),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _FieldLabel('Assign Mechanic'),
                        Text('Skip — assign later',
                            style: AppTextStyles.caption),
                      ],
                    ),
                    const SizedBox(height: 8),

                    controller.isLoadingMechanics
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: CircularProgressIndicator(
                                  color: AppColors.limeAccent),
                            ),
                          )
                        : MechanicPicker(
                            mechanics: controller.mechanics,
                            selectedMechanicId: controller.selectedMechanicId,
                            onSelected: (id) => context
                                .read<CreateServiceJobController>()
                                .selectMechanic(id),
                          ),

                    if (controller.errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        controller.errorMessage!,
                        style: const TextStyle(
                            color: AppColors.statusError, fontSize: 13),
                      ),
                    ],

                    const SizedBox(height: 28),
                    AppButton(
                      label: 'Create Job',
                      icon: Icons.bolt,
                      isLoading: controller.isSubmitting,
                      onPressed: () =>
                          context.read<CreateServiceJobController>().submit(),
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

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: AppTextStyles.caption.copyWith(
          color: AppColors.limeAccent,
          letterSpacing: 0.6,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}