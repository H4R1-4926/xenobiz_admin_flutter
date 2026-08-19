import 'package:flutter/foundation.dart';
import '../datasources/account_remote_datasource.dart';
import '../models/user_model.dart';

class AccountRepository {
  final AccountRemoteDataSource remoteDataSource;

  AccountRepository(this.remoteDataSource);

  Future<List<UserModel>> getAccounts({
    String? search,
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await remoteDataSource.getAccounts(
        search: search,
        status: status,
        page: page,
        limit: limit,
      );

      final rawList = response['data'] ?? response['accounts'] ?? response['users'] ?? response['shops'] ?? response['items'] ?? response['rows'];
      if (rawList is List) {
        return rawList.map((item) => UserModel.fromJson(item as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('AccountRepository getAccounts API error: $e');
      rethrow;
    }
  }

  Future<UserModel?> getAccountById(String id) async {
    try {
      final response = await remoteDataSource.getAccountById(id);
      final data = response['data'] ?? response['account'] ?? response['user'] ?? response;
      if (data is Map<String, dynamic>) {
        return UserModel.fromJson(data);
      }
    } catch (e) {
      debugPrint('AccountRepository getAccountById API error: $e');
      rethrow;
    }
    return null;
  }

  Future<bool> updateAccountStatus(String id, String status) async {
    try {
      await remoteDataSource.updateAccountStatus(id, status);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<UserModel> createShop(Map<String, dynamic> data) async {
    final response = await remoteDataSource.createShop(data);
    final raw = response['data'] ?? response;
    return UserModel.fromJson(raw as Map<String, dynamic>);
  }

  Future<UserModel> updateShop(String id, Map<String, dynamic> data) async {
    final response = await remoteDataSource.updateShop(id, data);
    final raw = response['data'] ?? response;
    return UserModel.fromJson(raw as Map<String, dynamic>);
  }

  Future<bool> deleteShop(String id) async {
    try {
      await remoteDataSource.deleteShop(id);
      return true;
    } catch (_) {
      return false;
    }
  }
}

