import 'package:equatable/equatable.dart';
import '../../../shared/models/feature_flag_model.dart';

abstract class FeatureFlagsState extends Equatable {
  const FeatureFlagsState();
  @override
  List<Object?> get props => [];
}

class FeatureFlagsInitial extends FeatureFlagsState {}

class FeatureFlagsLoading extends FeatureFlagsState {}

class FeatureFlagsLoaded extends FeatureFlagsState {
  final List<FeatureFlagModel> flags;

  const FeatureFlagsLoaded(this.flags);

  @override
  List<Object?> get props => [flags];
}

class FeatureFlagsError extends FeatureFlagsState {
  final String message;

  const FeatureFlagsError(this.message);

  @override
  List<Object?> get props => [message];
}
