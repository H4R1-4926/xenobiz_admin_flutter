import 'package:flutter/foundation.dart';
import '../datasources/subscription_remote_datasource.dart';
import '../models/subscription_model.dart';

class SubscriptionRepository {
  final SubscriptionRemoteDataSource remoteDataSource;

  SubscriptionRepository(this.remoteDataSource);

  Future<List<SubscriptionModel>> getSubscriptions({
    String? status,
    String? search,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await remoteDataSource.getSubscriptions(
        status: status,
        search: search,
        page: page,
        limit: limit,
      );

      final rawList = response['data'] ?? response['subscriptions'] ?? response['items'] ?? response['rows'];
      if (rawList is List) {
        return rawList.map((item) => SubscriptionModel.fromJson(item as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('SubscriptionRepository getSubscriptions API error: $e');
      rethrow;
    }
  }

  Future<SubscriptionModel?> getSubscriptionById(String id) async {
    try {
      final response = await remoteDataSource.getSubscriptionById(id);
      final data = response['data'] ?? response['subscription'] ?? response;
      if (data is Map<String, dynamic>) {
        return SubscriptionModel.fromJson(data);
      }
    } catch (e) {
      debugPrint('SubscriptionRepository getSubscriptionById API error: $e');
      rethrow;
    }
    return null;
  }
}

