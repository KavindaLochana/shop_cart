import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:shop_cart/category.dart';
import 'package:shop_cart/product_repository.dart';
import 'package:shop_cart/products.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _repository;

  ProductBloc(this._repository) : super(ProductInitial()) {
    on<LoadProducts>(loadProducts);
    on<FilterByCategory>(filterByCategory);
  }

  Future<void> loadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
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

  Future<void> filterByCategory(
    FilterByCategory event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());

    try {
      List<Product> filteredProducts = [];
      final products = await _repository.getProducts();

      if (event.categoryId == null || event.categoryId == '0') {
        filteredProducts = products;
      } else {
        filteredProducts =
            products
                .where((product) => product.categoryId == event.categoryId)
                .toList();
      }

      debugPrint('CATEGORY ID::::::: ${event.categoryId}');

      emit(
        ProductFilteredByCategory(
          filteredProducts: filteredProducts,
          selectedCategoryId: event.categoryId ?? '0',
          searchQuery: '',
        ),
      );
    } catch (e) {
      emit(ProductError('Failed to load products: ${e.toString()}'));
    }
  }

  // Future<void> searchProducts(
  //   SearchProducts event,
  //   Emitter<ProductState> emit,
  // ) async {
  //   final currentState = state;
  //   if (currentState is ProductLoaded) {
  //     if (event.query.isEmpty) {
  //       emit(
  //         currentState.copyWith(
  //           filteredProducts: currentState.products,
  //           searchQuery: '',
  //           clearCategory: true,
  //         ),
  //       );
  //     } else {
  //       final filteredProducts =
  //           currentState.products
  //               .where(
  //                 (product) =>
  //                     product.name.toLowerCase().contains(
  //                       event.query.toLowerCase(),
  //                     ) ||
  //                     product.description.toLowerCase().contains(
  //                       event.query.toLowerCase(),
  //                     ),
  //               )
  //               .toList();

  //       emit(
  //         currentState.copyWith(
  //           filteredProducts: filteredProducts,
  //           searchQuery: event.query,
  //           clearCategory: true,
  //         ),
  //       );
  //     }
  //   }
  // }
}
