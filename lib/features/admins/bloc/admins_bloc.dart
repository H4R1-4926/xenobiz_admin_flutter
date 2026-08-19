import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/repositories/admin_repository.dart';
import 'admins_event.dart';
import 'admins_state.dart';

class AdminsBloc extends Bloc<AdminsEvent, AdminsState> {
  final AdminRepository adminRepository;

  AdminsBloc({required this.adminRepository}) : super(AdminsInitial()) {
    on<AdminsLoadRequested>(_onAdminsLoadRequested);
    on<AdminCreateSubmitted>(_onAdminCreateSubmitted);
    on<AdminResetPasswordRequested>(_onAdminResetPasswordRequested);
  }

  Future<void> _onAdminsLoadRequested(
      AdminsLoadRequested event, Emitter<AdminsState> emit) async {
    emit(AdminsLoading());
    try {
      final admins = await adminRepository.getAdmins();
      emit(AdminsLoaded(admins));
    } catch (e) {
      emit(AdminsError(e.toString()));
    }
  }

  Future<void> _onAdminCreateSubmitted(
      AdminCreateSubmitted event, Emitter<AdminsState> emit) async {
    try {
      await adminRepository.createAdmin(event.payload);
      add(AdminsLoadRequested());
    } catch (e) {
      emit(AdminsError(e.toString()));
    }
  }

  Future<void> _onAdminResetPasswordRequested(
      AdminResetPasswordRequested event, Emitter<AdminsState> emit) async {
    try {
      await adminRepository.resetPassword(event.adminId);
    } catch (e) {
      emit(AdminsError(e.toString()));
    }
  }
}
