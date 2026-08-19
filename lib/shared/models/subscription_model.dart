import 'package:equatable/equatable.dart';

class SubscriptionModel extends Equatable {
  final String id;
  final String shopName;
  final String planName;
  final String billingCycle;
  final double amount;
  final String startDate;
  final String endDate;
  final String status;

  const SubscriptionModel({
    required this.id,
    required this.shopName,
    required this.planName,
    required this.billingCycle,
    required this.amount,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id']?.toString() ?? '',
      shopName: json['shop_name'] ?? json['shopId'] ?? 'Shop',
      planName: json['plan_name'] ?? json['planId'] ?? 'Pro Plan',
      billingCycle: json['billing_cycle'] ?? json['billingCycle'] ?? 'Monthly',
      amount: (json['amount'] ?? 0).toDouble(),
      startDate: json['start_date'] ?? json['startDate'] ?? '',
      endDate: json['end_date'] ?? json['endDate'] ?? '',
      status: (json['status'] ?? 'active').toString().toLowerCase(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shop_name': shopName,
      'plan_name': planName,
      'billing_cycle': billingCycle,
      'amount': amount,
      'start_date': startDate,
      'end_date': endDate,
      'status': status,
    };
  }

  @override
  List<Object?> get props => [
        id,
        shopName,
        planName,
        billingCycle,
        amount,
        startDate,
        endDate,
        status,
      ];
}
