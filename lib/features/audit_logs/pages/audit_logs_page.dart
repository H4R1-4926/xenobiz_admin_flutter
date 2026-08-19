import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/breadcrumb_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../../core/widgets/responsive_data_table.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../shared/providers/theme_provider.dart';
import '../bloc/audit_logs_bloc.dart';
import '../bloc/audit_logs_event.dart';
import '../bloc/audit_logs_state.dart';

class AuditLogsPage extends StatefulWidget {
  const AuditLogsPage({super.key});

  @override
  State<AuditLogsPage> createState() => _AuditLogsPageState();
}

class _AuditLogsPageState extends State<AuditLogsPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuditLogsBloc>().add(AuditLogsLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return BlocBuilder<AuditLogsBloc, AuditLogsState>(
        builder: (context, state) {
          if (state is AuditLogsLoading) {
            return const Padding(
              padding: EdgeInsets.all(24),
              child: LoadingSkeleton(height: 380),
            );
          }

          if (state is AuditLogsError) {
            return ErrorStateWidget(
              message: state.message,
              onRetry: () => context.read<AuditLogsBloc>().add(AuditLogsLoadRequested()),
            );
          }

          if (state is AuditLogsLoaded) {
            const columns = [
              DataColumnDefinition(label: 'Action Performed', width: 220),
              DataColumnDefinition(label: 'Admin User', width: 180),
              DataColumnDefinition(label: 'Target Type'),
              DataColumnDefinition(label: 'Target ID'),
              DataColumnDefinition(label: 'IP Address'),
              DataColumnDefinition(label: 'Timestamp'),
              DataColumnDefinition(label: 'Inspect', alignment: Alignment.centerRight),
            ];

            final rows = state.logs.map<List<Widget>>((l) {
              return [
                Text(l.action, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(l.adminName),
                StatusBadge(label: l.targetType, type: 'pro'),
                Text(l.targetId, style: AppTypography.mono(isDark)),
                Text(l.ipAddress, style: AppTypography.mono(isDark)),
                Text(l.createdAt),
                IconButton(
                  icon: const Icon(Icons.info_outline_rounded, size: 18),
                  onPressed: () => context.go('/audit-logs/${l.id}'),
                  tooltip: 'View Full Audit Details Page',
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
                      BreadcrumbItem(label: 'Audit Logs', route: '/audit-logs'),
                      BreadcrumbItem(label: 'Security Logs'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ResponsiveDataTable(columns: columns, rows: rows),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      );
  }
}
