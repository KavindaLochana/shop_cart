import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_cart/feature/category/category.dart';
import 'package:shop_cart/feature/category/bloc/category_bloc.dart';
import 'package:shop_cart/feature/products/bloc/product_bloc.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    List<Category> categories = [];
    String selectedId = '0';

    return BlocConsumer<ProductBloc, ProductState>(
      listener: (context, state) {
        debugPrint('CAME TO PRODUCT LISTNER....');
        if (state is ProductFilteredByCategory) {
          selectedId = state.selectedCategoryId;
          debugPrint('BLOC CAT ID: $selectedId');
        }
      },
      builder: (context, state) {
        return BlocConsumer<CategoryBloc, CategoryState>(
          listener: (context, state) {
            if (state is CategoryLoaded) {
              categories = state.categories;
              selectedId = '0';
            }
          },
          builder: (context, state) {
            if (state is CategoryLoaded) {
              return Container(
                height: 60,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: categories.length + 1, // +1 for "All" category
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildCategoryChip(
                        context,
                        'All',
                        '0',
                        selectedId == '0',
                      );
                    }

                    final category = categories[index - 1];
                    return _buildCategoryChip(
                      context,
                      category.name,
                      category.id,
                      selectedId == category.id,
                    );
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  Widget _buildCategoryChip(
    BuildContext context,
    String label,
    String? categoryId,
    bool isSelected,
  ) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          debugPrint('ONSELECTED TAPEED:::: $categoryId');

          context.read<ProductBloc>().add(
            FilterByCategory(categoryId: categoryId),
          );
        },
        selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
        checkmarkColor: Theme.of(context).primaryColor,
        side: BorderSide(
          color:
              isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
        ),
      ),
    );
  }
}
