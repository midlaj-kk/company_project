import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controller/inventory_controller.dart';
import '../widgets/spare_part_card.dart';

/// Admin "Inventory / Spare Parts" screen.
class InventoryListScreen extends StatelessWidget {
  const InventoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InventoryController()..loadParts(),
      child: const _InventoryView(),
    );
  }
}

class _InventoryView extends StatelessWidget {
  const _InventoryView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<InventoryController>();

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
                    child: Text('Inventory', style: AppTextStyles.heading3),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppColors.limeAccent,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        // TODO: navigate to Add Spare Part screen
                      },
                      icon: const Icon(Icons.add,
                          color: Colors.black, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // --- Stat row ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _StatBox(
                      label: 'TOTAL PARTS',
                      value: controller.totalParts.toString(),
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatBox(
                      label: 'LOW STOCK',
                      value: controller.lowStockCount.toString(),
                      color: AppColors.amberAccent,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // --- Search + filter ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.searchController,
                      style: const TextStyle(color: AppColors.textPrimary),
                      onSubmitted:
                          context.read<InventoryController>().onSearchSubmitted,
                      decoration: const InputDecoration(
                        hintText: 'Search inventory...',
                        prefixIcon:
                            Icon(Icons.search, color: AppColors.textMuted),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.inputFill,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(Icons.tune, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // --- Tabs ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _TabChip(
                    label: 'ALL PARTS',
                    isSelected: !controller.showLowStockOnly,
                    onTap: () =>
                        context.read<InventoryController>().setTab(false),
                  ),
                  const SizedBox(width: 8),
                  _TabChip(
                    label: 'LOW STOCK',
                    isSelected: controller.showLowStockOnly,
                    onTap: () =>
                        context.read<InventoryController>().setTab(true),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // --- Parts list ---
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => context.read<InventoryController>().loadParts(),
                color: AppColors.limeAccent,
                backgroundColor: AppColors.surface,
                child: controller.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.limeAccent),
                      )
                    : controller.errorMessage != null
                        ? Center(
                            child: Text(controller.errorMessage!,
                                style: AppTextStyles.bodySecondary),
                          )
                        : ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                            itemCount: controller.parts.length,
                            itemBuilder: (context, index) {
                              final part = controller.parts[index];
                              final stock = part['stock_quantity'];
                              final minStock = part['minimum_stock'];
                              final isLow =
                                  (stock as num) <= (minStock as num);

                              return SparePartCard(
                                name: part['name'] ?? '',
                                partNumber: part['part_number'] ?? '',
                                stockQuantity: stock.toStringAsFixed(2),
                                unit: part['unit'] ?? '',
                                sellingPrice: (part['selling_price'] as num)
                                    .toStringAsFixed(2),
                                isLowStock: isLow,
                                onAddStock: () => context
                                    .read<InventoryController>()
                                    .addStock(part['id']),
                                onReduceStock: () => context
                                    .read<InventoryController>()
                                    .reduceStock(part['id']),
                                onTap: () => AppRouter.toStockHistory(
                                  context,
                                  partId: part['id'],
                                ),
                              );
                            },
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: AppTextStyles.caption.copyWith(letterSpacing: 0.6)),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.heading2.copyWith(color: color)),
        ],
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  const _TabChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.limeAccent : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : AppColors.textSecondary,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }
}