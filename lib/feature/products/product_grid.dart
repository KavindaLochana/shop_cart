import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_cart/feature/products/product_card.dart';
import 'package:shop_cart/feature/products/products.dart';
import 'package:shop_cart/feature/products/bloc/product_bloc.dart';

import '../search/bloc/search_bloc.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    List<Product> filteredProducts = [];
    String searched = '';

    return BlocConsumer<SearchBloc, SearchState>(
      listener: (context, state) {
        if (state is SearchResultsFetched) {
          filteredProducts = state.searchedProducts ?? [];
          searched = state.searchQuery ?? '';
        }

        if (state is SearchCleared) {
          filteredProducts = state.searchedProducts ?? [];
        }
      },
      builder: (context, state) {
        if (state is SearchLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return BlocConsumer<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state is ProductLoaded) {
              filteredProducts = state.filteredProducts;
            }

            if (state is ProductFilteredByCategory) {
              filteredProducts = state.filteredProducts ?? [];
              searched = state.searchQuery ?? '';
            }
          },
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProductError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProductBloc>().add(LoadProducts());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (filteredProducts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      searched.isNotEmpty
                          ? 'No products found for "$searched"'
                          : 'No products found in this category',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        // context.read<ProductBloc>().add(LoadProducts());
                        context.read<SearchBloc>().add(ClearFilters());
                      },
                      child: const Text('Show all products'),
                    ),
                  ],
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                return ProductCard(product: filteredProducts[index]);
              },
            );
          },
        );
      },
    );
  }
}
