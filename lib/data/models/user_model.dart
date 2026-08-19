import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String loginId;
  final String fullName;
  final String email;
  final String? phone;
  final String role;
  final String accountStatus;
  final String? companyId;
  final String? companyName;
  final String? planName;
  final String? subscriptionStatus;
  final String? createdAt;
  final String? lastLogin;
  final String? expiryDate;

  const UserModel({
    required this.id,
    required this.loginId,
    required this.fullName,
    required this.email,
    this.phone,
    required this.role,
    required this.accountStatus,
    this.companyId,
    this.companyName,
    this.planName,
    this.subscriptionStatus,
    this.createdAt,
    this.lastLogin,
    this.expiryDate,
  });

  bool get isAdmin => role.toUpperCase() == 'ADMIN';
  bool get isActive => accountStatus.toLowerCase() == 'active';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final companyMap = json['company'] is Map ? json['company'] as Map<String, dynamic> : null;
    final subMap = json['subscription'] is Map ? json['subscription'] as Map<String, dynamic> : null;

    return UserModel(
      id: json['id']?.toString() ?? '',
      loginId: json['loginId']?.toString() ?? json['username']?.toString() ?? json['login_id']?.toString() ?? json['email']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? json['full_name']?.toString() ?? json['name']?.toString() ?? 'Account User',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      role: json['role']?.toString() ?? 'USER',
      accountStatus: json['accountStatus']?.toString() ?? json['account_status']?.toString() ?? json['status']?.toString() ?? 'active',
      companyId: json['companyId']?.toString() ?? json['company_id']?.toString() ?? companyMap?['id']?.toString(),
      companyName: json['companyName']?.toString() ?? json['company_name']?.toString() ?? companyMap?['name']?.toString() ?? companyMap?['shopName']?.toString(),
      planName: json['planName']?.toString() ?? json['plan_name']?.toString() ?? subMap?['planName']?.toString() ?? subMap?['plan_name']?.toString(),
      subscriptionStatus: json['subscriptionStatus']?.toString() ?? json['subscription_status']?.toString() ?? subMap?['status']?.toString(),
      createdAt: json['createdAt']?.toString() ?? json['created_at']?.toString(),
      lastLogin: json['lastLogin']?.toString() ?? json['last_login']?.toString(),
      expiryDate: json['expiryDate']?.toString() ?? json['expiry_date']?.toString() ?? subMap?['expiryDate']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'loginId': loginId,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'role': role,
      'accountStatus': accountStatus,
      'companyId': companyId,
      'companyName': companyName,
      'planName': planName,
      'subscriptionStatus': subscriptionStatus,
      'createdAt': createdAt,
      'lastLogin': lastLogin,
      'expiryDate': expiryDate,
    };
  }

  @override
  List<Object?> get props => [
        id,
        loginId,
        email,
        role,
        accountStatus,
        companyId,
        companyName,
        planName,
        subscriptionStatus,
      ];
}
