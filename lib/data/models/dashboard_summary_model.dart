import 'package:equatable/equatable.dart';
import 'purchase_model.dart';
import 'subscription_model.dart';
import 'user_model.dart';

class DashboardSummaryModel extends Equatable {
  final int totalAccounts;
  final int activeAccounts;
  final int activeSubscriptions;
  final int expiringSoonCount;
  final int activePlansCount;
  final num totalRevenue;
  final int trialAccountsCount;
  final int expiredSubscriptionsCount;
  final int cancelledSubscriptionsCount;
  final int pendingPaymentsCount;

  final List<UserModel> recentAccounts;
  final List<PurchaseModel> recentPurchases;
  final List<SubscriptionModel> expiringSubscriptions;

  const DashboardSummaryModel({
    required this.totalAccounts,
    required this.activeAccounts,
    required this.activeSubscriptions,
    required this.expiringSoonCount,
    required this.activePlansCount,
    required this.totalRevenue,
    this.trialAccountsCount = 0,
    this.expiredSubscriptionsCount = 0,
    this.cancelledSubscriptionsCount = 0,
    this.pendingPaymentsCount = 0,
    required this.recentAccounts,
    required this.recentPurchases,
    required this.expiringSubscriptions,
  });

  int get totalShops => totalAccounts;
  int get activeShops => activeAccounts;
  num get monthlyRevenue => totalRevenue;

  static num _parseNum(dynamic val) {
    if (val is num) return val;
    if (val != null) {
      final parsed = num.tryParse(val.toString());
      if (parsed != null) return parsed;
    }
    return 0;
  }

  static int _parseInt(dynamic val) {
    if (val is int) return val;
    if (val is num) return val.toInt();
    if (val != null) {
      final parsed = int.tryParse(val.toString()) ?? double.tryParse(val.toString())?.toInt();
      if (parsed != null) return parsed;
    }
    return 0;
  }

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    final overview = json['overview'] is Map
        ? Map<String, dynamic>.from(json['overview'] as Map)
        : (json['summary'] is Map
            ? Map<String, dynamic>.from(json['summary'] as Map)
            : (json['data'] is Map ? Map<String, dynamic>.from(json['data'] as Map) : json));

    List<UserModel> accounts = [];
    if (json['recentAccounts'] is List) {
      accounts = (json['recentAccounts'] as List)
          .map((a) => UserModel.fromJson(a as Map<String, dynamic>))
          .toList();
    } else if (json['recent_accounts'] is List) {
      accounts = (json['recent_accounts'] as List)
          .map((a) => UserModel.fromJson(a as Map<String, dynamic>))
          .toList();
    } else if (json['shops'] is List) {
      accounts = (json['shops'] as List)
          .map((a) => UserModel.fromJson(a as Map<String, dynamic>))
          .toList();
    }

    List<PurchaseModel> purchases = [];
    if (json['recentPurchases'] is List) {
      purchases = (json['recentPurchases'] as List)
          .map((p) => PurchaseModel.fromJson(p as Map<String, dynamic>))
          .toList();
    } else if (json['recent_purchases'] is List) {
      purchases = (json['recent_purchases'] as List)
          .map((p) => PurchaseModel.fromJson(p as Map<String, dynamic>))
          .toList();
    } else if (json['payments'] is List) {
      purchases = (json['payments'] as List)
          .map((p) => PurchaseModel.fromJson(p as Map<String, dynamic>))
          .toList();
    }

    List<SubscriptionModel> expiringSubs = [];
    if (json['expiringSubscriptions'] is List) {
      expiringSubs = (json['expiringSubscriptions'] as List)
          .map((s) => SubscriptionModel.fromJson(s as Map<String, dynamic>))
          .toList();
    } else if (json['expiring_subscriptions'] is List) {
      expiringSubs = (json['expiring_subscriptions'] as List)
          .map((s) => SubscriptionModel.fromJson(s as Map<String, dynamic>))
          .toList();
    }

    final totAcc = overview['totalShops'] ?? overview['totalAccounts'] ?? overview['total_accounts'] ?? overview['totalUsers'] ?? accounts.length;
    final actAcc = overview['activeShops'] ?? overview['activeAccounts'] ?? overview['active_accounts'] ?? overview['activeUsers'] ?? accounts.where((a) => a.isActive).length;
    final actSub = overview['activeSubscriptions'] ?? overview['active_subscriptions'] ?? 0;
    final expCount = overview['expiringSoonCount'] ?? overview['expiring_soon_count'] ?? expiringSubs.length;
    final actPlans = overview['activePlansCount'] ?? overview['active_plans_count'] ?? overview['totalPlans'] ?? 0;
    final rev = overview['monthlyRevenue'] ?? overview['totalRevenue'] ?? overview['total_revenue'] ?? overview['revenue'] ?? 0;

    final trial = overview['trialAccounts'] ?? overview['trial_accounts'] ?? 0;
    final expired = overview['expiredSubscriptions'] ?? overview['expired_subscriptions'] ?? 0;
    final cancelled = overview['cancelledSubscriptions'] ?? overview['cancelled_subscriptions'] ?? 0;
    final pendingPay = overview['pendingPayments'] ?? overview['pending_payments'] ?? 0;

    return DashboardSummaryModel(
      totalAccounts: _parseInt(totAcc),
      activeAccounts: _parseInt(actAcc),
      activeSubscriptions: _parseInt(actSub),
      expiringSoonCount: _parseInt(expCount),
      activePlansCount: _parseInt(actPlans),
      totalRevenue: _parseNum(rev),
      trialAccountsCount: _parseInt(trial),
      expiredSubscriptionsCount: _parseInt(expired),
      cancelledSubscriptionsCount: _parseInt(cancelled),
      pendingPaymentsCount: _parseInt(pendingPay),
      recentAccounts: accounts,
      recentPurchases: purchases,
      expiringSubscriptions: expiringSubs,
    );
  }

  @override
  List<Object?> get props => [
        totalAccounts,
        activeAccounts,
        activeSubscriptions,
        expiringSoonCount,
        activePlansCount,
        totalRevenue,
        trialAccountsCount,
        expiredSubscriptionsCount,
        cancelledSubscriptionsCount,
        pendingPaymentsCount,
      ];
}
