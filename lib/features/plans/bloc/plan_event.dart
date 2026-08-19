import 'package:equatable/equatable.dart';

abstract class PlanEvent extends Equatable {
  const PlanEvent();
  @override
  List<Object?> get props => [];
}

class PlansLoadRequested extends PlanEvent {}

class PlanCreateSubmitted extends PlanEvent {
  final Map<String, dynamic> payload;

  const PlanCreateSubmitted(this.payload);

  @override
  List<Object?> get props => [payload];
}

class PlanToggleStatusRequested extends PlanEvent {
  final String planId;

  const PlanToggleStatusRequested(this.planId);

  @override
  List<Object?> get props => [planId];
}
