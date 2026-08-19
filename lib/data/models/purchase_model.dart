import 'package:equatable/equatable.dart';

class PurchaseModel extends Equatable {
  final String id;
  final String? accountId;
  final String? accountEmail;
  final String? companyId;
  final String? companyName;
  final String? planId;
  final String planName;
  final num amount;
  final String currency;
  final String purchaseDate;
  final String status;
  final String? subscriptionPeriod;
  final String? paymentProvider;
  final String? paymentReference;

  const PurchaseModel({
    required this.id,
    this.accountId,
    this.accountEmail,
    this.companyId,
    this.companyName,
    this.planId,
    required this.planName,
    required this.amount,
    this.currency = 'INR',
    required this.purchaseDate,
    required this.status,
    this.subscriptionPeriod,
    this.paymentProvider,
    this.paymentReference,
  });

  bool get isCompleted => status.toLowerCase() == 'completed' || status.toLowerCase() == 'success' || status.toLowerCase() == 'paid';
  bool get isFailed => status.toLowerCase() == 'failed' || status.toLowerCase() == 'declined';
  bool get isRefunded => status.toLowerCase() == 'refunded';

  static num _parseNum(dynamic val) {
    if (val is num) return val;
    if (val != null) {
      final parsed = num.tryParse(val.toString());
      if (parsed != null) return parsed;
    }
    return 0;
  }

  factory PurchaseModel.fromJson(Map<String, dynamic> json) {
    final accountMap = json['account'] is Map ? json['account'] as Map<String, dynamic> : null;
    final companyMap = json['company'] is Map ? json['company'] as Map<String, dynamic> : null;
    final planMap = json['plan'] is Map ? json['plan'] as Map<String, dynamic> : null;

    return PurchaseModel(
      id: json['id']?.toString() ?? json['purchaseId']?.toString() ?? json['purchase_id']?.toString() ?? json['reference']?.toString() ?? '',
      accountId: json['accountId']?.toString() ?? json['account_id']?.toString() ?? accountMap?['id']?.toString(),
      accountEmail: json['accountEmail']?.toString() ?? json['account_email']?.toString() ?? accountMap?['email']?.toString(),
      companyId: json['companyId']?.toString() ?? json['company_id']?.toString() ?? companyMap?['id']?.toString(),
      companyName: json['companyName']?.toString() ?? json['company_name']?.toString() ?? companyMap?['name']?.toString(),
      planId: json['planId']?.toString() ?? json['plan_id']?.toString() ?? planMap?['id']?.toString(),
      planName: json['planName']?.toString() ?? json['plan_name']?.toString() ?? planMap?['name']?.toString() ?? 'Plan Purchase',
      amount: _parseNum(json['amount'] ?? json['price']),
      currency: json['currency']?.toString() ?? 'INR',
      purchaseDate: json['purchaseDate']?.toString() ?? json['purchase_date']?.toString() ?? json['createdAt']?.toString() ?? json['created_at']?.toString() ?? '',
      status: json['status']?.toString() ?? 'completed',
      subscriptionPeriod: json['subscriptionPeriod']?.toString() ?? json['subscription_period']?.toString() ?? json['billingPeriod']?.toString(),
      paymentProvider: json['paymentProvider']?.toString() ?? json['payment_provider']?.toString() ?? json['provider']?.toString() ?? json['method']?.toString(),
      paymentReference: json['paymentReference']?.toString() ?? json['payment_reference']?.toString() ?? json['transactionRef']?.toString() ?? json['transaction_ref']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'accountId': accountId,
      'accountEmail': accountEmail,
      'companyId': companyId,
      'companyName': companyName,
      'planId': planId,
      'planName': planName,
      'amount': amount,
      'currency': currency,
      'purchaseDate': purchaseDate,
      'status': status,
      'subscriptionPeriod': subscriptionPeriod,
      'paymentProvider': paymentProvider,
      'paymentReference': paymentReference,
    };
  }

  @override
  List<Object?> get props => [
        id,
        accountId,
        companyName,
        planName,
        amount,
        status,
        purchaseDate,
      ];
}
