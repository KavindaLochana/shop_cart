part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class LoadCart extends CartEvent {}

class AddItemToCart extends CartEvent {
  final Product product;
  final int quantity;

  const AddItemToCart({required this.product, this.quantity = 1});

  @override
  List<Object> get props => [product, quantity];
}

class RemoveItemFromCart extends CartEvent {
  final String productId;

  const RemoveItemFromCart(this.productId);

  @override
  List<Object> get props => [productId];
}

class UpdateItemQuantity extends CartEvent {
  final String productId;
  final int quantity;

  const UpdateItemQuantity({required this.productId, required this.quantity});

  @override
  List<Object> get props => [productId, quantity];
}

class ClearCart extends CartEvent {}
