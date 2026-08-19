import 'package:equatable/equatable.dart';
import '../../../shared/models/admin_user_model.dart';

abstract class AdminsState extends Equatable {
  const AdminsState();
  @override
  List<Object?> get props => [];
}

class AdminsInitial extends AdminsState {}

class AdminsLoading extends AdminsState {}

class AdminsLoaded extends AdminsState {
  final List<AdminUserModel> admins;

  const AdminsLoaded(this.admins);

  @override
  List<Object?> get props => [admins];
}

class AdminsError extends AdminsState {
  final String message;

  const AdminsError(this.message);

  @override
  List<Object?> get props => [message];
}
