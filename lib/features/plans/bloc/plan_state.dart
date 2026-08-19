import 'package:equatable/equatable.dart';
import '../../../shared/models/plan_model.dart';

abstract class PlanState extends Equatable {
  const PlanState();
  @override
  List<Object?> get props => [];
}

class PlanInitial extends PlanState {}

class PlanLoading extends PlanState {}

class PlansLoaded extends PlanState {
  final List<PlanModel> plans;

  const PlansLoaded(this.plans);

  @override
  List<Object?> get props => [plans];
}

class PlanError extends PlanState {
  final String message;

  const PlanError(this.message);

  @override
  List<Object?> get props => [message];
}
