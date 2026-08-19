import 'package:equatable/equatable.dart';

class AdminUserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String loginId;
  final String status;
  final String role;
  final String? createdAt;
  final String? lastLoginAt;

  const AdminUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.loginId,
    required this.status,
    required this.role,
    this.createdAt,
    this.lastLoginAt,
  });

  bool get isSuperAdmin => role.toUpperCase() == 'SUPER_ADMIN' || role.toUpperCase() == 'ADMIN';
  bool get isReadOnly => role.toUpperCase() == 'READ_ONLY';
  bool get isActive => status.toLowerCase() == 'active';

  factory AdminUserModel.fromJson(Map<String, dynamic> json) {
    return AdminUserModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? json['fullName']?.toString() ?? 'Admin User',
      email: json['email']?.toString() ?? '',
      loginId: json['login_id']?.toString() ?? json['loginId']?.toString() ?? json['email']?.toString() ?? '',
      status: json['status']?.toString() ?? json['accountStatus']?.toString() ?? 'active',
      role: json['role']?.toString() ?? 'ADMIN',
      createdAt: json['created_at']?.toString() ?? json['createdAt']?.toString(),
      lastLoginAt: json['last_login_at']?.toString() ?? json['lastLoginAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'loginId': loginId,
      'status': status,
      'role': role,
      'createdAt': createdAt,
      'lastLoginAt': lastLoginAt,
    };
  }

  @override
  List<Object?> get props => [id, name, email, loginId, status, role];
}
