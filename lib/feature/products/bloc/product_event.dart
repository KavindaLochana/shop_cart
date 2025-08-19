part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductEvent {}

class FilterByCategory extends ProductEvent {
  final String? categoryId;

  const FilterByCategory({required this.categoryId});
}

class SearchProducts extends ProductEvent {
  final String query;

  const SearchProducts({required this.query});
}
