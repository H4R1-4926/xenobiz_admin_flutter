import 'package:equatable/equatable.dart';

class PlanModel extends Equatable {
  final String id;
  final String planId;
  final String name;
  final num price;
  final String currency;
  final String billingPeriod;
  final String? description;
  final List<String> features;
  final Map<String, dynamic> limits;
  final bool isActive;
  final String? createdAt;

  const PlanModel({
    required this.id,
    required this.planId,
    required this.name,
    required this.price,
    this.currency = 'INR',
    required this.billingPeriod,
    this.description,
    this.features = const [],
    this.limits = const {},
    this.isActive = true,
    this.createdAt,
  });

  static num _parseNum(dynamic val) {
    if (val is num) return val;
    if (val != null) {
      final parsed = num.tryParse(val.toString());
      if (parsed != null) return parsed;
    }
    return 0;
  }

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    List<String> parsedFeatures = [];
    if (json['features'] is List) {
      parsedFeatures = (json['features'] as List).map((e) => e.toString()).toList();
    }

    Map<String, dynamic> parsedLimits = {};
    if (json['limits'] is Map) {
      parsedLimits = Map<String, dynamic>.from(json['limits'] as Map);
    }

    return PlanModel(
      id: json['id']?.toString() ?? '',
      planId: json['planId']?.toString() ?? json['plan_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? json['planName']?.toString() ?? 'Subscription Plan',
      price: _parseNum(json['price']),
      currency: json['currency']?.toString() ?? 'INR',
      billingPeriod: json['billingPeriod']?.toString() ?? json['billing_period']?.toString() ?? json['period']?.toString() ?? 'monthly',
      description: json['description']?.toString(),
      features: parsedFeatures,
      limits: parsedLimits,
      isActive: json['isActive'] == true || json['is_active'] == true || json['status']?.toString().toLowerCase() == 'active',
      createdAt: json['createdAt']?.toString() ?? json['created_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'planId': planId,
      'name': name,
      'price': price,
      'currency': currency,
      'billingPeriod': billingPeriod,
      'description': description,
      'features': features,
      'limits': limits,
      'isActive': isActive,
      'createdAt': createdAt,
    };
  }

  @override
  List<Object?> get props => [
        id,
        planId,
        name,
        price,
        billingPeriod,
        isActive,
      ];
}
