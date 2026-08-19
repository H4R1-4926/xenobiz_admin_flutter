import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/repositories/config_repository.dart';
import 'config_event.dart';
import 'config_state.dart';

class ConfigBloc extends Bloc<ConfigEvent, ConfigState> {
  final ConfigRepository configRepository;

  ConfigBloc({required this.configRepository}) : super(ConfigInitial()) {
    on<ConfigLoadRequested>(_onConfigLoadRequested);
    on<ConfigCategoryUpdateRequested>(_onConfigCategoryUpdateRequested);
  }

  Future<void> _onConfigLoadRequested(
      ConfigLoadRequested event, Emitter<ConfigState> emit) async {
    emit(ConfigLoading());
    try {
      final config = await configRepository.getConfig();
      emit(ConfigLoaded(config));
    } catch (e) {
      emit(ConfigError(e.toString()));
    }
  }

  Future<void> _onConfigCategoryUpdateRequested(
      ConfigCategoryUpdateRequested event, Emitter<ConfigState> emit) async {
    try {
      await configRepository.updateCategory(event.category, event.payload);
      add(ConfigLoadRequested());
    } catch (e) {
      emit(ConfigError(e.toString()));
    }
  }
}
