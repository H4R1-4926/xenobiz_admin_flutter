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
import '../../../shared/models/customer_model.dart';
import '../../../shared/providers/theme_provider.dart';
import '../bloc/customer_bloc.dart';
import '../bloc/customer_event.dart';
import '../bloc/customer_state.dart';

class CustomerDetailsPage extends StatefulWidget {
  final String customerId;

  const CustomerDetailsPage({
    super.key,
    required this.customerId,
  });

  @override
  State<CustomerDetailsPage> createState() => _CustomerDetailsPageState();
}

class _CustomerDetailsPageState extends State<CustomerDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<CustomerBloc>().add(CustomersLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return BlocBuilder<CustomerBloc, CustomerState>(
      builder: (context, state) {
        if (state is CustomerLoading) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: LoadingSkeleton(height: 380),
          );
        }

        if (state is CustomerError) {
          return ErrorStateWidget(
            message: state.message,
            onRetry: () => context.read<CustomerBloc>().add(CustomersLoadRequested()),
          );
        }

        CustomerModel? customer;
        if (state is CustomersLoaded) {
          try {
            customer = state.customers.firstWhere((c) => c.id == widget.customerId);
          } catch (_) {
            if (state.customers.isNotEmpty) customer = state.customers.first;
          }
        }

        if (customer == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Customer record not found.'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => context.go('/customers'),
                  child: const Text('Back to Customers'),
                ),
              ],
            ),
          );
        }

        final currentCustomer = customer;

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
                  const BreadcrumbItem(label: 'Customers', route: '/customers'),
                  BreadcrumbItem(label: currentCustomer.name),
                ],
              ),
              const SizedBox(height: 16),

              // Page Header Bar with Back Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => context.go('/customers'),
                        icon: const Icon(Icons.arrow_back_rounded),
                        tooltip: 'Back to Customer Directory',
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(currentCustomer.name, style: AppTypography.titleLarge(isDark)),
                          Text('Customer ID: ${currentCustomer.id}', style: AppTypography.mono(isDark)),
                        ],
                      ),
                    ],
                  ),
                  StatusBadge(label: currentCustomer.status),
                ],
              ),
              const SizedBox(height: 24),

              // Customer Details Card
              Container(
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
                    Text('Customer Profile & Contact Information', style: AppTypography.titleSmall(isDark)),
                    const SizedBox(height: 16),
                    _detailRow('Full Name', currentCustomer.name, isDark, isBold: true),
                    _detailRow('Email Address', currentCustomer.email.isNotEmpty ? currentCustomer.email : 'N/A', isDark),
                    _detailRow('Phone Number', currentCustomer.phone.isNotEmpty ? currentCustomer.phone : 'N/A', isDark),
                    _detailRow('Associated Store', currentCustomer.shopName, isDark, isBold: true),
                    _detailRow('City & State', '${currentCustomer.city}, ${currentCustomer.state}', isDark),
                    _detailRow('Total Lifetime Spend', Formatters.currency(currentCustomer.totalSpent), isDark, isBold: true),
                    _detailRow('Customer Registration Date', Formatters.date(currentCustomer.createdAt), isDark),
                  ],
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
