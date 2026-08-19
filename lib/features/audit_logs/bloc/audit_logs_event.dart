import 'package:equatable/equatable.dart';

abstract class AuditLogsEvent extends Equatable {
  const AuditLogsEvent();
  @override
  List<Object?> get props => [];
}

class AuditLogsLoadRequested extends AuditLogsEvent {}
