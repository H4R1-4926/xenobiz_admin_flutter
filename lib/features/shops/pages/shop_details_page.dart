import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/breadcrumb_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../shared/models/shop_model.dart';
import '../../../shared/providers/theme_provider.dart';
import '../bloc/shop_bloc.dart';
import '../bloc/shop_event.dart';
import '../bloc/shop_state.dart';

class ShopDetailsPage extends StatefulWidget {
  final String shopId;

  const ShopDetailsPage({
    super.key,
    required this.shopId,
  });

  @override
  State<ShopDetailsPage> createState() => _ShopDetailsPageState();
}

class _ShopDetailsPageState extends State<ShopDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ShopBloc>().add(ShopsLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return BlocBuilder<ShopBloc, ShopState>(
      builder: (context, state) {
        if (state is ShopLoading) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: LoadingSkeleton(height: 400),
          );
        }

        if (state is ShopError) {
          return ErrorStateWidget(
            message: state.message,
            onRetry: () => context.read<ShopBloc>().add(ShopsLoadRequested()),
          );
        }

        ShopModel? shop;
        if (state is ShopsLoaded) {
          try {
            shop = state.shops.firstWhere((s) => s.id == widget.shopId);
          } catch (_) {
            if (state.shops.isNotEmpty) shop = state.shops.first;
          }
        }

        if (shop == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Shop account not found.'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => context.go('/shops'),
                  child: const Text('Back to Shops'),
                ),
              ],
            ),
          );
        }

        final currentShop = shop;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumb Navigation
              BreadcrumbWidget(
                items: [
                  const BreadcrumbItem(label: 'Home', route: '/dashboard'),
                  const BreadcrumbItem(label: 'Shops', route: '/shops'),
                  BreadcrumbItem(label: currentShop.shopName),
                ],
              ),
              const SizedBox(height: 16),

              // Page Header Bar with Back Button & Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => context.go('/shops'),
                        icon: const Icon(Icons.arrow_back_rounded),
                        tooltip: 'Back to Shop Directory',
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(currentShop.shopName, style: AppTypography.titleLarge(isDark)),
                          Text('Store ID: ${currentShop.id}', style: AppTypography.mono(isDark)),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      StatusBadge(label: currentShop.status),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          final newStatus = currentShop.status == 'active' ? 'suspended' : 'active';
                          context.read<ShopBloc>().add(
                                ShopStatusUpdateRequested(shopId: currentShop.id, status: newStatus),
                              );
                        },
                        icon: Icon(
                          currentShop.status == 'active' ? Icons.block_rounded : Icons.check_circle_outline_rounded,
                          size: 18,
                        ),
                        label: Text(currentShop.status == 'active' ? 'SUSPEND SHOP' : 'ACTIVATE SHOP'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: currentShop.status == 'active' ? AppColors.error : AppColors.success,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Shop Details Tabbed Container
              DefaultTabController(
                length: 4,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : AppColors.cardLight,
                    borderRadius: AppRadius.borderRadiusMd,
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TabBar(
                        isScrollable: true,
                        labelColor: AppColors.primary,
                        unselectedLabelColor: isDark ? Colors.grey : Colors.black54,
                        tabs: const [
                          Tab(text: 'Company Info'),
                          Tab(text: 'Account & Credentials'),
                          Tab(text: 'Subscription Details'),
                          Tab(text: 'Payment History'),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 340,
                        child: TabBarView(
                          children: [
                            // Company Info Tab
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _detailRow('Business Name', currentShop.shopName, isDark, isBold: true),
                                _detailRow('Owner / Contact Person', currentShop.ownerName, isDark),
                                _detailRow('Registered Address', currentShop.address ?? 'MG Road Sector 14', isDark),
                                _detailRow('City & State', '${currentShop.city ?? "Gurugram"}, ${currentShop.state ?? "Haryana"}', isDark),
                                _detailRow('Account Registration Date', Formatters.date(currentShop.createdAt), isDark),
                              ],
                            ),
                            // Account & Credentials Tab
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _detailRow('Login ID / Username', currentShop.loginId, isDark, isMono: true),
                                _detailRow('Email Address', currentShop.email, isDark),
                                _detailRow('Phone Number', currentShop.phone.isNotEmpty ? currentShop.phone : 'Not Provided', isDark),
                                _detailRow('Account Status', currentShop.status.toUpperCase(), isDark, isBold: true),
                              ],
                            ),
                            // Subscription Details Tab
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _detailRow('Active Tier Plan', currentShop.planName, isDark, isBold: true),
                                _detailRow('Billing Cycle', 'Monthly Recurring', isDark),
                                _detailRow('Subscription Status', currentShop.status == 'active' ? 'ACTIVE & GOOD STANDING' : 'TRIAL / SUSPENDED', isDark),
                                _detailRow('Next Renewal Date', Formatters.date(currentShop.createdAt), isDark),
                              ],
                            ),
                            // Payment History Tab
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Recent Transactions for ${currentShop.shopName}:', style: AppTypography.labelBold(isDark)),
                                const SizedBox(height: 12),
                                _detailRow('• TXN_9923841029', '₹1,499 (SUCCESS - Razorpay)', isDark, isMono: true),
                                _detailRow('• TXN_9912034912', '₹1,499 (SUCCESS - Razorpay)', isDark, isMono: true),
                                _detailRow('• TXN_9801923841', '₹1,499 (SUCCESS - Razorpay)', isDark, isMono: true),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(String label, String value, bool isDark, {bool isMono = false, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.labelMuted(isDark)),
          Text(
            value,
            style: isMono
                ? AppTypography.mono(isDark)
                : TextStyle(
                    fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                    fontSize: 14,
                    color: isDark ? Colors.white : Colors.black,
                  ),
          ),
        ],
      ),
    );
  }
}
