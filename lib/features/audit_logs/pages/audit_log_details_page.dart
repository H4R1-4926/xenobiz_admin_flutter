import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/breadcrumb_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../shared/models/audit_log_model.dart';
import '../../../shared/providers/theme_provider.dart';
import '../bloc/audit_logs_bloc.dart';
import '../bloc/audit_logs_event.dart';
import '../bloc/audit_logs_state.dart';

class AuditLogDetailsPage extends StatefulWidget {
  final String logId;

  const AuditLogDetailsPage({
    super.key,
    required this.logId,
  });

  @override
  State<AuditLogDetailsPage> createState() => _AuditLogDetailsPageState();
}

class _AuditLogDetailsPageState extends State<AuditLogDetailsPage> {
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

        AuditLogModel? log;
        if (state is AuditLogsLoaded) {
          try {
            log = state.logs.firstWhere((l) => l.id == widget.logId || l.action == widget.logId);
          } catch (_) {
            if (state.logs.isNotEmpty) log = state.logs.first;
          }
        }

        if (log == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Audit log record not found.'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => context.go('/audit-logs'),
                  child: const Text('Back to Audit Logs'),
                ),
              ],
            ),
          );
        }

        final currentLog = log;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumb Navigation
              BreadcrumbWidget(
                items: [
                  const BreadcrumbItem(label: 'Home', route: '/dashboard'),
                  const BreadcrumbItem(label: 'Audit Logs', route: '/audit-logs'),
                  BreadcrumbItem(label: currentLog.action),
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
                        onPressed: () => context.go('/audit-logs'),
                        icon: const Icon(Icons.arrow_back_rounded),
                        tooltip: 'Back to Security Audit Logs',
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Security Action Log', style: AppTypography.titleLarge(isDark)),
                          Text(currentLog.action, style: AppTypography.mono(isDark)),
                        ],
                      ),
                    ],
                  ),
                  StatusBadge(label: currentLog.targetType, type: 'pro'),
                ],
              ),
              const SizedBox(height: 24),

              // Audit Event Container
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
                    Text('Action Audit Metadata', style: AppTypography.titleSmall(isDark)),
                    const SizedBox(height: 16),
                    _detailRow('Action Performed', currentLog.action, isDark, isBold: true),
                    _detailRow('Admin User Responsible', currentLog.adminName, isDark),
                    _detailRow('Target Entity Type', currentLog.targetType, isDark),
                    _detailRow('Target Resource ID', currentLog.targetId, isDark, isMono: true),
                    _detailRow('IP Address', currentLog.ipAddress, isDark, isMono: true),
                    _detailRow('Timestamp', currentLog.createdAt, isDark),
                    const SizedBox(height: 24),
                    Text('Full Event Payload Log:', style: AppTypography.labelBold(isDark)),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        currentLog.details ?? 'No additional payload data captured for this event.',
                        style: AppTypography.mono(isDark),
                      ),
                    ),
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
