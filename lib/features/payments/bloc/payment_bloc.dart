import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/repositories/payment_repository.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository paymentRepository;

  PaymentBloc({required this.paymentRepository}) : super(PaymentInitial()) {
    on<PaymentsLoadRequested>(_onPaymentsLoadRequested);
  }

  Future<void> _onPaymentsLoadRequested(
      PaymentsLoadRequested event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    try {
      final payments = await paymentRepository.getPayments();
      emit(PaymentsLoaded(payments));
    } catch (e) {
      emit(PaymentError(e.toString()));
    }
  }
}
