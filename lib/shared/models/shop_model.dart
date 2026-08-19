import 'package:equatable/equatable.dart';

class ShopModel extends Equatable {
  final String id;
  final String shopName;
  final String ownerName;
  final String email;
  final String phone;
  final String loginId;
  final String planName;
  final String status;
  final String createdAt;
  final String? address;
  final String? city;
  final String? state;

  const ShopModel({
    required this.id,
    required this.shopName,
    required this.ownerName,
    required this.email,
    required this.phone,
    required this.loginId,
    required this.planName,
    required this.status,
    required this.createdAt,
    this.address,
    this.city,
    this.state,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      id: json['id']?.toString() ?? '',
      shopName: json['shop_name'] ?? json['name'] ?? 'Unnamed Shop',
      ownerName: json['owner_name'] ?? json['fullName'] ?? json['owner'] ?? 'N/A',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      loginId: json['login_id'] ?? json['loginId'] ?? '',
      planName: json['plan_name'] ?? json['plan'] ?? 'Pro Plan',
      status: (json['status'] ?? 'active').toString().toLowerCase(),
      createdAt: json['created_at'] ?? DateTime.now().toIso8601String(),
      address: json['address'],
      city: json['city'],
      state: json['state'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shop_name': shopName,
      'owner_name': ownerName,
      'email': email,
      'phone': phone,
      'login_id': loginId,
      'plan_name': planName,
      'status': status,
      'created_at': createdAt,
      'address': address,
      'city': city,
      'state': state,
    };
  }

  @override
  List<Object?> get props => [
        id,
        shopName,
        ownerName,
        email,
        phone,
        loginId,
        planName,
        status,
        createdAt,
        address,
        city,
        state,
      ];
}
