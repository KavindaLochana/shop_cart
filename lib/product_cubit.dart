// States
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_cart/category.dart';
import 'package:shop_cart/product_repository.dart';
import 'package:shop_cart/products.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

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

  ProductLoaded copyWith({
    List<Category>? categories,
    List<Product>? products,
    List<Product>? filteredProducts,
    String? selectedCategoryId,
    String? searchQuery,
    bool clearCategory = false,
  }) {
    return ProductLoaded(
      categories: categories ?? this.categories,
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      selectedCategoryId:
          clearCategory
              ? null
              : (selectedCategoryId ?? this.selectedCategoryId),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object> get props => [message];
}

// Cubit
class ProductCubit extends Cubit<ProductState> {
  final ProductRepository _repository;

  ProductCubit(this._repository) : super(ProductInitial());

  Future<void> loadProducts() async {
    emit(ProductLoading());
    try {
      final categories = await _repository.getCategories();
      final products = await _repository.getProducts();

      emit(
        ProductLoaded(
          categories: categories,
          products: products,
          filteredProducts: products,
        ),
      );
    } catch (e) {
      emit(ProductError('Failed to load products: ${e.toString()}'));
    }
  }

  void filterByCategory(String? categoryId) {
    final currentState = state;
    if (currentState is ProductLoaded) {
      List<Product> filteredProducts;

      if (categoryId == null) {
        filteredProducts = currentState.products;
      } else {
        filteredProducts =
            currentState.products
                .where((product) => product.categoryId == categoryId)
                .toList();
      }

      emit(
        currentState.copyWith(
          filteredProducts: filteredProducts,
          selectedCategoryId: categoryId,
          searchQuery: '',
          clearCategory: categoryId == null,
        ),
      );
    }
  }

  void searchProducts(String query) {
    final currentState = state;
    if (currentState is ProductLoaded) {
      if (query.isEmpty) {
        emit(
          currentState.copyWith(
            filteredProducts: currentState.products,
            searchQuery: '',
            clearCategory: true,
          ),
        );
      } else {
        final filteredProducts =
            currentState.products
                .where(
                  (product) =>
                      product.name.toLowerCase().contains(
                        query.toLowerCase(),
                      ) ||
                      product.description.toLowerCase().contains(
                        query.toLowerCase(),
                      ),
                )
                .toList();

        emit(
          currentState.copyWith(
            filteredProducts: filteredProducts,
            searchQuery: query,
            clearCategory: true,
          ),
        );
      }
    }
  }

  void clearFilters() {
    final currentState = state;
    if (currentState is ProductLoaded) {
      emit(
        currentState.copyWith(
          filteredProducts: currentState.products,
          searchQuery: '',
          clearCategory: true,
        ),
      );
    }
  }
}
