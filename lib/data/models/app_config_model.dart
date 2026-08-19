import 'package:equatable/equatable.dart';

class AppConfigCategoryModel extends Equatable {
  final String category;
  final Map<String, dynamic> settings;

  const AppConfigCategoryModel({
    required this.category,
    required this.settings,
  });

  factory AppConfigCategoryModel.fromJson(String category, Map<String, dynamic> json) {
    return AppConfigCategoryModel(
      category: category,
      settings: json,
    );
  }

  @override
  List<Object?> get props => [category, settings];
}
