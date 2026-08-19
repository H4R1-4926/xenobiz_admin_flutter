import 'package:equatable/equatable.dart';

class AuditLogModel extends Equatable {
  final String id;
  final String? adminId;
  final String adminName;
  final String action;
  final String? targetType;
  final String? targetId;
  final Map<String, dynamic>? details;
  final String? ipAddress;
  final String createdAt;

  const AuditLogModel({
    required this.id,
    this.adminId,
    required this.adminName,
    required this.action,
    this.targetType,
    this.targetId,
    this.details,
    this.ipAddress,
    required this.createdAt,
  });

  factory AuditLogModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? detailsMap;
    if (json['details'] is Map) {
      detailsMap = Map<String, dynamic>.from(json['details'] as Map);
    }

    return AuditLogModel(
      id: json['id']?.toString() ?? '',
      adminId: json['admin_id']?.toString() ?? json['adminId']?.toString(),
      adminName: json['admin_name']?.toString() ?? json['adminName']?.toString() ?? 'System Admin',
      action: json['action']?.toString() ?? 'ACTION',
      targetType: json['target_type']?.toString() ?? json['targetType']?.toString(),
      targetId: json['target_id']?.toString() ?? json['targetId']?.toString(),
      details: detailsMap,
      ipAddress: json['ip_address']?.toString() ?? json['ipAddress']?.toString() ?? '127.0.0.1',
      createdAt: json['created_at']?.toString() ?? json['createdAt']?.toString() ?? DateTime.now().toIso8601String(),
    );
  }

  @override
  List<Object?> get props => [id, adminId, adminName, action, targetType, targetId, createdAt];
}
