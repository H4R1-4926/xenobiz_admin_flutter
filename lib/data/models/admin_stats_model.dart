import 'package:equatable/equatable.dart';
import 'business_model.dart';
import 'user_model.dart';

class AdminStatsModel extends Equatable {
  final int totalUsers;
  final int totalBusinesses;
  final List<UserModel> users;
  final List<BusinessModel> businesses;

  const AdminStatsModel({
    required this.totalUsers,
    required this.totalBusinesses,
    required this.users,
    required this.businesses,
  });

  factory AdminStatsModel.fromJson(Map<String, dynamic> json) {
    var usersList = <UserModel>[];
    if (json['users'] is List) {
      usersList = (json['users'] as List)
          .map((u) => UserModel.fromJson(u as Map<String, dynamic>))
          .toList();
    }

    var bizList = <BusinessModel>[];
    if (json['businesses'] is List) {
      bizList = (json['businesses'] as List)
          .map((b) => BusinessModel.fromJson(b as Map<String, dynamic>))
          .toList();
    }

    return AdminStatsModel(
      totalUsers: json['totalUsers'] ?? usersList.length,
      totalBusinesses: json['totalBusinesses'] ?? bizList.length,
      users: usersList,
      businesses: bizList,
    );
  }

  @override
  List<Object?> get props => [totalUsers, totalBusinesses, users, businesses];
}
