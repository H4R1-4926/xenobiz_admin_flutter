import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/breadcrumb_widget.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../../core/widgets/responsive_data_table.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../shared/models/customer_model.dart';
import '../../../shared/providers/theme_provider.dart';
import '../bloc/customer_bloc.dart';
import '../bloc/customer_event.dart';
import '../bloc/customer_state.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  final _searchController = TextEditingController();

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

          if (state is CustomersLoaded) {
            final filtered = state.customers.where((c) {
              final q = _searchController.text.toLowerCase();
              return c.name.toLowerCase().contains(q) ||
                  c.email.toLowerCase().contains(q) ||
                  c.phone.contains(q) ||
                  c.shopName.toLowerCase().contains(q);
            }).toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BreadcrumbWidget(
                    items: [
                      BreadcrumbItem(label: 'Home', route: '/dashboard'),
                      BreadcrumbItem(label: 'Shops', route: '/shops'),
                      BreadcrumbItem(label: 'Customer Details'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Header Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 320,
                        child: TextField(
                          controller: _searchController,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: 'Search customer name, email, shop...',
                            prefixIcon: const Icon(Icons.search_rounded, size: 20),
                            border: OutlineInputBorder(borderRadius: AppRadius.borderRadiusSm),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _openAddCustomerDialog(context, isDark),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text('ADD CUSTOMER'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Table
                  if (filtered.isEmpty)
                    const EmptyStateWidget(
                      title: 'No Customers Found',
                      message: 'No customer records match your query.',
                    )
                  else
                    _buildCustomersTable(filtered, isDark),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      );
  }

  Widget _buildCustomersTable(List<CustomerModel> customers, bool isDark) {
    const columns = [
      DataColumnDefinition(label: 'Customer Name', width: 200),
      DataColumnDefinition(label: 'Contact Info'),
      DataColumnDefinition(label: 'Associated Store'),
      DataColumnDefinition(label: 'Location'),
      DataColumnDefinition(label: 'Total Spent'),
      DataColumnDefinition(label: 'Status'),
      DataColumnDefinition(label: 'Action', alignment: Alignment.centerRight),
    ];

    final rows = customers.map<List<Widget>>((c) {
      return [
        Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(c.email, style: const TextStyle(fontSize: 12)),
            Text(c.phone, style: AppTypography.labelMuted(isDark)),
          ],
        ),
        Text(c.shopName),
        Text('${c.city}, ${c.state}'),
        Text(Formatters.currency(c.totalSpent), style: const TextStyle(fontWeight: FontWeight.bold)),
        StatusBadge(label: c.status),
        IconButton(
          icon: const Icon(Icons.visibility_outlined, size: 18),
          onPressed: () => context.go('/customers/${c.id}'),
          tooltip: 'View Customer Details Page',
        ),
      ];
    }).toList();

    return ResponsiveDataTable(columns: columns, rows: rows);
  }

  void _openAddCustomerDialog(BuildContext context, bool isDark) {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
        title: Text('Add New Customer', style: AppTypography.titleMedium(isDark)),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Customer Name *')),
                const SizedBox(height: 12),
                TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email Address')),
                const SizedBox(height: 12),
                TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Phone Number')),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('CANCEL')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isEmpty) return;
              context.read<CustomerBloc>().add(
                    CustomerCreateSubmitted({
                      'name': nameCtrl.text.trim(),
                      'email': emailCtrl.text.trim(),
                      'phone': phoneCtrl.text.trim(),
                    }),
                  );
              Navigator.pop(dialogCtx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text('CREATE CUSTOMER'),
          ),
        ],
      ),
    );
  }
}
