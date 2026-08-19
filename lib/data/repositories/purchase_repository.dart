import 'package:flutter/foundation.dart';
import '../datasources/purchase_remote_datasource.dart';
import '../models/purchase_model.dart';

class PurchaseRepository {
  final PurchaseRemoteDataSource remoteDataSource;

  PurchaseRepository(this.remoteDataSource);

  Future<List<PurchaseModel>> getPurchases({
    String? status,
    String? search,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await remoteDataSource.getPurchases(
        status: status,
        search: search,
        page: page,
        limit: limit,
      );

      final rawList = response['data'] ?? response['purchases'] ?? response['transactions'] ?? response['items'] ?? response['rows'];
      if (rawList is List) {
        return rawList.map((item) => PurchaseModel.fromJson(item as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('PurchaseRepository getPurchases API error: $e');
      rethrow;
    }
  }

  Future<PurchaseModel?> getPurchaseById(String id) async {
    try {
      final response = await remoteDataSource.getPurchaseById(id);
      final data = response['data'] ?? response['purchase'] ?? response;
      if (data is Map<String, dynamic>) {
        return PurchaseModel.fromJson(data);
      }
    } catch (e) {
      debugPrint('PurchaseRepository getPurchaseById API error: $e');
      rethrow;
    }
    return null;
  }
}

