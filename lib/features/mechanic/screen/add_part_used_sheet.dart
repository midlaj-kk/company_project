import 'package:auto_care_app/features/mechanic/controller/add_part_used_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/common/app_button.dart';

/// Bottom sheet form for adding a Part Used to a job.
///
/// Usage:
///   showModalBottomSheet(
///     context: context,
///     isScrollControlled: true,
///     backgroundColor: Colors.transparent,
///     builder: (_) => AddPartUsedSheet(jobId: jobId),
///   );
/// On success, pop the sheet with `true` so the caller can refresh
/// the job's parts list.
class AddPartUsedSheet extends StatelessWidget {
  const AddPartUsedSheet({super.key, required this.jobId});

  final int jobId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddPartUsedController(jobId: jobId),
      child: const _AddPartUsedView(),
    );
  }
}

class _AddPartUsedView extends StatelessWidget {
  const _AddPartUsedView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AddPartUsedController>();

    if (controller.addedSuccessfully) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) Navigator.of(context).pop(true);
      });
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Header ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Add Part Used', style: AppTextStyles.heading3),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    icon: const Icon(Icons.close, color: AppColors.textMuted),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // --- Search field ---
              TextField(
                controller: controller.searchController,
                style: const TextStyle(color: AppColors.textPrimary),
                onChanged: (value) =>
                    context.read<AddPartUsedController>().search(value),
                decoration: const InputDecoration(
                  hintText: 'Search spare parts...',
                  prefixIcon: Icon(Icons.search, color: AppColors.textMuted),
                ),
              ),

              // --- Search results dropdown ---
              if (controller.isSearching)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.limeAccent),
                    ),
                  ),
                )
              else if (controller.searchResults.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: AppColors.inputFill,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  constraints: const BoxConstraints(maxHeight: 180),
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    itemCount: controller.searchResults.length,
                    itemBuilder: (context, index) {
                      final part = controller.searchResults[index];
                      return ListTile(
                        dense: true,
                        title: Text(part['name'] ?? '',
                            style: AppTextStyles.bodyRegular
                                .copyWith(fontWeight: FontWeight.w600)),
                        subtitle: Text(
                          '${(part['stock_quantity'] as num?)?.toStringAsFixed(2) ?? '0'} ${part['unit'] ?? ''} available',
                          style: AppTextStyles.caption,
                        ),
                        trailing: Text(
                          '₹${(part['selling_price'] as num?)?.toStringAsFixed(2) ?? '0.00'}',
                          style: const TextStyle(
                              color: AppColors.limeAccent,
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () => context
                            .read<AddPartUsedController>()
                            .selectPart(part),
                      );
                    },
                  ),
                ),

              // --- Selected part card ---
              if (controller.selectedPart != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.limeAccent),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.selectedPart!['name'] ?? '',
                              style: AppTextStyles.bodyRegular
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${controller.availableStock.toStringAsFixed(2)} ${controller.selectedPart!['unit'] ?? ''} available',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.check_circle,
                          color: AppColors.statusSuccess, size: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                Text('Quantity',
                    style: AppTextStyles.caption.copyWith(letterSpacing: 0.5)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _QtyButton(
                      icon: Icons.remove,
                      onTap: () => context
                          .read<AddPartUsedController>()
                          .decrementQuantity(),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          controller.quantity.toString(),
                          style: AppTextStyles.heading1.copyWith(fontSize: 28),
                        ),
                      ),
                    ),
                    _QtyButton(
                      icon: Icons.add,
                      onTap: () => context
                          .read<AddPartUsedController>()
                          .incrementQuantity(),
                    ),
                  ],
                ),

                if (controller.exceedsStock) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.amberAccent.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded,
                            color: AppColors.amberAccent, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Only ${controller.availableStock.toStringAsFixed(2)} available — reduce quantity',
                            style: AppTextStyles.caption
                                .copyWith(color: AppColors.amberAccent),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('TOTAL PRICE',
                        style: AppTextStyles.caption
                            .copyWith(letterSpacing: 0.5)),
                    Text(
                      '₹${controller.totalPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: AppColors.limeAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],

              if (controller.errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  controller.errorMessage!,
                  style: const TextStyle(
                      color: AppColors.statusError, fontSize: 13),
                ),
              ],

              const SizedBox(height: 20),
              AppButton(
                label: 'Add Part',
                isLoading: controller.isSubmitting,
                onPressed: controller.selectedPart == null ||
                        controller.exceedsStock
                    ? null
                    : () => context.read<AddPartUsedController>().submit(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: AppColors.inputFill,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.limeAccent),
      ),
    );
  }
}