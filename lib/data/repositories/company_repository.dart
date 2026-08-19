import 'package:flutter/foundation.dart';
import '../datasources/company_remote_datasource.dart';
import '../models/business_model.dart';

class CompanyRepository {
  final CompanyRemoteDataSource remoteDataSource;

  CompanyRepository(this.remoteDataSource);

  Future<List<BusinessModel>> getCompanies({
    String? search,
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await remoteDataSource.getCompanies(
        search: search,
        status: status,
        page: page,
        limit: limit,
      );

      final rawList = response['data'] ?? response['companies'] ?? response['businesses'] ?? response['items'] ?? response['rows'];
      if (rawList is List) {
        return rawList.map((item) => BusinessModel.fromJson(item as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('CompanyRepository getCompanies API error: $e');
      rethrow;
    }
  }

  Future<BusinessModel?> getCompanyById(String id) async {
    try {
      final response = await remoteDataSource.getCompanyById(id);
      final data = response['data'] ?? response['company'] ?? response['business'] ?? response;
      if (data is Map<String, dynamic>) {
        return BusinessModel.fromJson(data);
      }
    } catch (e) {
      debugPrint('CompanyRepository getCompanyById API error: $e');
      rethrow;
    }
    return null;
  }

  Future<BusinessModel?> updateCompany(String id, Map<String, dynamic> data) async {
    try {
      final response = await remoteDataSource.updateCompany(id, data);
      final resData = response['data'] ?? response['company'] ?? response['business'] ?? response;
      if (resData is Map<String, dynamic>) {
        return BusinessModel.fromJson(resData);
      }
    } catch (_) {}
    return null;
  }
}

