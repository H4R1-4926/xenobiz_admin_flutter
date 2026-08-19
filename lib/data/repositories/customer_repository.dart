import 'package:flutter/foundation.dart';
import '../datasources/customer_remote_datasource.dart';
import '../models/customer_model.dart';

class CustomerRepository {
  final CustomerRemoteDataSource remoteDataSource;

  CustomerRepository(this.remoteDataSource);

  Future<List<CustomerModel>> getCustomers({
    String? search,
    String? status,
    String? shopId,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final response = await remoteDataSource.getCustomers(
        search: search,
        status: status,
        shopId: shopId,
        page: page,
        limit: limit,
      );

      final rawList = response['data'] ?? response['customers'] ?? response['items'] ?? response;
      if (rawList is List) {
        return rawList.map((item) => CustomerModel.fromJson(item as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('CustomerRepository getCustomers error: $e');
      rethrow;
    }
  }

  Future<CustomerModel?> getCustomerById(String id) async {
    try {
      final response = await remoteDataSource.getCustomerById(id);
      final raw = response['data'] ?? response;
      if (raw is Map<String, dynamic>) {
        return CustomerModel.fromJson(raw);
      }
    } catch (e) {
      debugPrint('CustomerRepository getCustomerById error: $e');
    }
    return null;
  }

  Future<CustomerModel> createCustomer(Map<String, dynamic> data) async {
    final response = await remoteDataSource.createCustomer(data);
    final raw = response['data'] ?? response;
    return CustomerModel.fromJson(raw as Map<String, dynamic>);
  }

  Future<CustomerModel> updateCustomer(String id, Map<String, dynamic> data) async {
    final response = await remoteDataSource.updateCustomer(id, data);
    final raw = response['data'] ?? response;
    return CustomerModel.fromJson(raw as Map<String, dynamic>);
  }

  Future<bool> deleteCustomer(String id) async {
    try {
      await remoteDataSource.deleteCustomer(id);
      return true;
    } catch (_) {
      return false;
    }
  }
}
