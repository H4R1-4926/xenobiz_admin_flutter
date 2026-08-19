import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/breadcrumb_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../../core/widgets/responsive_data_table.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../shared/providers/theme_provider.dart';
import '../bloc/admins_bloc.dart';
import '../bloc/admins_event.dart';
import '../bloc/admins_state.dart';

class AdminManagementPage extends StatefulWidget {
  const AdminManagementPage({super.key});

  @override
  State<AdminManagementPage> createState() => _AdminManagementPageState();
}

class _AdminManagementPageState extends State<AdminManagementPage> {
  @override
  void initState() {
    super.initState();
    context.read<AdminsBloc>().add(AdminsLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return BlocBuilder<AdminsBloc, AdminsState>(
        builder: (context, state) {
          if (state is AdminsLoading) {
            return const Padding(
              padding: EdgeInsets.all(24),
              child: LoadingSkeleton(height: 380),
            );
          }

          if (state is AdminsError) {
            return ErrorStateWidget(
              message: state.message,
              onRetry: () => context.read<AdminsBloc>().add(AdminsLoadRequested()),
            );
          }

          if (state is AdminsLoaded) {
            const columns = [
              DataColumnDefinition(label: 'Full Name', width: 200),
              DataColumnDefinition(label: 'Email'),
              DataColumnDefinition(label: 'Login ID'),
              DataColumnDefinition(label: 'Role'),
              DataColumnDefinition(label: 'Status'),
              DataColumnDefinition(label: 'Last Login'),
              DataColumnDefinition(label: 'Actions', alignment: Alignment.centerRight),
            ];

            final rows = state.admins.map<List<Widget>>((a) {
              return [
                Text(a.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(a.email),
                Text(a.loginId, style: AppTypography.mono(isDark)),
                StatusBadge(label: a.role, type: 'pro'),
                StatusBadge(label: a.status),
                Text(a.lastLogin ?? 'Never'),
                IconButton(
                  icon: const Icon(Icons.lock_reset_rounded, size: 18),
                  onPressed: () {
                    context.read<AdminsBloc>().add(AdminResetPasswordRequested(a.id));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Password reset instructions sent for ${a.name}')),
                    );
                  },
                  tooltip: 'Reset Password',
                ),
              ];
            }).toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BreadcrumbWidget(
                    items: [
                      BreadcrumbItem(label: 'Home', route: '/dashboard'),
                      BreadcrumbItem(label: 'Admins', route: '/admins'),
                      BreadcrumbItem(label: 'Access Governance'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('System Administrators', style: AppTypography.titleSmall(isDark)),
                      ElevatedButton.icon(
                        onPressed: () => _openCreateAdminDialog(context, isDark),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text('CREATE ADMIN ACCOUNT'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ResponsiveDataTable(columns: columns, rows: rows),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      );
  }

  void _openCreateAdminDialog(BuildContext context, bool isDark) {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final loginCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();
    String selectedRole = 'SUPER_ADMIN';

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
        title: Text('Create New Admin Account', style: AppTypography.titleMedium(isDark)),
        content: SizedBox(
          width: 420,
          child: SingleChildScrollView(
            child: StatefulBuilder(
              builder: (context, setDialogState) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Full Name *')),
                  const SizedBox(height: 12),
                  TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email Address *')),
                  const SizedBox(height: 12),
                  TextField(controller: loginCtrl, decoration: const InputDecoration(labelText: 'Login ID / Username *')),
                  const SizedBox(height: 12),
                  TextField(controller: passwordCtrl, decoration: const InputDecoration(labelText: 'Initial Password *')),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: selectedRole,
                    decoration: const InputDecoration(labelText: 'Role & Permissions'),
                    items: const [
                      DropdownMenuItem(value: 'SUPER_ADMIN', child: Text('Super Admin (Full Access)')),
                      DropdownMenuItem(value: 'ADMIN', child: Text('Admin (Standard Access)')),
                      DropdownMenuItem(value: 'SUPPORT_ADMIN', child: Text('Support Admin (Customer Support)')),
                      DropdownMenuItem(value: 'READ_ONLY', child: Text('Read Only (Auditor)')),
                    ],
                    onChanged: (val) => setDialogState(() => selectedRole = val ?? 'ADMIN'),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('CANCEL')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isEmpty || emailCtrl.text.isEmpty || loginCtrl.text.isEmpty) return;
              context.read<AdminsBloc>().add(
                    AdminCreateSubmitted({
                      'name': nameCtrl.text.trim(),
                      'email': emailCtrl.text.trim(),
                      'loginId': loginCtrl.text.trim(),
                      'password': passwordCtrl.text.trim(),
                      'role': selectedRole,
                    }),
                  );
              Navigator.pop(dialogCtx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text('CREATE ADMIN'),
          ),
        ],
      ),
    );
  }
}
