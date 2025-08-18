import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shop_cart/feature/cart/cart_item.dart';
import 'package:shop_cart/feature/cart/cart_repository.dart';
import 'package:shop_cart/feature/products/products.dart';

part 'cart_event.dart';
part 'cart_state.dart';

const int maxQuantityPerItem = 10;

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _repository;

  CartBloc(this._repository) : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddItemToCart>(_onAddItemToCart);
    on<RemoveItemFromCart>(_onRemoveItemFromCart);
    on<UpdateItemQuantity>(_onUpdateItemQuantity);
    on<ClearCart>(_onClearCart);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final items = await _repository.getCartItems();
      emit(CartLoaded(items: items));
    } catch (e) {
      emit(CartError('Failed to load cart: ${e.toString()}'));
    }
  }

  Future<void> _onAddItemToCart(
    AddItemToCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      final existingItems = await _repository.getCartItems();
      final existingItemIndex = existingItems.indexWhere(
        (item) => item.product.id == event.product.id,
      );

      List<CartItem> updatedItems = List.from(existingItems);

      if (existingItemIndex >= 0) {
        final existingItem = existingItems[existingItemIndex];
        final newQuantity = existingItem.quantity + event.quantity;

        if (newQuantity > maxQuantityPerItem) {
          emit(
            CartError(
              'Maximum quantity limit reached for ${event.product.name}',
            ),
          );

          final currentItems = await _repository.getCartItems();
          emit(CartLoaded(items: currentItems));
          return;
        }

        updatedItems[existingItemIndex] = existingItem.copyWith(
          quantity: newQuantity,
        );
      } else {
        if (event.quantity > maxQuantityPerItem) {
          emit(CartError('Maximum quantity limit is $maxQuantityPerItem'));

          final currentItems = await _repository.getCartItems();
          emit(CartLoaded(items: currentItems));
          return;
        }

        updatedItems.add(
          CartItem(product: event.product, quantity: event.quantity),
        );
      }

      await _repository.saveCartItems(updatedItems);
      emit(CartLoaded(items: updatedItems));
    } catch (e) {
      emit(CartError('Failed to add item: ${e.toString()}'));
    }
  }

  Future<void> _onRemoveItemFromCart(
    RemoveItemFromCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      final existingItems = await _repository.getCartItems();
      final updatedItems =
          existingItems
              .where((item) => item.product.id != event.productId)
              .toList();

      await _repository.saveCartItems(updatedItems);
      emit(CartLoaded(items: updatedItems));
    } catch (e) {
      emit(CartError('Failed to remove item: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateItemQuantity(
    UpdateItemQuantity event,
    Emitter<CartState> emit,
  ) async {
    try {
      if (event.quantity <= 0) {
        add(RemoveItemFromCart(event.productId));
        return;
      }

      if (event.quantity > maxQuantityPerItem) {
        emit(CartError('Maximum quantity limit is $maxQuantityPerItem'));

        final currentItems = await _repository.getCartItems();
        emit(CartLoaded(items: currentItems));
        return;
      }

      final existingItems = await _repository.getCartItems();
      final updatedItems =
          existingItems.map((item) {
            if (item.product.id == event.productId) {
              return item.copyWith(quantity: event.quantity);
            }
            return item;
          }).toList();

      await _repository.saveCartItems(updatedItems);
      emit(CartLoaded(items: updatedItems));
    } catch (e) {
      emit(CartError('Failed to update quantity: ${e.toString()}'));
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    try {
      await _repository.clearCart();
      emit(const CartLoaded(items: []));
    } catch (e) {
      emit(CartError('Failed to clear cart: ${e.toString()}'));
    }
  }

  Future<CartItem?> getCartItem(String productId) async {
    try {
      final items = await _repository.getCartItems();
      return items.firstWhere((item) => item.product.id == productId);
    } catch (e) {
      return null;
    }
  }

  Future<List<CartItem>> getAllCartItems() async {
    try {
      return await _repository.getCartItems();
    } catch (e) {
      return [];
    }
  }
}
