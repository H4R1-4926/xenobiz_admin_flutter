import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/responsive/responsive_breakpoints.dart';
import '../../../core/widgets/breadcrumb_widget.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../../core/widgets/responsive_data_table.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../shared/models/shop_model.dart';
import '../../../shared/providers/theme_provider.dart';
import '../bloc/shop_bloc.dart';
import '../bloc/shop_event.dart';
import '../bloc/shop_state.dart';

class ShopsListPage extends StatefulWidget {
  const ShopsListPage({super.key});

  @override
  State<ShopsListPage> createState() => _ShopsListPageState();
}

class _ShopsListPageState extends State<ShopsListPage> {
  final _searchController = TextEditingController();
  String _selectedStatus = 'all';

  @override
  void initState() {
    super.initState();
    context.read<ShopBloc>().add(ShopsLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final isMobile = ResponsiveBreakpoints.isMobile(context);

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

          if (state is ShopsLoaded) {
            final filteredShops = state.shops.where((s) {
              final query = _searchController.text.toLowerCase();
              final matchesQuery = s.shopName.toLowerCase().contains(query) ||
                  s.ownerName.toLowerCase().contains(query) ||
                  s.email.toLowerCase().contains(query) ||
                  s.loginId.toLowerCase().contains(query);
              final matchesStatus =
                  _selectedStatus == 'all' || s.status.toLowerCase() == _selectedStatus;
              return matchesQuery && matchesStatus;
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
                      BreadcrumbItem(label: 'Store Directory'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Filter & Action Toolbar
                  _buildToolbar(context, isDark, isMobile),
                  const SizedBox(height: 20),

                  // Table
                  if (filteredShops.isEmpty)
                    const EmptyStateWidget(
                      title: 'No Shops Found',
                      message: 'No store accounts matched your search criteria or status filter.',
                    )
                  else
                    _buildShopsTable(context, filteredShops, isDark),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      );
  }

  Widget _buildToolbar(BuildContext context, bool isDark, bool isMobile) {
    final searchField = SizedBox(
      width: isMobile ? double.infinity : 300,
      child: TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: 'Search by shop name, owner, email...',
          prefixIcon: const Icon(Icons.search_rounded, size: 20),
          border: OutlineInputBorder(borderRadius: AppRadius.borderRadiusSm),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        ),
      ),
    );

    final statusDropdown = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: AppRadius.borderRadiusSm,
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedStatus,
          onChanged: (val) => setState(() => _selectedStatus = val ?? 'all'),
          items: const [
            DropdownMenuItem(value: 'all', child: Text('All Statuses')),
            DropdownMenuItem(value: 'active', child: Text('Active Only')),
            DropdownMenuItem(value: 'trial', child: Text('Trial Only')),
            DropdownMenuItem(value: 'suspended', child: Text('Suspended Only')),
            DropdownMenuItem(value: 'inactive', child: Text('Inactive Only')),
          ],
        ),
      ),
    );

    final addBtn = ElevatedButton.icon(
      onPressed: () => _openCreateShopDialog(context, isDark),
      icon: const Icon(Icons.add_rounded, size: 18),
      label: const Text('ADD NEW SHOP'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          searchField,
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: statusDropdown),
              const SizedBox(width: 12),
              addBtn,
            ],
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            searchField,
            const SizedBox(width: 16),
            statusDropdown,
          ],
        ),
        addBtn,
      ],
    );
  }

  Widget _buildShopsTable(BuildContext context, List<ShopModel> shops, bool isDark) {
    const columns = [
      DataColumnDefinition(label: 'Shop / Business', width: 220),
      DataColumnDefinition(label: 'Owner'),
      DataColumnDefinition(label: 'Contact Info'),
      DataColumnDefinition(label: 'Login ID'),
      DataColumnDefinition(label: 'Plan'),
      DataColumnDefinition(label: 'Status'),
      DataColumnDefinition(label: 'Actions', alignment: Alignment.centerRight),
    ];

    final rows = shops.map<List<Widget>>((s) {
      return [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(s.shopName, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('ID: ${s.id}', style: AppTypography.labelMuted(isDark)),
          ],
        ),
        Text(s.ownerName),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(s.email, style: const TextStyle(fontSize: 12)),
            if (s.phone.isNotEmpty)
              Text(s.phone, style: AppTypography.labelMuted(isDark)),
          ],
        ),
        Text(s.loginId, style: AppTypography.mono(isDark)),
        StatusBadge(label: s.planName, type: 'pro'),
        StatusBadge(label: s.status),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.visibility_outlined, size: 18),
              onPressed: () => context.go('/shops/${s.id}'),
              tooltip: 'View Shop Profile Page',
            ),
            IconButton(
              icon: Icon(
                s.status == 'active' ? Icons.block_rounded : Icons.check_circle_outline_rounded,
                size: 18,
                color: s.status == 'active' ? Colors.red : Colors.green,
              ),
              onPressed: () {
                final newStatus = s.status == 'active' ? 'suspended' : 'active';
                context.read<ShopBloc>().add(
                      ShopStatusUpdateRequested(shopId: s.id, status: newStatus),
                    );
              },
              tooltip: s.status == 'active' ? 'Suspend Shop' : 'Activate Shop',
            ),
          ],
        ),
      ];
    }).toList();

    return ResponsiveDataTable(columns: columns, rows: rows);
  }

  void _openCreateShopDialog(BuildContext context, bool isDark) {
    final nameCtrl = TextEditingController();
    final ownerCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final passwordCtrl = TextEditingController(text: 'Demo@12345');

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
        title: Text('Create New Shop Account', style: AppTypography.titleMedium(isDark)),
        content: SizedBox(
          width: 440,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Shop / Business Name *'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: ownerCtrl,
                  decoration: const InputDecoration(labelText: 'Owner Full Name *'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(labelText: 'Email Address *'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneCtrl,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordCtrl,
                  decoration: const InputDecoration(labelText: 'Initial Password *'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isEmpty || ownerCtrl.text.isEmpty || emailCtrl.text.isEmpty) {
                return;
              }
              context.read<ShopBloc>().add(
                    ShopCreateSubmitted({
                      'name': nameCtrl.text.trim(),
                      'fullName': ownerCtrl.text.trim(),
                      'email': emailCtrl.text.trim(),
                      'phone': phoneCtrl.text.trim(),
                      'password': passwordCtrl.text.trim(),
                    }),
                  );
              Navigator.pop(dialogCtx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text('CREATE SHOP'),
          ),
        ],
      ),
    );
  }
}
