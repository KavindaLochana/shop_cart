part of 'search_bloc.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

final class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchResultsFetched extends SearchState {
  final List<Product>? searchedProducts;
  final String selectedCategoryId;
  final String? searchQuery;

  const SearchResultsFetched({
    required this.searchedProducts,
    required this.selectedCategoryId,
    required this.searchQuery,
  });
}

class SearchError extends SearchState {
  final String message;

  const SearchError({required this.message});
}

class SearchCleared extends SearchState {
  final List<Product>? searchedProducts;
  final String selectedCategoryId;

  const SearchCleared({
    required this.searchedProducts,
    required this.selectedCategoryId,
  });
}
