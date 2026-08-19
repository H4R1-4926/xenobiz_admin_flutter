import 'package:flutter/foundation.dart';
import '../datasources/feature_flag_remote_datasource.dart';
import '../models/feature_flag_model.dart';

class FeatureFlagRepository {
  final FeatureFlagRemoteDataSource remoteDataSource;

  FeatureFlagRepository(this.remoteDataSource);

  Future<List<FeatureFlagModel>> getFeatureFlags() async {
    try {
      final response = await remoteDataSource.getFeatureFlags();
      final rawList = response['data'] ?? response['flags'] ?? response;
      if (rawList is List) {
        return rawList.map((item) => FeatureFlagModel.fromJson(item as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      debugPrint('FeatureFlagRepository getFeatureFlags error: $e');
    }
    return [];
  }

  Future<FeatureFlagModel?> toggleFeatureFlag(String key) async {
    try {
      final response = await remoteDataSource.toggleFeatureFlag(key);
      final raw = response['data'] ?? response;
      if (raw is Map<String, dynamic>) {
        return FeatureFlagModel.fromJson(raw);
      }
    } catch (e) {
      debugPrint('FeatureFlagRepository toggleFeatureFlag error: $e');
    }
    return null;
  }
}
