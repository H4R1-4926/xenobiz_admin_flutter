import 'package:equatable/equatable.dart';

class PaymentModel extends Equatable {
  final String id;
  final String transactionId;
  final String shopName;
  final String planName;
  final double amount;
  final String provider;
  final String status;
  final String paidAt;

  const PaymentModel({
    required this.id,
    required this.transactionId,
    required this.shopName,
    required this.planName,
    required this.amount,
    required this.provider,
    required this.status,
    required this.paidAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id']?.toString() ?? '',
      transactionId: json['transaction_id'] ?? json['id'] ?? '',
      shopName: json['shop_name'] ?? json['shopId'] ?? 'Shop',
      planName: json['plan_name'] ?? json['planId'] ?? 'Pro Plan',
      amount: (json['amount'] ?? 0).toDouble(),
      provider: json['provider'] ?? 'razorpay',
      status: (json['status'] ?? 'completed').toString().toLowerCase(),
      paidAt: json['paid_at'] ?? json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transaction_id': transactionId,
      'shop_name': shopName,
      'plan_name': planName,
      'amount': amount,
      'provider': provider,
      'status': status,
      'paid_at': paidAt,
    };
  }

  @override
  List<Object?> get props => [
        id,
        transactionId,
        shopName,
        planName,
        amount,
        provider,
        status,
        paidAt,
      ];
}
