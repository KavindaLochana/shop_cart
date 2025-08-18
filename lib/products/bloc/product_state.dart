part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

final class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Category> categories;
  final List<Product> products;
  final List<Product> filteredProducts;
  final String? selectedCategoryId;
  final String searchQuery;

  const ProductLoaded({
    required this.categories,
    required this.products,
    required this.filteredProducts,
    this.selectedCategoryId,
    this.searchQuery = '',
  });

  @override
  List<Object> get props => [
    categories,
    products,
    filteredProducts,
    selectedCategoryId ?? '',
    searchQuery,
  ];
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object> get props => [message];
}

class ProductFilteredByCategory extends ProductState {
  final List<Product>? filteredProducts;
  final String selectedCategoryId;
  final String? searchQuery;

  const ProductFilteredByCategory({
    required this.filteredProducts,
    required this.selectedCategoryId,
    required this.searchQuery,
  });
}
