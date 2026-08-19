import 'package:flutter/foundation.dart';
import '../datasources/admin_user_remote_datasource.dart';
import '../models/admin_user_model.dart';

class AdminUserRepository {
  final AdminUserRemoteDataSource remoteDataSource;

  AdminUserRepository(this.remoteDataSource);

  Future<List<AdminUserModel>> getAdmins() async {
    try {
      final response = await remoteDataSource.getAdmins();
      final rawList = response['data'] ?? response['admins'] ?? response;
      if (rawList is List) {
        return rawList.map((item) => AdminUserModel.fromJson(item as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      debugPrint('AdminUserRepository getAdmins error: $e');
    }
    return [];
  }

  Future<AdminUserModel> createAdmin(Map<String, dynamic> data) async {
    final response = await remoteDataSource.createAdmin(data);
    final raw = response['data'] ?? response;
    return AdminUserModel.fromJson(raw as Map<String, dynamic>);
  }

  Future<AdminUserModel> updateAdmin(String id, Map<String, dynamic> data) async {
    final response = await remoteDataSource.updateAdmin(id, data);
    final raw = response['data'] ?? response;
    return AdminUserModel.fromJson(raw as Map<String, dynamic>);
  }

  Future<bool> updateAdminStatus(String id, String status) async {
    try {
      await remoteDataSource.updateAdminStatus(id, status);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> resetAdminPassword(String id, String newPassword) async {
    try {
      await remoteDataSource.resetAdminPassword(id, newPassword);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteAdmin(String id) async {
    try {
      await remoteDataSource.deleteAdmin(id);
      return true;
    } catch (_) {
      return false;
    }
  }
}
