import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/repositories/shop_repository.dart';
import 'shop_event.dart';
import 'shop_state.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  final ShopRepository shopRepository;

  ShopBloc({required this.shopRepository}) : super(ShopInitial()) {
    on<ShopsLoadRequested>(_onShopsLoadRequested);
    on<ShopCreateSubmitted>(_onShopCreateSubmitted);
    on<ShopStatusUpdateRequested>(_onShopStatusUpdateRequested);
  }

  Future<void> _onShopsLoadRequested(
      ShopsLoadRequested event, Emitter<ShopState> emit) async {
    emit(ShopLoading());
    try {
      final shops = await shopRepository.getShops();
      emit(ShopsLoaded(shops));
    } catch (e) {
      emit(ShopError(e.toString()));
    }
  }

  Future<void> _onShopCreateSubmitted(
      ShopCreateSubmitted event, Emitter<ShopState> emit) async {
    try {
      await shopRepository.createShop(event.payload);
      add(ShopsLoadRequested());
    } catch (e) {
      emit(ShopError(e.toString()));
    }
  }

  Future<void> _onShopStatusUpdateRequested(
      ShopStatusUpdateRequested event, Emitter<ShopState> emit) async {
    try {
      await shopRepository.updateShopStatus(event.shopId, event.status);
      add(ShopsLoadRequested());
    } catch (e) {
      emit(ShopError(e.toString()));
    }
  }
}
