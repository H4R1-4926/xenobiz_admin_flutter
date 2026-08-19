import 'package:equatable/equatable.dart';
import '../../../shared/models/audit_log_model.dart';

abstract class AuditLogsState extends Equatable {
  const AuditLogsState();
  @override
  List<Object?> get props => [];
}

class AuditLogsInitial extends AuditLogsState {}

class AuditLogsLoading extends AuditLogsState {}

class AuditLogsLoaded extends AuditLogsState {
  final List<AuditLogModel> logs;

  const AuditLogsLoaded(this.logs);

  @override
  List<Object?> get props => [logs];
}

class AuditLogsError extends AuditLogsState {
  final String message;

  const AuditLogsError(this.message);

  @override
  List<Object?> get props => [message];
}
