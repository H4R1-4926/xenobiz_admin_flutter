import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/repositories/customer_repository.dart';
import 'customer_event.dart';
import 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerRepository customerRepository;

  CustomerBloc({required this.customerRepository}) : super(CustomerInitial()) {
    on<CustomersLoadRequested>(_onCustomersLoadRequested);
    on<CustomerCreateSubmitted>(_onCustomerCreateSubmitted);
  }

  Future<void> _onCustomersLoadRequested(
      CustomersLoadRequested event, Emitter<CustomerState> emit) async {
    emit(CustomerLoading());
    try {
      final customers = await customerRepository.getCustomers();
      emit(CustomersLoaded(customers));
    } catch (e) {
      emit(CustomerError(e.toString()));
    }
  }

  Future<void> _onCustomerCreateSubmitted(
      CustomerCreateSubmitted event, Emitter<CustomerState> emit) async {
    try {
      await customerRepository.createCustomer(event.payload);
      add(CustomersLoadRequested());
    } catch (e) {
      emit(CustomerError(e.toString()));
    }
  }
}
