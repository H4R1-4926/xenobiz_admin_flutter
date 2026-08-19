import 'package:equatable/equatable.dart';

class FeatureFlagModel extends Equatable {
  final String id;
  final String key;
  final String name;
  final String? description;
  final bool isEnabled;
  final String environment;
  final String? updatedBy;
  final String? updatedAt;

  const FeatureFlagModel({
    required this.id,
    required this.key,
    required this.name,
    this.description,
    required this.isEnabled,
    required this.environment,
    this.updatedBy,
    this.updatedAt,
  });

  factory FeatureFlagModel.fromJson(Map<String, dynamic> json) {
    return FeatureFlagModel(
      id: json['id']?.toString() ?? '',
      key: json['key']?.toString() ?? '',
      name: json['name']?.toString() ?? json['key']?.toString() ?? 'Feature Flag',
      description: json['description']?.toString(),
      isEnabled: json['is_enabled'] ?? json['isEnabled'] ?? false,
      environment: json['environment']?.toString() ?? 'production',
      updatedBy: json['updated_by']?.toString() ?? json['updatedBy']?.toString(),
      updatedAt: json['updated_at']?.toString() ?? json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'key': key,
      'name': name,
      'description': description,
      'isEnabled': isEnabled,
      'environment': environment,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt,
    };
  }

  @override
  List<Object?> get props => [id, key, name, isEnabled, environment];
}
