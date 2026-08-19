import 'package:equatable/equatable.dart';

class PlanModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String billingCycle;
  final int subscriberCount;
  final bool isActive;
  final List<String> features;

  const PlanModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.billingCycle,
    required this.subscriberCount,
    required this.isActive,
    required this.features,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Plan',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      billingCycle: json['billing_cycle'] ?? json['billingCycle'] ?? 'monthly',
      subscriberCount: json['subscriber_count'] ?? json['subscriberCount'] ?? 0,
      isActive: json['is_active'] == true || json['isActive'] == 1 || json['is_active'] == 1,
      features: (json['features'] is List)
          ? List<String>.from(json['features'])
          : ['All Core Features', 'Cloud Sync', '24/7 Support'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'billing_cycle': billingCycle,
      'subscriber_count': subscriberCount,
      'is_active': isActive,
      'features': features,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        billingCycle,
        subscriberCount,
        isActive,
        features,
      ];
}
