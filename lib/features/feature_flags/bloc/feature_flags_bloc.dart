import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/repositories/feature_flag_repository.dart';
import 'feature_flags_event.dart';
import 'feature_flags_state.dart';

class FeatureFlagsBloc extends Bloc<FeatureFlagsEvent, FeatureFlagsState> {
  final FeatureFlagRepository featureFlagRepository;

  FeatureFlagsBloc({required this.featureFlagRepository})
      : super(FeatureFlagsInitial()) {
    on<FeatureFlagsLoadRequested>(_onFeatureFlagsLoadRequested);
    on<FeatureFlagToggleRequested>(_onFeatureFlagToggleRequested);
  }

  Future<void> _onFeatureFlagsLoadRequested(
      FeatureFlagsLoadRequested event, Emitter<FeatureFlagsState> emit) async {
    emit(FeatureFlagsLoading());
    try {
      final flags = await featureFlagRepository.getFeatureFlags();
      emit(FeatureFlagsLoaded(flags));
    } catch (e) {
      emit(FeatureFlagsError(e.toString()));
    }
  }

  Future<void> _onFeatureFlagToggleRequested(
      FeatureFlagToggleRequested event, Emitter<FeatureFlagsState> emit) async {
    try {
      await featureFlagRepository.toggleFlag(event.flagKey);
      add(FeatureFlagsLoadRequested());
    } catch (e) {
      emit(FeatureFlagsError(e.toString()));
    }
  }
}
