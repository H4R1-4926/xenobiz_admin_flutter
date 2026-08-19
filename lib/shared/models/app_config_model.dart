import 'package:equatable/equatable.dart';

class AppConfigModel extends Equatable {
  final String appName;
  final String minAppVersion;
  final String supportEmail;
  final bool maintenanceMode;
  final bool registrationEnabled;
  final int defaultTrialDays;

  const AppConfigModel({
    required this.appName,
    required this.minAppVersion,
    required this.supportEmail,
    required this.maintenanceMode,
    required this.registrationEnabled,
    required this.defaultTrialDays,
  });

  factory AppConfigModel.fromJson(Map<String, dynamic> json) {
    final general = json['general'] as Map<String, dynamic>? ?? json;
    return AppConfigModel(
      appName: general['app_name'] ?? 'XenoBiz Business Manager',
      minAppVersion: general['min_app_version'] ?? '1.2.0',
      supportEmail: general['support_email'] ?? 'support@xenobiz.com',
      maintenanceMode: general['maintenance_mode'] == true,
      registrationEnabled: general['registration_enabled'] != false,
      defaultTrialDays: general['default_trial_days'] ?? 14,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'app_name': appName,
      'min_app_version': minAppVersion,
      'support_email': supportEmail,
      'maintenance_mode': maintenanceMode,
      'registration_enabled': registrationEnabled,
      'default_trial_days': defaultTrialDays,
    };
  }

  @override
  List<Object?> get props => [
        appName,
        minAppVersion,
        supportEmail,
        maintenanceMode,
        registrationEnabled,
        defaultTrialDays,
      ];
}
