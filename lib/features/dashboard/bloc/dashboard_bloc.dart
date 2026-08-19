import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/repositories/dashboard_repository.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository dashboardRepository;

  DashboardBloc({required this.dashboardRepository}) : super(DashboardInitial()) {
    on<DashboardLoadRequested>(_onDashboardLoadRequested);
  }

  Future<void> _onDashboardLoadRequested(
      DashboardLoadRequested event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    try {
      final data = await dashboardRepository.getDashboardData();
      emit(DashboardLoaded(data));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
