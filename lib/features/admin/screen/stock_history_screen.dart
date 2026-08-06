import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controller/stock_history_controller.dart';
import '../widgets/movement_history_item.dart';

/// Admin "Stock History" screen for a single spare part.
///
/// Usage once routing is set up:
///   StockHistoryScreen(partId: part['id'])
class StockHistoryScreen extends StatelessWidget {
  const StockHistoryScreen({super.key, required this.partId});

  final int partId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StockHistoryController(partId: partId)..load(),
      child: const _StockHistoryView(),
    );
  }
}

class _StockHistoryView extends StatelessWidget {
  const _StockHistoryView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<StockHistoryController>();
    final part = controller.partDetail;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: controller.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.limeAccent),
              )
            : controller.errorMessage != null
                ? Center(
                    child: Text(controller.errorMessage!,
                        style: AppTextStyles.bodySecondary),
                  )
                : RefreshIndicator(
                    onRefresh: () =>
                        context.read<StockHistoryController>().load(),
                    color: AppColors.limeAccent,
                    backgroundColor: AppColors.surface,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- Header ---
                          Row(
                            children: [
                              IconButton(
                                onPressed: () =>
                                    Navigator.of(context).maybePop(),
                                icon: const Icon(Icons.arrow_back,
                                    color: AppColors.textPrimary),
                              ),
                              Expanded(
                                child: Text(
                                  'Admin - Stock History',
                                  style: AppTextStyles.heading3,
                                ),
                              ),
                              const Icon(Icons.notifications_outlined,
                                  color: AppColors.textPrimary),
                              const SizedBox(width: 10),
                              const CircleAvatar(
                                radius: 16,
                                backgroundColor: AppColors.inputFill,
                                child: Icon(Icons.person,
                                    size: 16, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // --- Total stock summary card ---
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      (part?['stock_quantity'] as num?)
                                              ?.toStringAsFixed(2) ??
                                          '0.00',
                                      style: AppTextStyles.heading1
                                          .copyWith(fontSize: 40),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      (part?['unit'] ?? '')
                                          .toString()
                                          .toUpperCase(),
                                      style: AppTextStyles.bodySecondary,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'TOTAL AVAILABLE STOCK',
                                  style: AppTextStyles.caption
                                      .copyWith(letterSpacing: 0.6),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    _PricePill(
                                      icon: Icons.shopping_cart_outlined,
                                      label: 'Purchase:',
                                      value:
                                          '₹${(part?['purchase_price'] as num?)?.toStringAsFixed(2) ?? '0.00'}',
                                    ),
                                    const SizedBox(width: 10),
                                    _PricePill(
                                      icon: Icons.sell_outlined,
                                      label: 'Selling:',
                                      value:
                                          '₹${(part?['selling_price'] as num?)?.toStringAsFixed(2) ?? '0.00'}',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // --- Movement history ---
                          Text('Movement History',
                              style: AppTextStyles.heading3),
                          const SizedBox(height: 8),

                          if (controller.movements.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: Text('No stock movements yet',
                                  style: AppTextStyles.bodySecondary),
                            )
                          else
                            ...controller.movements.map((m) {
                              final isIn = m['movement_type'] == 'in';
                              final qty =
                                  (m['quantity'] as num).toStringAsFixed(2);
                              final refType =
                                  (m['reference_type'] ?? '').toString();
                              final title = refType == 'purchase'
                                  ? 'Purchase Order'
                                  : refType == 'service_job'
                                      ? 'Used in Job ${m['reference_id'] ?? ''}'
                                      : 'Manual Adjustment';
                              return MovementHistoryItem(
                                title: title,
                                subtitle:
                                    '${m['created_by_name'] ?? 'Unknown'} • ${m['created_at'] ?? ''}',
                                quantityChange:
                                    '${isIn ? '+' : '-'}$qty',
                                movementType: isIn ? 'in' : 'out',
                              );
                            }),

                          const SizedBox(height: 8),

                          // --- Inventory health banner ---
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
                                Text(
                                  'INVENTORY HEALTH',
                                  style: AppTextStyles.caption.copyWith(
                                      color: AppColors.limeAccent,
                                      letterSpacing: 0.6),
                                ),
                                const SizedBox(height: 10),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: 0.75,
                                    minHeight: 6,
                                    backgroundColor: AppColors.inputFill,
                                    color: AppColors.limeAccent,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Stock level is optimal. Next reorder estimated in 12 days.',
                                  style: AppTextStyles.caption,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // --- Location / Supplier ---
                          Row(
                            children: [
                              Expanded(
                                child: _InfoCard(
                                  icon: Icons.home_work_outlined,
                                  label: 'LOCATION',
                                  value: part?['location'] ?? 'Rack A-12',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _InfoCard(
                                  icon: Icons.verified_outlined,
                                  label: 'SUPPLIER',
                                  value: part?['supplier'] ?? 'N/A',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}

class _PricePill extends StatelessWidget {
  const _PricePill({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.limeAccent),
          const SizedBox(width: 6),
          Text(label, style: AppTextStyles.caption),
          const SizedBox(width: 4),
          Text(value,
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

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
          Icon(icon, color: AppColors.limeAccent, size: 18),
          const SizedBox(height: 8),
          Text(label,
              style: AppTextStyles.caption.copyWith(letterSpacing: 0.5)),
          const SizedBox(height: 2),
          Text(value,
              style: AppTextStyles.bodyRegular
                  .copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}