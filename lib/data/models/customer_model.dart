import 'package:equatable/equatable.dart';

class CustomerModel extends Equatable {
  final String id;
  final String? shopId;
  final String? shopName;
  final String name;
  final String? email;
  final String? phone;
  final String? city;
  final String? state;
  final String? country;
  final String status;
  final double totalSpent;
  final int totalPurchases;
  final String? createdAt;

  const CustomerModel({
    required this.id,
    this.shopId,
    this.shopName,
    required this.name,
    this.email,
    this.phone,
    this.city,
    this.state,
    this.country,
    required this.status,
    required this.totalSpent,
    required this.totalPurchases,
    this.createdAt,
  });

  bool get isActive => status.toLowerCase() == 'active';

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id']?.toString() ?? '',
      shopId: json['shop_id']?.toString() ?? json['shopId']?.toString(),
      shopName: json['shop_name']?.toString() ?? json['shopName']?.toString() ?? 'Standalone Customer',
      name: json['name']?.toString() ?? 'Customer',
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      city: json['city']?.toString(),
      state: json['state']?.toString(),
      country: json['country']?.toString() ?? 'India',
      status: json['status']?.toString() ?? 'active',
      totalSpent: (json['total_spent'] ?? json['totalSpent'] ?? 0.0).toDouble(),
      totalPurchases: json['total_purchases'] ?? json['totalPurchases'] ?? 0,
      createdAt: json['created_at']?.toString() ?? json['createdAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shopId': shopId,
      'shopName': shopName,
      'name': name,
      'email': email,
      'phone': phone,
      'city': city,
      'state': state,
      'country': country,
      'status': status,
      'totalSpent': totalSpent,
      'totalPurchases': totalPurchases,
      'createdAt': createdAt,
    };
  }

  @override
  List<Object?> get props => [id, shopId, name, email, phone, status, totalSpent, totalPurchases];
}
