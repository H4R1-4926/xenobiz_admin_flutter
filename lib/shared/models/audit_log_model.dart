import 'package:equatable/equatable.dart';

class AuditLogModel extends Equatable {
  final String id;
  final String action;
  final String adminName;
  final String targetType;
  final String targetId;
  final String ipAddress;
  final String createdAt;
  final String? details;

  const AuditLogModel({
    required this.id,
    required this.action,
    required this.adminName,
    required this.targetType,
    required this.targetId,
    required this.ipAddress,
    required this.createdAt,
    this.details,
  });

  factory AuditLogModel.fromJson(Map<String, dynamic> json) {
    return AuditLogModel(
      id: json['id']?.toString() ?? '',
      action: json['action'] ?? 'ACTION',
      adminName: json['admin_name'] ?? json['adminName'] ?? 'Admin',
      targetType: json['target_type'] ?? json['targetType'] ?? 'SYSTEM',
      targetId: json['target_id'] ?? json['targetId'] ?? 'N/A',
      ipAddress: json['ip_address'] ?? json['ipAddress'] ?? '127.0.0.1',
      createdAt: json['created_at'] ?? json['createdAt'] ?? DateTime.now().toIso8601String(),
      details: json['details']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'action': action,
      'admin_name': adminName,
      'target_type': targetType,
      'target_id': targetId,
      'ip_address': ipAddress,
      'created_at': createdAt,
      'details': details,
    };
  }

  @override
  List<Object?> get props => [
        id,
        action,
        adminName,
        targetType,
        targetId,
        ipAddress,
        createdAt,
        details,
      ];
}
