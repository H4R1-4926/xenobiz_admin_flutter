import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String role;
  final String? loginId;
  final String? avatarUrl;

  const UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    this.loginId,
    this.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? json['full_name'] ?? json['name'] ?? 'Admin User',
      role: json['role'] ?? 'SUPER_ADMIN',
      loginId: json['loginId'] ?? json['login_id'],
      avatarUrl: json['avatarUrl'] ?? json['avatar_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'role': role,
      'loginId': loginId,
      'avatarUrl': avatarUrl,
    };
  }

  @override
  List<Object?> get props => [id, email, fullName, role, loginId, avatarUrl];
}
