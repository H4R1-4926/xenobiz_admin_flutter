import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/repositories/audit_log_repository.dart';
import 'audit_logs_event.dart';
import 'audit_logs_state.dart';

class AuditLogsBloc extends Bloc<AuditLogsEvent, AuditLogsState> {
  final AuditLogRepository auditLogRepository;

  AuditLogsBloc({required this.auditLogRepository}) : super(AuditLogsInitial()) {
    on<AuditLogsLoadRequested>(_onAuditLogsLoadRequested);
  }

  Future<void> _onAuditLogsLoadRequested(
      AuditLogsLoadRequested event, Emitter<AuditLogsState> emit) async {
    emit(AuditLogsLoading());
    try {
      final logs = await auditLogRepository.getAuditLogs();
      emit(AuditLogsLoaded(logs));
    } catch (e) {
      emit(AuditLogsError(e.toString()));
    }
  }
}
