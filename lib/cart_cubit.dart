// lib/cubits/cart_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shop_cart/cart_item.dart';
import 'package:shop_cart/cart_repository.dart';
import 'package:shop_cart/products.dart';

// States
abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;
  static const int maxQuantityPerItem = 10;

  const CartLoaded({required this.items});

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      items.fold(0.0, (sum, item) => sum + item.totalPrice);

  bool get isEmpty => items.isEmpty;

  @override
  List<Object> get props => [items];

  CartLoaded copyWith({List<CartItem>? items}) {
    return CartLoaded(items: items ?? this.items);
  }
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object> get props => [message];
}

// Cubit
class CartCubit extends Cubit<CartState> {
  final CartRepository _repository;

  CartCubit(this._repository) : super(CartInitial());

  Future<void> loadCart() async {
    emit(CartLoading());
    try {
      final items = await _repository.getCartItems();
      emit(CartLoaded(items: items));
    } catch (e) {
      emit(CartError('Failed to load cart: ${e.toString()}'));
    }
  }

  Future<void> addItem(Product product, {int quantity = 1}) async {
    final currentState = state;
    if (currentState is CartLoaded) {
      final existingItemIndex = currentState.items.indexWhere(
        (item) => item.product.id == product.id,
      );

      List<CartItem> updatedItems = List.from(currentState.items);

      if (existingItemIndex >= 0) {
        final existingItem = currentState.items[existingItemIndex];
        final newQuantity = existingItem.quantity + quantity;

        // Check maximum quantity limit
        if (newQuantity > CartLoaded.maxQuantityPerItem) {
          emit(CartError('Maximum quantity limit reached for ${product.name}'));
          emit(currentState); // Return to previous state
          return;
        }

        updatedItems[existingItemIndex] = existingItem.copyWith(
          quantity: newQuantity,
        );
      } else {
        // Check if adding new item exceeds limit
        if (quantity > CartLoaded.maxQuantityPerItem) {
          emit(
            CartError(
              'Maximum quantity limit is ${CartLoaded.maxQuantityPerItem}',
            ),
          );
          emit(currentState); // Return to previous state
          return;
        }

        updatedItems.add(CartItem(product: product, quantity: quantity));
      }

      final newState = CartLoaded(items: updatedItems);
      emit(newState);
      await _repository.saveCartItems(updatedItems);
    }
  }

  Future<void> removeItem(String productId) async {
    final currentState = state;
    if (currentState is CartLoaded) {
      final updatedItems =
          currentState.items
              .where((item) => item.product.id != productId)
              .toList();

      final newState = CartLoaded(items: updatedItems);
      emit(newState);
      await _repository.saveCartItems(updatedItems);
    }
  }

  Future<void> updateItemQuantity(String productId, int quantity) async {
    final currentState = state;
    if (currentState is CartLoaded) {
      if (quantity <= 0) {
        await removeItem(productId);
        return;
      }

      // Check maximum quantity limit
      if (quantity > CartLoaded.maxQuantityPerItem) {
        emit(
          CartError(
            'Maximum quantity limit is ${CartLoaded.maxQuantityPerItem}',
          ),
        );
        emit(currentState); // Return to previous state
        return;
      }

      final updatedItems =
          currentState.items.map((item) {
            if (item.product.id == productId) {
              return item.copyWith(quantity: quantity);
            }
            return item;
          }).toList();

      final newState = CartLoaded(items: updatedItems);
      emit(newState);
      await _repository.saveCartItems(updatedItems);
    }
  }

  Future<void> clearCart() async {
    emit(const CartLoaded(items: []));
    await _repository.clearCart();
  }

  CartItem? getCartItem(String productId) {
    final currentState = state;
    if (currentState is CartLoaded) {
      try {
        return currentState.items.firstWhere(
          (item) => item.product.id == productId,
        );
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
