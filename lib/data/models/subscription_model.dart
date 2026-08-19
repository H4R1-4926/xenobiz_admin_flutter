import 'package:equatable/equatable.dart';

class SubscriptionModel extends Equatable {
  final String id;
  final String? accountId;
  final String? accountEmail;
  final String? companyId;
  final String? companyName;
  final String? planId;
  final String planName;
  final String status;
  final String? startDate;
  final String? expiryDate;
  final bool isAutoRenew;
  final String? subscriptionReference;
  final String? purchaseId;
  final List<String> features;
  final Map<String, dynamic> limits;
  final String? createdAt;

  const SubscriptionModel({
    required this.id,
    this.accountId,
    this.accountEmail,
    this.companyId,
    this.companyName,
    this.planId,
    required this.planName,
    required this.status,
    this.startDate,
    this.expiryDate,
    this.isAutoRenew = false,
    this.subscriptionReference,
    this.purchaseId,
    this.features = const [],
    this.limits = const {},
    this.createdAt,
  });

  bool get isActive => status.toLowerCase() == 'active';
  bool get isExpired => status.toLowerCase() == 'expired';
  bool get isTrial => status.toLowerCase() == 'trial';

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    final accountMap = json['account'] is Map ? json['account'] as Map<String, dynamic> : null;
    final companyMap = json['company'] is Map ? json['company'] as Map<String, dynamic> : null;
    final planMap = json['plan'] is Map ? json['plan'] as Map<String, dynamic> : null;

    List<String> parsedFeatures = [];
    if (json['features'] is List) {
      parsedFeatures = (json['features'] as List).map((e) => e.toString()).toList();
    } else if (planMap != null && planMap['features'] is List) {
      parsedFeatures = (planMap['features'] as List).map((e) => e.toString()).toList();
    }

    Map<String, dynamic> parsedLimits = {};
    if (json['limits'] is Map) {
      parsedLimits = Map<String, dynamic>.from(json['limits'] as Map);
    } else if (planMap != null && planMap['limits'] is Map) {
      parsedLimits = Map<String, dynamic>.from(planMap['limits'] as Map);
    }

    return SubscriptionModel(
      id: json['id']?.toString() ?? '',
      accountId: json['accountId']?.toString() ?? json['account_id']?.toString() ?? accountMap?['id']?.toString(),
      accountEmail: json['accountEmail']?.toString() ?? json['account_email']?.toString() ?? accountMap?['email']?.toString(),
      companyId: json['companyId']?.toString() ?? json['company_id']?.toString() ?? companyMap?['id']?.toString(),
      companyName: json['companyName']?.toString() ?? json['company_name']?.toString() ?? companyMap?['name']?.toString(),
      planId: json['planId']?.toString() ?? json['plan_id']?.toString() ?? planMap?['id']?.toString(),
      planName: json['planName']?.toString() ?? json['plan_name']?.toString() ?? planMap?['name']?.toString() ?? 'Standard Plan',
      status: json['status']?.toString() ?? 'active',
      startDate: json['startDate']?.toString() ?? json['start_date']?.toString(),
      expiryDate: json['expiryDate']?.toString() ?? json['expiry_date']?.toString() ?? json['renewalDate']?.toString(),
      isAutoRenew: json['isAutoRenew'] == true || json['auto_renew'] == true || json['is_auto_renew'] == true,
      subscriptionReference: json['subscriptionReference']?.toString() ?? json['subscription_ref']?.toString() ?? json['reference']?.toString(),
      purchaseId: json['purchaseId']?.toString() ?? json['purchase_id']?.toString(),
      features: parsedFeatures,
      limits: parsedLimits,
      createdAt: json['createdAt']?.toString() ?? json['created_at']?.toString(),
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
      'status': status,
      'startDate': startDate,
      'expiryDate': expiryDate,
      'isAutoRenew': isAutoRenew,
      'subscriptionReference': subscriptionReference,
      'purchaseId': purchaseId,
      'features': features,
      'limits': limits,
      'createdAt': createdAt,
    };
  }

  @override
  List<Object?> get props => [
        id,
        accountId,
        companyId,
        planName,
        status,
        startDate,
        expiryDate,
        isAutoRenew,
      ];
}
