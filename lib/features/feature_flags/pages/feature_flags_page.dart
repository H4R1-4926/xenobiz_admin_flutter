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
import '../bloc/feature_flags_bloc.dart';
import '../bloc/feature_flags_event.dart';
import '../bloc/feature_flags_state.dart';

class FeatureFlagsPage extends StatefulWidget {
  const FeatureFlagsPage({super.key});

  @override
  State<FeatureFlagsPage> createState() => _FeatureFlagsPageState();
}

class _FeatureFlagsPageState extends State<FeatureFlagsPage> {
  @override
  void initState() {
    super.initState();
    context.read<FeatureFlagsBloc>().add(FeatureFlagsLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return BlocBuilder<FeatureFlagsBloc, FeatureFlagsState>(
        builder: (context, state) {
          if (state is FeatureFlagsLoading) {
            return const Padding(
              padding: EdgeInsets.all(24),
              child: LoadingSkeleton(height: 380),
            );
          }

          if (state is FeatureFlagsError) {
            return ErrorStateWidget(
              message: state.message,
              onRetry: () => context.read<FeatureFlagsBloc>().add(FeatureFlagsLoadRequested()),
            );
          }

          if (state is FeatureFlagsLoaded) {
            const columns = [
              DataColumnDefinition(label: 'Feature Name', width: 220),
              DataColumnDefinition(label: 'Feature Key', width: 240),
              DataColumnDefinition(label: 'Environment'),
              DataColumnDefinition(label: 'Description', width: 300),
              DataColumnDefinition(label: 'Status'),
              DataColumnDefinition(label: 'Toggle', alignment: Alignment.centerRight),
            ];

            final rows = state.flags.map<List<Widget>>((f) {
              return [
                Text(f.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(f.key, style: AppTypography.mono(isDark)),
                StatusBadge(label: f.environment.toUpperCase(), type: 'pro'),
                Text(f.description, style: AppTypography.bodyMedium(isDark)),
                StatusBadge(
                  label: f.isEnabled ? 'ENABLED' : 'DISABLED',
                  type: f.isEnabled ? 'active' : 'inactive',
                ),
                Switch(
                  value: f.isEnabled,
                  activeTrackColor: AppColors.primary,
                  onChanged: (val) {
                    context.read<FeatureFlagsBloc>().add(FeatureFlagToggleRequested(f.key));
                  },
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
                      BreadcrumbItem(label: 'Feature Flags', route: '/feature-flags'),
                      BreadcrumbItem(label: 'Rollout Toggles'),
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
