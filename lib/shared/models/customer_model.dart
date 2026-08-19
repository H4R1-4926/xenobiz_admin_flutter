import 'package:equatable/equatable.dart';

class CustomerModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String shopName;
  final String city;
  final String state;
  final double totalSpent;
  final String status;
  final String createdAt;

  const CustomerModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.shopName,
    required this.city,
    required this.state,
    required this.totalSpent,
    required this.status,
    required this.createdAt,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Customer',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      shopName: json['shop_name'] ?? json['shopName'] ?? 'Standalone',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      totalSpent: (json['total_spent'] ?? json['totalSpent'] ?? 0).toDouble(),
      status: (json['status'] ?? 'active').toString().toLowerCase(),
      createdAt: json['created_at'] ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'shop_name': shopName,
      'city': city,
      'state': state,
      'total_spent': totalSpent,
      'status': status,
      'created_at': createdAt,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        shopName,
        city,
        state,
        totalSpent,
        status,
        createdAt,
      ];
}
