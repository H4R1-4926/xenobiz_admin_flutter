import 'package:equatable/equatable.dart';
import '../../../shared/models/shop_model.dart';

abstract class ShopState extends Equatable {
  const ShopState();
  @override
  List<Object?> get props => [];
}

class ShopInitial extends ShopState {}

class ShopLoading extends ShopState {}

class ShopsLoaded extends ShopState {
  final List<ShopModel> shops;

  const ShopsLoaded(this.shops);

  @override
  List<Object?> get props => [shops];
}

class ShopError extends ShopState {
  final String message;

  const ShopError(this.message);

  @override
  List<Object?> get props => [message];
}
