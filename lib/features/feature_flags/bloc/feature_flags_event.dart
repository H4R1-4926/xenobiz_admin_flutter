import 'package:equatable/equatable.dart';

abstract class FeatureFlagsEvent extends Equatable {
  const FeatureFlagsEvent();
  @override
  List<Object?> get props => [];
}

class FeatureFlagsLoadRequested extends FeatureFlagsEvent {}

class FeatureFlagToggleRequested extends FeatureFlagsEvent {
  final String flagKey;

  const FeatureFlagToggleRequested(this.flagKey);

  @override
  List<Object?> get props => [flagKey];
}
