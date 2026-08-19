import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/config/app_config.dart';
import '../../core/network/dio_client.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/business_model.dart';
import '../models/user_model.dart';

class AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final DioClient dioClient;

  AuthRepository({
    required this.remoteDataSource,
    required this.dioClient,
  });

  Future<Map<String, dynamic>> login(String emailOrUsername, String password) async {
    try {
      final response = await remoteDataSource.login(emailOrUsername, password);

      final Map<String, dynamic> data = response['data'] is Map<String, dynamic>
          ? response['data'] as Map<String, dynamic>
          : response;

      final token = data['token']?.toString() ??
          response['token']?.toString() ??
          data['accessToken']?.toString() ??
          response['accessToken']?.toString() ??
          '';

      final userRaw = data['user'] ?? response['user'] ?? (data.containsKey('email') || data.containsKey('id') ? data : null);
      final UserModel user;
      if (userRaw is Map<String, dynamic>) {
        user = UserModel.fromJson(userRaw);
      } else {
        user = UserModel(
          id: data['id']?.toString() ?? '1',
          email: emailOrUsername,
          fullName: emailOrUsername,
          role: 'ADMIN',
          loginId: emailOrUsername,
          accountStatus: 'active',
          createdAt: DateTime.now().toIso8601String(),
        );
      }

      List<BusinessModel> businesses = [];
      final rawBiz = data['businesses'] ?? response['businesses'];
      if (rawBiz is List) {
        businesses = rawBiz
            .map((b) => BusinessModel.fromJson(b as Map<String, dynamic>))
            .toList();
      }

      String? primaryBizId;
      final rawBizDetail = data['business'] ?? response['business'];
      if (rawBizDetail is Map) {
        primaryBizId = (rawBizDetail as Map<String, dynamic>)['id']?.toString();
      } else if (businesses.isNotEmpty) {
        primaryBizId = businesses.first.id;
      }

      dioClient.setAuthToken(token);
      dioClient.setSelectedBusinessId(primaryBizId);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConfig.tokenKey, token);
      await prefs.setString(AppConfig.userKey, jsonEncode(user.toJson()));
      if (primaryBizId != null) {
        await prefs.setString(AppConfig.businessIdKey, primaryBizId);
      }

      return {
        'user': user,
        'token': token,
        'businesses': businesses,
        'selectedBusinessId': primaryBizId,
      };
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final response = await remoteDataSource.getCurrentUser();
      final data = response['data'] is Map<String, dynamic>
          ? response['data']
          : (response['user'] is Map<String, dynamic>
              ? response['user']
              : response);
      if (data is Map<String, dynamic>) {
        return UserModel.fromJson(data);
      }
    } catch (e) {
      debugPrint('getCurrentUser error: $e');
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(AppConfig.userKey);
      if (userJson != null && userJson.isNotEmpty) {
        final map = jsonDecode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(map);
      }
    } catch (_) {}

    return null;
  }

  Future<void> logout() async {
    try {
      await remoteDataSource.logout();
    } catch (_) {}

    dioClient.setAuthToken(null);
    dioClient.setSelectedBusinessId(null);

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConfig.tokenKey);
    await prefs.remove(AppConfig.userKey);
    await prefs.remove(AppConfig.businessIdKey);
  }

  Future<String?> getSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConfig.tokenKey);
    if (token != null && token.isNotEmpty) {
      dioClient.setAuthToken(token);
    }
    return token;
  }

  Future<UserModel?> getSavedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(AppConfig.userKey);
      if (userJson != null && userJson.isNotEmpty) {
        final map = jsonDecode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(map);
      }
    } catch (_) {}
    return null;
  }

  Future<void> setSelectedBusinessId(String businessId) async {
    dioClient.setSelectedBusinessId(businessId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConfig.businessIdKey, businessId);
  }
}
