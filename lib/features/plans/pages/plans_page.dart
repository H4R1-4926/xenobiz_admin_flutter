import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/responsive/responsive_breakpoints.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/breadcrumb_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../shared/providers/theme_provider.dart';
import '../bloc/plan_bloc.dart';
import '../bloc/plan_event.dart';
import '../bloc/plan_state.dart';

class PlansPage extends StatefulWidget {
  const PlansPage({super.key});

  @override
  State<PlansPage> createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  @override
  void initState() {
    super.initState();
    context.read<PlanBloc>().add(PlansLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final deviceType = ResponsiveBreakpoints.getDeviceType(context);

    return BlocBuilder<PlanBloc, PlanState>(
        builder: (context, state) {
          if (state is PlanLoading) {
            return const Padding(
              padding: EdgeInsets.all(24),
              child: LoadingSkeleton(height: 380),
            );
          }

          if (state is PlanError) {
            return ErrorStateWidget(
              message: state.message,
              onRetry: () => context.read<PlanBloc>().add(PlansLoadRequested()),
            );
          }

          if (state is PlansLoaded) {
            int crossAxisCount = 4;
            if (deviceType == DeviceType.laptop) crossAxisCount = 3;
            if (deviceType == DeviceType.tablet) crossAxisCount = 2;
            if (deviceType == DeviceType.mobile) crossAxisCount = 1;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BreadcrumbWidget(
                    items: [
                      BreadcrumbItem(label: 'Home', route: '/dashboard'),
                      BreadcrumbItem(label: 'Plans', route: '/plans'),
                      BreadcrumbItem(label: 'Pricing Plans'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Action Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Configured Tier Plans', style: AppTypography.titleSmall(isDark)),
                      ElevatedButton.icon(
                        onPressed: () => _openCreatePlanDialog(context, isDark),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text('CREATE NEW PLAN'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Plans Cards Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      mainAxisExtent: 320,
                    ),
                    itemCount: state.plans.length,
                    itemBuilder: (context, index) {
                      final p = state.plans[index];
                      return Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.cardDark : AppColors.cardLight,
                          borderRadius: AppRadius.borderRadiusMd,
                          border: Border.all(
                            color: isDark ? AppColors.borderDark : AppColors.borderLight,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                StatusBadge(label: p.name, type: 'pro'),
                                StatusBadge(
                                  label: p.isActive ? 'ACTIVE' : 'DISABLED',
                                  type: p.isActive ? 'active' : 'inactive',
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  Formatters.currency(p.price),
                                  style: AppTypography.displayLarge(isDark).copyWith(fontSize: 26),
                                ),
                                Text(
                                  ' / ${p.billingCycle}',
                                  style: AppTypography.bodyMedium(isDark),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(p.description, style: AppTypography.bodyMedium(isDark), maxLines: 2),
                            const Divider(height: 24),
                            Text('Included Features:', style: AppTypography.labelBold(isDark)),
                            const SizedBox(height: 6),
                            ...p.features.take(3).map((f) => Row(
                                  children: [
                                    const Icon(Icons.check_rounded, size: 14, color: AppColors.success),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        f,
                                        style: AppTypography.bodyMedium(isDark).copyWith(fontSize: 12),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                )),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${p.subscriberCount} Subscribers',
                                  style: AppTypography.labelMuted(isDark),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.read<PlanBloc>().add(PlanToggleStatusRequested(p.id));
                                  },
                                  child: Text(p.isActive ? 'DISABLE' : 'ENABLE'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      );
  }

  void _openCreatePlanDialog(BuildContext context, bool isDark) {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
        title: Text('Create New Subscription Plan', style: AppTypography.titleMedium(isDark)),
        content: SizedBox(
          width: 420,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Plan Name *')),
                const SizedBox(height: 12),
                TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: 'Monthly Price (₹) *')),
                const SizedBox(height: 12),
                TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Description')),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('CANCEL')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isEmpty || priceCtrl.text.isEmpty) return;
              context.read<PlanBloc>().add(
                    PlanCreateSubmitted({
                      'name': nameCtrl.text.trim(),
                      'price': double.tryParse(priceCtrl.text) ?? 999.0,
                      'description': descCtrl.text.trim(),
                      'billingCycle': 'Monthly',
                    }),
                  );
              Navigator.pop(dialogCtx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text('CREATE PLAN'),
          ),
        ],
      ),
    );
  }
}
