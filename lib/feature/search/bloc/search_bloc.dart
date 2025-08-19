import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../products/product_repository.dart';
import '../../products/products.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ProductRepository _repository;

  SearchBloc(this._repository) : super(SearchInitial()) {
    on<SearchProducts>(_onSearchProducts);
    on<ClearFilters>(_onClearFilters);
  }

  void _onSearchProducts(
    SearchProducts event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());

    try {
      final products = await _repository.getProducts();

      if (event.query.isEmpty) {
        emit(
          SearchResultsFetched(
            searchedProducts: products,
            selectedCategoryId: '0',
            searchQuery: event.query,
          ),
        );
      } else {
        final searchedProducts =
            products
                .where(
                  (product) =>
                      product.name.toLowerCase().contains(
                        event.query.toLowerCase(),
                      ) ||
                      product.description.toLowerCase().contains(
                        event.query.toLowerCase(),
                      ),
                )
                .toList();

        emit(
          SearchResultsFetched(
            searchedProducts: searchedProducts,
            selectedCategoryId: '0',
            searchQuery: event.query,
          ),
        );
      }
    } catch (e) {
      emit(SearchError(message: e.toString()));
    }
  }

  void _onClearFilters(ClearFilters event, Emitter<SearchState> emit) async {
    try {
      emit(SearchLoading());
      final products = await _repository.getProducts();
      emit(SearchCleared(searchedProducts: products, selectedCategoryId: '0'));
    } catch (e) {
      emit(SearchError(message: e.toString()));
    }
  }
}
