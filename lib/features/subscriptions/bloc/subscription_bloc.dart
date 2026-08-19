import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/repositories/subscription_repository.dart';
import 'subscription_event.dart';
import 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final SubscriptionRepository subscriptionRepository;

  SubscriptionBloc({required this.subscriptionRepository})
      : super(SubscriptionInitial()) {
    on<SubscriptionsLoadRequested>(_onSubscriptionsLoadRequested);
  }

  Future<void> _onSubscriptionsLoadRequested(
      SubscriptionsLoadRequested event, Emitter<SubscriptionState> emit) async {
    emit(SubscriptionLoading());
    try {
      final subs = await subscriptionRepository.getSubscriptions();
      emit(SubscriptionsLoaded(subs));
    } catch (e) {
      emit(SubscriptionError(e.toString()));
    }
  }
}
