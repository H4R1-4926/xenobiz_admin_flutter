import 'package:equatable/equatable.dart';

class AdminUserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String loginId;
  final String role;
  final String status;
  final String? lastLogin;

  const AdminUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.loginId,
    required this.role,
    required this.status,
    this.lastLogin,
  });

  factory AdminUserModel.fromJson(Map<String, dynamic> json) {
    return AdminUserModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? json['fullName'] ?? 'Admin',
      email: json['email'] ?? '',
      loginId: json['login_id'] ?? json['loginId'] ?? '',
      role: json['role'] ?? 'ADMIN',
      status: (json['status'] ?? 'active').toString().toLowerCase(),
      lastLogin: json['last_login'] ?? json['lastLogin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'login_id': loginId,
      'role': role,
      'status': status,
      'last_login': lastLogin,
    };
  }

  @override
  List<Object?> get props => [id, name, email, loginId, role, status, lastLogin];
}
