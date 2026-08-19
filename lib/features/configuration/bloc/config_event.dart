import 'package:equatable/equatable.dart';

abstract class ConfigEvent extends Equatable {
  const ConfigEvent();
  @override
  List<Object?> get props => [];
}

class ConfigLoadRequested extends ConfigEvent {}

class ConfigCategoryUpdateRequested extends ConfigEvent {
  final String category;
  final Map<String, dynamic> payload;

  const ConfigCategoryUpdateRequested({required this.category, required this.payload});

  @override
  List<Object?> get props => [category, payload];
}
