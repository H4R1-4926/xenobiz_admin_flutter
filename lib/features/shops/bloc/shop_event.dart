import 'package:equatable/equatable.dart';

abstract class ShopEvent extends Equatable {
  const ShopEvent();
  @override
  List<Object?> get props => [];
}

class ShopsLoadRequested extends ShopEvent {}

class ShopCreateSubmitted extends ShopEvent {
  final Map<String, dynamic> payload;

  const ShopCreateSubmitted(this.payload);

  @override
  List<Object?> get props => [payload];
}

class ShopStatusUpdateRequested extends ShopEvent {
  final String shopId;
  final String status;

  const ShopStatusUpdateRequested({required this.shopId, required this.status});

  @override
  List<Object?> get props => [shopId, status];
}
