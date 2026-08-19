import 'package:flutter/foundation.dart';
import '../datasources/config_remote_datasource.dart';

class ConfigRepository {
  final ConfigRemoteDataSource remoteDataSource;

  ConfigRepository(this.remoteDataSource);

  Future<Map<String, dynamic>> getAppConfigs() async {
    try {
      final response = await remoteDataSource.getAppConfigs();
      final data = response['data'] ?? response;
      if (data is Map<String, dynamic>) {
        return data;
      }
    } catch (e) {
      debugPrint('ConfigRepository getAppConfigs error: $e');
    }
    return {};
  }

  Future<bool> updateConfigCategory(String category, Map<String, dynamic> settings) async {
    try {
      await remoteDataSource.updateConfigCategory(category, settings);
      return true;
    } catch (e) {
      debugPrint('ConfigRepository updateConfigCategory error: $e');
      return false;
    }
  }
}
