import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_cart/category/bloc/category_bloc.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoaded) {
          return Container(
            height: 60,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: state.categories.length + 1, // +1 for "All" category
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildCategoryChip(
                    context,
                    'All',
                    null,
                    // state.selectedCategoryId == null,
                    false,
                  );
                }

                final category = state.categories[index - 1];
                return _buildCategoryChip(
                  context,
                  category.name,
                  category.id,
                  // state.selectedCategoryId == category.id,
                  false,
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
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
          // context.read<ProductBloc>().filterByCategory(
          //   selected ? categoryId : null,
          // );
        },
        selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
        checkmarkColor: Theme.of(context).primaryColor,
        side: BorderSide(
          color:
              isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
        ),
      ),
    );
  }
}
