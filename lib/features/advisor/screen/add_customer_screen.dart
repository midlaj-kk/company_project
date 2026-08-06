import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/common/app_button.dart';
import '../../../widgets/common/app_text_field.dart';
import '../controller/add_customer_controller.dart';
import '../widgets/advisor_tip_banner.dart';
import '../widgets/brand_dropdown.dart';
import '../widgets/number_stepper.dart';
import '../widgets/step_progress_indicator.dart';

/// Advisor "Add Customer + Vehicle" screen — a 2-step form.
/// Step 1 (Customer) matches the provided Stitch screenshot;
/// Step 2 (Vehicle) follows immediately after, same visual style.
class AddCustomerScreen extends StatelessWidget {
  const AddCustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddCustomerController(),
      child: const _AddCustomerView(),
    );
  }
}

class _AddCustomerView extends StatelessWidget {
  const _AddCustomerView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AddCustomerController>();

    if (controller.completedSuccessfully) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Customer saved successfully')),
        );
        Navigator.of(context).maybePop();
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
                    onPressed: () {
                      if (controller.currentStep == 2) {
                        context.read<AddCustomerController>().goBackToStep1();
                      } else {
                        Navigator.of(context).maybePop();
                      }
                    },
                    icon: const Icon(Icons.arrow_back,
                        color: AppColors.textPrimary),
                  ),
                  Expanded(
                    child: Text(
                      'Advisor - Add Customer + Vehicle',
                      style: AppTextStyles.heading3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // --- Step progress ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: StepProgressIndicator(currentStep: controller.currentStep),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: controller.currentStep == 1
                    ? _CustomerStep(controller: controller)
                    : _VehicleStep(controller: controller),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomerStep extends StatelessWidget {
  const _CustomerStep({required this.controller});
  final AddCustomerController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Customer Profile', style: AppTextStyles.heading2),
        const SizedBox(height: 6),
        Text(
          'Enter the primary contact information to begin the service record.',
          style: AppTextStyles.bodySecondary,
        ),
        const SizedBox(height: 24),

        _FieldLabel('Full Name'),
        AppTextField(
          controller: controller.nameController,
          hint: 'e.g. Julian Anderson',
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 16),

        _FieldLabel('Phone Number'),
        AppTextField(
          controller: controller.phoneController,
          hint: '+1 (555) 000-0000',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),

        _FieldLabel('Email (Optional)'),
        AppTextField(
          controller: controller.emailController,
          hint: 'j.anderson@email.com',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),

        _FieldLabel('Residential Address'),
        AppTextField(
          controller: controller.addressController,
          hint: 'Street name, City, Zip Code...',
          icon: Icons.location_on_outlined,
        ),
        const SizedBox(height: 20),

        const AdvisorTipBanner(
          title: 'ADVISOR TIP',
          message:
              'Ensure the phone number is verified for SMS status updates. '
              'Luxury clients prefer digital communication for service '
              'progress milestones.',
        ),

        if (controller.errorMessage != null) ...[
          const SizedBox(height: 16),
          Text(
            controller.errorMessage!,
            style: const TextStyle(color: AppColors.statusError, fontSize: 13),
          ),
        ],

        const SizedBox(height: 28),
        AppButton(
          label: 'Next: Add Vehicle',
          icon: Icons.arrow_forward,
          isLoading: controller.isLoading,
          onPressed: () =>
              context.read<AddCustomerController>().submitCustomerStep(),
        ),
      ],
    );
  }
}

class _VehicleStep extends StatelessWidget {
  const _VehicleStep({required this.controller});
  final AddCustomerController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Add Vehicle', style: AppTextStyles.heading2),
        const SizedBox(height: 20),

        _FieldLabel('Vehicle Number'),
        AppTextField(
          controller: controller.vehicleNumberController,
          hint: 'KA-01-AB-1234',
          icon: Icons.confirmation_number_outlined,
        ),
        const SizedBox(height: 16),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FieldLabel('Brand'),
                  BrandDropdown(
                    value: controller.selectedBrand,
                    onChanged: (brand) =>
                        context.read<AddCustomerController>().setBrand(brand),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FieldLabel('Model'),
                  AppTextField(
                    controller: controller.modelController,
                    hint: 'e.g. 911 GT3',
                    icon: Icons.directions_car_outlined,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FieldLabel('Year'),
                  NumberStepper(
                    value: controller.year,
                    onChanged: (y) =>
                        context.read<AddCustomerController>().setYear(y),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FieldLabel('Current Kilometers'),
                  AppTextField(
                    controller: controller.kilometersController,
                    hint: '12,500',
                    icon: Icons.speed_outlined,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // --- Vehicle scanning banner ---
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            children: [
              Container(
                height: 130,
                width: double.infinity,
                color: AppColors.inputFill,
                child: const Icon(Icons.album_outlined,
                    size: 64, color: AppColors.textMuted),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.background.withOpacity(0.85),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 14,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'VEHICLE SCANNING READY',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.limeAccent,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text('Precision diagnostic suite active',
                        style: AppTextStyles.caption),
                  ],
                ),
              ),
            ],
          ),
        ),

        if (controller.errorMessage != null) ...[
          const SizedBox(height: 16),
          Text(
            controller.errorMessage!,
            style: const TextStyle(color: AppColors.statusError, fontSize: 13),
          ),
        ],

        const SizedBox(height: 24),
        AppButton(
          label: 'Save & Continue',
          icon: Icons.arrow_forward,
          isLoading: controller.isLoading,
          onPressed: () =>
              context.read<AddCustomerController>().submitVehicleStep(),
        ),
        const SizedBox(height: 12),
        Center(
          child: TextButton(
            onPressed: controller.isLoading
                ? null
                : () => context.read<AddCustomerController>().skipVehicleStep(),
            child: Text('Skip for now', style: AppTextStyles.bodySecondary),
          ),
        ),
      ],
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