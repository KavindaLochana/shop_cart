import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shop_cart/category.dart';
import 'package:shop_cart/product_repository.dart';
import 'package:shop_cart/products.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final ProductRepository _repository;

  CategoryBloc(this._repository) : super(CategoryInitial()) {
    on<LoadCategory>(_loadCategory);
  }

  Future<void> _loadCategory(
    LoadCategory event,
    Emitter<CategoryState> emit,
  ) async {
    emit(LoadingCategory());
    try {
      final categories = await _repository.getCategories();
      final products = await _repository.getProducts();

      emit(
        CategoryLoaded(
          categories: categories,
          products: products,
          selectedCategoryId: event.category,
        ),
      );
    } catch (e) {
      emit(
        ErrorLoadingCategory(
          message: 'Failed to load products: ${e.toString()}',
        ),
      );
    }
  }
}
