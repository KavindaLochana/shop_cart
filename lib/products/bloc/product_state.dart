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

  // ProductLoaded copyWith({
  //   List<Category>? categories,
  //   List<Product>? products,
  //   List<Product>? filteredProducts,
  //   String? selectedCategoryId,
  //   String? searchQuery,
  //   bool clearCategory = false,
  // }) {
  //   return ProductLoaded(
  //     categories: categories ?? this.categories,
  //     products: products ?? this.products,
  //     filteredProducts: filteredProducts ?? this.filteredProducts,
  //     selectedCategoryId:
  //         clearCategory
  //             ? null
  //             : (selectedCategoryId ?? this.selectedCategoryId),
  //     searchQuery: searchQuery ?? this.searchQuery,
  //   );
  // }
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object> get props => [message];
}

class ProductFilteredByCategory extends ProductState {
  final List<Product>? filteredProducts;
  final String? selectedCategoryId;
  final String? searchQuery;
  final bool clearCategory;

  const ProductFilteredByCategory({
    required this.filteredProducts,
    required this.selectedCategoryId,
    required this.searchQuery,
    this.clearCategory = false,
  });
}
