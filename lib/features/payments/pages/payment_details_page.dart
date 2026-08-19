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
import '../../../shared/models/payment_model.dart';
import '../../../shared/providers/theme_provider.dart';
import '../bloc/payment_bloc.dart';
import '../bloc/payment_event.dart';
import '../bloc/payment_state.dart';

class PaymentDetailsPage extends StatefulWidget {
  final String paymentId;

  const PaymentDetailsPage({
    super.key,
    required this.paymentId,
  });

  @override
  State<PaymentDetailsPage> createState() => _PaymentDetailsPageState();
}

class _PaymentDetailsPageState extends State<PaymentDetailsPage> {
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

        PaymentModel? payment;
        if (state is PaymentsLoaded) {
          try {
            payment = state.payments.firstWhere((p) => p.id == widget.paymentId || p.transactionId == widget.paymentId);
          } catch (_) {
            if (state.payments.isNotEmpty) payment = state.payments.first;
          }
        }

        if (payment == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Payment transaction record not found.'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => context.go('/payments'),
                  child: const Text('Back to Payments'),
                ),
              ],
            ),
          );
        }

        final currentPayment = payment;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumb Navigation
              BreadcrumbWidget(
                items: [
                  const BreadcrumbItem(label: 'Home', route: '/dashboard'),
                  const BreadcrumbItem(label: 'Payments', route: '/payments'),
                  BreadcrumbItem(label: currentPayment.transactionId),
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
                        onPressed: () => context.go('/payments'),
                        icon: const Icon(Icons.arrow_back_rounded),
                        tooltip: 'Back to Revenue Transactions',
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Transaction Receipt', style: AppTypography.titleLarge(isDark)),
                          Text(currentPayment.transactionId, style: AppTypography.mono(isDark)),
                        ],
                      ),
                    ],
                  ),
                  StatusBadge(label: currentPayment.status),
                ],
              ),
              const SizedBox(height: 24),

              // Payment Receipt Card
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
                    Text('Payment Transaction Details', style: AppTypography.titleSmall(isDark)),
                    const SizedBox(height: 16),
                    _detailRow('Transaction ID / Ref', currentPayment.transactionId, isDark, isMono: true),
                    _detailRow('Merchant Store Name', currentPayment.shopName, isDark, isBold: true),
                    _detailRow('Subscribed Plan Tier', currentPayment.planName, isDark),
                    _detailRow('Total Amount Paid', Formatters.currency(currentPayment.amount), isDark, isBold: true),
                    _detailRow('Payment Provider Gateway', currentPayment.provider.toUpperCase(), isDark),
                    _detailRow('Payment Status', currentPayment.status.toUpperCase(), isDark),
                    _detailRow('Timestamp of Charge', currentPayment.paidAt, isDark),
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
