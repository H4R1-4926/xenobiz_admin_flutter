import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/repositories/plan_repository.dart';
import 'plan_event.dart';
import 'plan_state.dart';

class PlanBloc extends Bloc<PlanEvent, PlanState> {
  final PlanRepository planRepository;

  PlanBloc({required this.planRepository}) : super(PlanInitial()) {
    on<PlansLoadRequested>(_onPlansLoadRequested);
    on<PlanCreateSubmitted>(_onPlanCreateSubmitted);
    on<PlanToggleStatusRequested>(_onPlanToggleStatusRequested);
  }

  Future<void> _onPlansLoadRequested(
      PlansLoadRequested event, Emitter<PlanState> emit) async {
    emit(PlanLoading());
    try {
      final plans = await planRepository.getPlans();
      emit(PlansLoaded(plans));
    } catch (e) {
      emit(PlanError(e.toString()));
    }
  }

  Future<void> _onPlanCreateSubmitted(
      PlanCreateSubmitted event, Emitter<PlanState> emit) async {
    try {
      await planRepository.createPlan(event.payload);
      add(PlansLoadRequested());
    } catch (e) {
      emit(PlanError(e.toString()));
    }
  }

  Future<void> _onPlanToggleStatusRequested(
      PlanToggleStatusRequested event, Emitter<PlanState> emit) async {
    try {
      await planRepository.togglePlanStatus(event.planId);
      add(PlansLoadRequested());
    } catch (e) {
      emit(PlanError(e.toString()));
    }
  }
}
