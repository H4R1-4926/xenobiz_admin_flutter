import 'package:equatable/equatable.dart';

abstract class AdminsEvent extends Equatable {
  const AdminsEvent();
  @override
  List<Object?> get props => [];
}

class AdminsLoadRequested extends AdminsEvent {}

class AdminCreateSubmitted extends AdminsEvent {
  final Map<String, dynamic> payload;

  const AdminCreateSubmitted(this.payload);

  @override
  List<Object?> get props => [payload];
}

class AdminResetPasswordRequested extends AdminsEvent {
  final String adminId;

  const AdminResetPasswordRequested(this.adminId);

  @override
  List<Object?> get props => [adminId];
}
