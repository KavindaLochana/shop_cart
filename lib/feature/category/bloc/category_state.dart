part of 'category_bloc.dart';

sealed class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

final class CategoryInitial extends CategoryState {}

class LoadingCategory extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Category> categories;
  final List<Product> products;
  final String selectedCategoryId;

  const CategoryLoaded({
    required this.categories,
    required this.products,
    required this.selectedCategoryId,
  });
}

class ErrorLoadingCategory extends CategoryState {
  final String message;

  const ErrorLoadingCategory({required this.message});
}
