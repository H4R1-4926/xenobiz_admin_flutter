import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/breadcrumb_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../../core/widgets/responsive_data_table.dart';
import '../../../core/widgets/status_badge.dart';
import '../bloc/subscription_bloc.dart';
import '../bloc/subscription_event.dart';
import '../bloc/subscription_state.dart';

class SubscriptionsPage extends StatefulWidget {
  const SubscriptionsPage({super.key});

  @override
  State<SubscriptionsPage> createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> {
  @override
  void initState() {
    super.initState();
    context.read<SubscriptionBloc>().add(SubscriptionsLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionBloc, SubscriptionState>(
        builder: (context, state) {
          if (state is SubscriptionLoading) {
            return const Padding(
              padding: EdgeInsets.all(24),
              child: LoadingSkeleton(height: 380),
            );
          }

          if (state is SubscriptionError) {
            return ErrorStateWidget(
              message: state.message,
              onRetry: () => context.read<SubscriptionBloc>().add(SubscriptionsLoadRequested()),
            );
          }

          if (state is SubscriptionsLoaded) {
            const columns = [
              DataColumnDefinition(label: 'Store Name', width: 220),
              DataColumnDefinition(label: 'Plan Tier'),
              DataColumnDefinition(label: 'Billing Cycle'),
              DataColumnDefinition(label: 'Recurring Amount'),
              DataColumnDefinition(label: 'Start Date'),
              DataColumnDefinition(label: 'End Date'),
              DataColumnDefinition(label: 'Status'),
            ];

            final rows = state.subscriptions.map<List<Widget>>((s) {
              return [
                Text(s.shopName, style: const TextStyle(fontWeight: FontWeight.bold)),
                StatusBadge(label: s.planName, type: 'pro'),
                Text(s.billingCycle),
                Text(Formatters.currency(s.amount), style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(Formatters.date(s.startDate)),
                Text(Formatters.date(s.endDate)),
                StatusBadge(label: s.status),
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
                      BreadcrumbItem(label: 'Shops', route: '/shops'),
                      BreadcrumbItem(label: 'Subscriptions'),
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
