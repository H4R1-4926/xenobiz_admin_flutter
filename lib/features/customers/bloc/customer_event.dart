import 'package:equatable/equatable.dart';

abstract class CustomerEvent extends Equatable {
  const CustomerEvent();
  @override
  List<Object?> get props => [];
}

class CustomersLoadRequested extends CustomerEvent {}

class CustomerCreateSubmitted extends CustomerEvent {
  final Map<String, dynamic> payload;

  const CustomerCreateSubmitted(this.payload);

  @override
  List<Object?> get props => [payload];
}
