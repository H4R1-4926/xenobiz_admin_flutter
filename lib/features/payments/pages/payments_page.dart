import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/breadcrumb_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../../core/widgets/responsive_data_table.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../shared/providers/theme_provider.dart';
import '../bloc/payment_bloc.dart';
import '../bloc/payment_event.dart';
import '../bloc/payment_state.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({super.key});

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  @override
  void initState() {
    super.initState();
    context.read<PaymentBloc>().add(PaymentsLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return BlocBuilder<PaymentBloc, PaymentState>(
        builder: (context, state) {
          if (state is PaymentLoading) {
            return const Padding(
              padding: EdgeInsets.all(24),
              child: LoadingSkeleton(height: 380),
            );
          }

          if (state is PaymentError) {
            return ErrorStateWidget(
              message: state.message,
              onRetry: () => context.read<PaymentBloc>().add(PaymentsLoadRequested()),
            );
          }

          if (state is PaymentsLoaded) {
            const columns = [
              DataColumnDefinition(label: 'Transaction ID', width: 180),
              DataColumnDefinition(label: 'Store Name', width: 200),
              DataColumnDefinition(label: 'Plan'),
              DataColumnDefinition(label: 'Amount'),
              DataColumnDefinition(label: 'Provider'),
              DataColumnDefinition(label: 'Status'),
              DataColumnDefinition(label: 'Paid At'),
              DataColumnDefinition(label: 'Action', alignment: Alignment.centerRight),
            ];

            final rows = state.payments.map<List<Widget>>((p) {
              return [
                Text(p.transactionId, style: AppTypography.mono(isDark)),
                Text(p.shopName, style: const TextStyle(fontWeight: FontWeight.bold)),
                StatusBadge(label: p.planName, type: 'pro'),
                Text(Formatters.currency(p.amount), style: const TextStyle(fontWeight: FontWeight.bold)),
                StatusBadge(label: p.provider.toUpperCase(), type: 'pro'),
                StatusBadge(label: p.status),
                Text(p.paidAt),
                IconButton(
                  icon: const Icon(Icons.receipt_long_rounded, size: 18),
                  onPressed: () => context.go('/payments/${p.id}'),
                  tooltip: 'View Payment Receipt Page',
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
                      BreadcrumbItem(label: 'Payments', route: '/payments'),
                      BreadcrumbItem(label: 'Transactions'),
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
