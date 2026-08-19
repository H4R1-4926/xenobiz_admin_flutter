import 'package:equatable/equatable.dart';

class FeatureFlagModel extends Equatable {
  final String key;
  final String name;
  final String description;
  final String environment;
  final bool isEnabled;

  const FeatureFlagModel({
    required this.key,
    required this.name,
    required this.description,
    required this.environment,
    required this.isEnabled,
  });

  factory FeatureFlagModel.fromJson(Map<String, dynamic> json) {
    return FeatureFlagModel(
      key: json['key'] ?? '',
      name: json['name'] ?? json['key'] ?? 'Flag',
      description: json['description'] ?? '',
      environment: json['environment'] ?? 'production',
      isEnabled: json['is_enabled'] == true || json['isEnabled'] == true || json['is_enabled'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'name': name,
      'description': description,
      'environment': environment,
      'is_enabled': isEnabled,
    };
  }

  FeatureFlagModel copyWith({bool? isEnabled}) {
    return FeatureFlagModel(
      key: key,
      name: name,
      description: description,
      environment: environment,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  @override
  List<Object?> get props => [key, name, description, environment, isEnabled];
}
