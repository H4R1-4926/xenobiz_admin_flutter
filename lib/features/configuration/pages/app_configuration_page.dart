import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/breadcrumb_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../../shared/providers/theme_provider.dart';
import '../bloc/config_bloc.dart';
import '../bloc/config_event.dart';
import '../bloc/config_state.dart';

class AppConfigurationPage extends StatefulWidget {
  const AppConfigurationPage({super.key});

  @override
  State<AppConfigurationPage> createState() => _AppConfigurationPageState();
}

class _AppConfigurationPageState extends State<AppConfigurationPage> {
  final _appNameController = TextEditingController();
  final _minVersionController = TextEditingController();
  final _supportEmailController = TextEditingController();
  bool _maintenanceMode = false;
  bool _registrationEnabled = true;

  @override
  void initState() {
    super.initState();
    context.read<ConfigBloc>().add(ConfigLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return BlocConsumer<ConfigBloc, ConfigState>(
        listener: (context, state) {
          if (state is ConfigLoaded) {
            _appNameController.text = state.config.appName;
            _minVersionController.text = state.config.minAppVersion;
            _supportEmailController.text = state.config.supportEmail;
            _maintenanceMode = state.config.maintenanceMode;
            _registrationEnabled = state.config.registrationEnabled;
          }
        },
        builder: (context, state) {
          if (state is ConfigLoading) {
            return const Padding(
              padding: EdgeInsets.all(24),
              child: LoadingSkeleton(height: 400),
            );
          }

          if (state is ConfigError) {
            return ErrorStateWidget(
              message: state.message,
              onRetry: () => context.read<ConfigBloc>().add(ConfigLoadRequested()),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: DefaultTabController(
              length: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BreadcrumbWidget(
                    items: [
                      BreadcrumbItem(label: 'Home', route: '/dashboard'),
                      BreadcrumbItem(label: 'Configuration', route: '/configuration'),
                      BreadcrumbItem(label: 'App Settings'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TabBar(
                    isScrollable: true,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: isDark ? Colors.grey : Colors.black54,
                    tabs: const [
                      Tab(text: 'General'),
                      Tab(text: 'Registration'),
                      Tab(text: 'Subscription'),
                      Tab(text: 'Payments'),
                      Tab(text: 'Notifications'),
                      Tab(text: 'System'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 520,
                    child: TabBarView(
                      children: [
                        // General Tab
                        _buildSettingsCard(
                          isDark,
                          title: 'General Platform Branding & Support',
                          children: [
                            TextField(
                              controller: _appNameController,
                              decoration: const InputDecoration(labelText: 'Platform Application Name'),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _minVersionController,
                              decoration: const InputDecoration(labelText: 'Minimum Required Mobile App Version'),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _supportEmailController,
                              decoration: const InputDecoration(labelText: 'Support Email Address'),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () {
                                context.read<ConfigBloc>().add(
                                      ConfigCategoryUpdateRequested(
                                        category: 'general',
                                        payload: {
                                          'app_name': _appNameController.text.trim(),
                                          'min_app_version': _minVersionController.text.trim(),
                                          'support_email': _supportEmailController.text.trim(),
                                        },
                                      ),
                                    );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('General configuration saved successfully!')),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                              ),
                              child: const Text('SAVE GENERAL CONFIGURATION'),
                            ),
                          ],
                        ),
                        // Registration Tab
                        _buildSettingsCard(
                          isDark,
                          title: 'Merchant Registration Controls',
                          children: [
                            SwitchListTile(
                              title: const Text('Allow New Merchant Account Registration'),
                              subtitle: const Text('Toggle open public registration for new retail shops.'),
                              value: _registrationEnabled,
                              onChanged: (val) => setState(() => _registrationEnabled = val),
                            ),
                            const SizedBox(height: 16),
                            const TextField(
                              decoration: InputDecoration(labelText: 'Default Free Trial Duration (Days)', hintText: '14'),
                            ),
                          ],
                        ),
                        // Subscription Tab
                        _buildSettingsCard(
                          isDark,
                          title: 'Subscription Grace Period & Reminders',
                          children: const [
                            TextField(
                              decoration: InputDecoration(labelText: 'Expired Subscription Grace Period (Days)', hintText: '7'),
                            ),
                            SizedBox(height: 16),
                            TextField(
                              decoration: InputDecoration(labelText: 'Renewal Reminder Lead Time (Days)', hintText: '5'),
                            ),
                          ],
                        ),
                        // Payments Tab
                        _buildSettingsCard(
                          isDark,
                          title: 'Gateway Provider Integrations',
                          children: const [
                            TextField(
                              decoration: InputDecoration(labelText: 'Razorpay Live Key ID'),
                            ),
                            SizedBox(height: 16),
                            TextField(
                              decoration: InputDecoration(labelText: 'Stripe Public Publishable Key'),
                            ),
                          ],
                        ),
                        // Notifications Tab
                        _buildSettingsCard(
                          isDark,
                          title: 'System Notification Gateways',
                          children: const [
                            TextField(
                              decoration: InputDecoration(labelText: 'SendGrid SMTP Host'),
                            ),
                            SizedBox(height: 16),
                            TextField(
                              decoration: InputDecoration(labelText: 'Twilio SMS Gateway Account SID'),
                            ),
                          ],
                        ),
                        // System Tab
                        _buildSettingsCard(
                          isDark,
                          title: 'System Maintenance & Safeguards',
                          children: [
                            SwitchListTile(
                              title: const Text('Platform Maintenance Mode'),
                              subtitle: const Text('Temporarily block merchant login for scheduled database updates.'),
                              value: _maintenanceMode,
                              activeTrackColor: AppColors.error,
                              onChanged: (val) => setState(() => _maintenanceMode = val),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
  }

  Widget _buildSettingsCard(bool isDark, {required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: AppRadius.borderRadiusMd,
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.titleSmall(isDark)),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }
}
