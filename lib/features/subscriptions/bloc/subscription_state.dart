import 'package:equatable/equatable.dart';
import '../../../shared/models/subscription_model.dart';

abstract class SubscriptionState extends Equatable {
  const SubscriptionState();
  @override
  List<Object?> get props => [];
}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {}

class SubscriptionsLoaded extends SubscriptionState {
  final List<SubscriptionModel> subscriptions;

  const SubscriptionsLoaded(this.subscriptions);

  @override
  List<Object?> get props => [subscriptions];
}

class SubscriptionError extends SubscriptionState {
  final String message;

  const SubscriptionError(this.message);

  @override
  List<Object?> get props => [message];
}
