import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/responsive/responsive_breakpoints.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/breadcrumb_widget.dart';
import '../../../core/widgets/chart_card.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../../core/widgets/responsive_data_table.dart';
import '../../../core/widgets/stat_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../shared/providers/theme_provider.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(DashboardLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final deviceType = ResponsiveBreakpoints.getDeviceType(context);

    return BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return _buildLoadingState();
          }

          if (state is DashboardError) {
            return ErrorStateWidget(
              message: state.message,
              onRetry: () => context.read<DashboardBloc>().add(DashboardLoadRequested()),
            );
          }

          if (state is DashboardLoaded) {
            final summary = state.data.summary;
            final trend = state.data.revenueTrend;
            final plans = state.data.planDistribution;
            final recentShops = state.data.recentShops;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BreadcrumbWidget(
                    items: [
                      BreadcrumbItem(label: 'Home', route: '/dashboard'),
                      BreadcrumbItem(label: 'Dashboard Overview'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // KPI Section
                  Text('Key Performance Indicators', style: AppTypography.titleSmall(isDark)),
                  const SizedBox(height: 16),
                  _buildKpiGrid(summary, deviceType, context),
                  const SizedBox(height: 32),

                  // Analytics Charts Section
                  Text('Revenue & Subscription Analytics', style: AppTypography.titleSmall(isDark)),
                  const SizedBox(height: 16),
                  _buildChartsSection(trend, plans, deviceType, isDark),
                  const SizedBox(height: 32),

                  // Recent Shops Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Recent Store Registrations', style: AppTypography.titleSmall(isDark)),
                      TextButton.icon(
                        onPressed: () => context.go('/shops'),
                        icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                        label: const Text('View All Shops'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildRecentShopsTable(recentShops, isDark),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      );
  }

  Widget _buildKpiGrid(
      Map<String, dynamic> summary, DeviceType deviceType, BuildContext context) {
    int crossAxisCount = 5;
    if (deviceType == DeviceType.laptop) crossAxisCount = 3;
    if (deviceType == DeviceType.tablet) crossAxisCount = 2;
    if (deviceType == DeviceType.mobile) crossAxisCount = 1;

    final kpis = [
      {
        'title': 'Total Shops',
        'value': '${summary['totalShops'] ?? 0}',
        'icon': Icons.storefront_rounded,
        'route': '/shops'
      },
      {
        'title': 'Active Shops',
        'value': '${summary['activeShops'] ?? 0}',
        'icon': Icons.check_circle_rounded,
        'route': '/shops'
      },
      {
        'title': 'Inactive Shops',
        'value': '${summary['inactiveShops'] ?? 0}',
        'icon': Icons.pause_circle_rounded,
        'route': '/shops'
      },
      {
        'title': 'Suspended Shops',
        'value': '${summary['suspendedShops'] ?? 0}',
        'icon': Icons.block_rounded,
        'route': '/shops'
      },
      {
        'title': 'Trial Shops',
        'value': '${summary['trialShops'] ?? 0}',
        'icon': Icons.hourglass_empty_rounded,
        'route': '/shops'
      },
      {
        'title': 'Active Subs',
        'value': '${summary['activeSubscriptions'] ?? 0}',
        'icon': Icons.card_membership_rounded,
        'route': '/subscriptions'
      },
      {
        'title': 'Expired Subs',
        'value': '${summary['expiredSubscriptions'] ?? 0}',
        'icon': Icons.event_busy_rounded,
        'route': '/subscriptions'
      },
      {
        'title': 'Total Customers',
        'value': '${summary['totalCustomers'] ?? 0}',
        'icon': Icons.group_rounded,
        'route': '/customers'
      },
      {
        'title': 'Total Revenue',
        'value': Formatters.currency(summary['totalRevenue'] ?? 0),
        'icon': Icons.payments_rounded,
        'route': '/payments'
      },
      {
        'title': 'Monthly Revenue',
        'value': Formatters.currency(summary['monthlyRevenue'] ?? 0),
        'icon': Icons.trending_up_rounded,
        'route': '/payments'
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 120,
      ),
      itemCount: kpis.length,
      itemBuilder: (context, index) {
        final k = kpis[index];
        return StatCard(
          title: k['title'] as String,
          value: k['value'] as String,
          icon: k['icon'] as IconData,
          onTap: () => context.go(k['route'] as String),
        );
      },
    );
  }

  Widget _buildChartsSection(List<Map<String, dynamic>> trend,
      List<Map<String, dynamic>> plans, DeviceType deviceType, bool isDark) {
    final isMobileOrTablet = deviceType == DeviceType.mobile || deviceType == DeviceType.tablet;

    final lineChartWidget = ChartCard(
      title: 'Monthly Revenue Growth (₹)',
      subtitle: 'Trailing 6-month gross revenue',
      chart: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < trend.length) {
                    return Text(
                      trend[index]['month'] ?? '',
                      style: TextStyle(
                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                        fontSize: 11,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                trend.length,
                (i) => FlSpot(i.toDouble(), (trend[i]['revenue'] as num).toDouble()),
              ),
              isCurved: true,
              color: AppColors.primary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.primary.withValues(alpha: 0.12),
              ),
            ),
          ],
        ),
      ),
    );

    final doughnutChartWidget = ChartCard(
      title: 'Subscription Tier Distribution',
      subtitle: 'Breakdown of active stores',
      chart: PieChart(
        PieChartData(
          sectionsSpace: 4,
          centerSpaceRadius: 40,
          sections: plans.map((p) {
            final planName = p['plan'] ?? '';
            Color color = AppColors.info;
            if (planName.toString().contains('Pro')) color = AppColors.primary;
            if (planName.toString().contains('Enterprise')) color = AppColors.badgeEnterpriseText;
            if (planName.toString().contains('Free')) color = const Color(0xFF94A3B8);

            return PieChartSectionData(
              color: color,
              value: (p['count'] as num).toDouble(),
              title: '${p['count']}',
              radius: 35,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          }).toList(),
        ),
      ),
    );

    if (isMobileOrTablet) {
      return Column(
        children: [
          SizedBox(height: 280, child: lineChartWidget),
          const SizedBox(height: 16),
          SizedBox(height: 280, child: doughnutChartWidget),
        ],
      );
    }

    return SizedBox(
      height: 300,
      child: Row(
        children: [
          Expanded(flex: 3, child: lineChartWidget),
          const SizedBox(width: 16),
          Expanded(flex: 2, child: doughnutChartWidget),
        ],
      ),
    );
  }

  Widget _buildRecentShopsTable(List<dynamic> recentShops, bool isDark) {
    const columns = [
      DataColumnDefinition(label: 'Shop Name', width: 220),
      DataColumnDefinition(label: 'Owner'),
      DataColumnDefinition(label: 'Email'),
      DataColumnDefinition(label: 'Plan'),
      DataColumnDefinition(label: 'Status'),
      DataColumnDefinition(label: 'Registered Date'),
    ];

    final rows = recentShops.map<List<Widget>>((s) {
      return [
        Text(s.shopName, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(s.ownerName),
        Text(s.email),
        StatusBadge(label: s.planName, type: 'pro'),
        StatusBadge(label: s.status),
        Text(Formatters.date(s.createdAt)),
      ];
    }).toList();

    return ResponsiveDataTable(columns: columns, rows: rows);
  }

  Widget _buildLoadingState() {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          LoadingSkeleton(height: 100),
          SizedBox(height: 24),
          LoadingSkeleton(height: 300),
          SizedBox(height: 24),
          LoadingSkeleton(height: 200),
        ],
      ),
    );
  }
}
