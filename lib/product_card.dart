import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_cart/cart_cubit.dart';
import 'package:shop_cart/products.dart';
import 'package:shop_cart/quantity_selector.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child:
                  product.imageUrl != null
                      ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Image.network(
                          product.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholderImage();
                          },
                        ),
                      )
                      : _buildPlaceholderImage(),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize:
                    MainAxisSize.min, // Key addition: minimize column size
                children: [
                  // Wrap the product info in Flexible to prevent overflow
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          product.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Add some space between product info and button
                  const SizedBox(height: 8),
                  // Keep the button/selector at the bottom
                  BlocBuilder<CartCubit, CartState>(
                    builder: (context, state) {
                      if (state is CartLoaded) {
                        final cartItem =
                            state.items
                                .where((item) => item.product.id == product.id)
                                .firstOrNull;

                        if (cartItem != null) {
                          return QuantitySelector(
                            quantity: cartItem.quantity,
                            onQuantityChanged: (quantity) {
                              if (quantity == 0) {
                                context.read<CartCubit>().removeItem(
                                  product.id,
                                );
                              } else {
                                context.read<CartCubit>().updateItemQuantity(
                                  product.id,
                                  quantity,
                                );
                              }
                            },
                          );
                        } else {
                          return SizedBox(
                            width: double.infinity,
                            height: 32,
                            child: ElevatedButton(
                              onPressed: () {
                                context.read<CartCubit>().addItem(product);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${product.name} added to cart',
                                    ),
                                    duration: const Duration(
                                      milliseconds: 1500,
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              child: const Text(
                                'Add',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          );
                        }
                      }
                      return const SizedBox(height: 32);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Center(child: Icon(Icons.image, size: 40, color: Colors.grey[400]));
  }
}

// class ProductCard extends StatelessWidget {
//   final Product product;

//   const ProductCard({super.key, required this.product});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 2,
//             child: Container(
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.grey[100],
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(12),
//                 ),
//               ),
//               child:
//                   product.imageUrl != null
//                       ? ClipRRect(
//                         borderRadius: const BorderRadius.vertical(
//                           top: Radius.circular(12),
//                         ),
//                         child: Image.network(
//                           product.imageUrl!,
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) {
//                             return _buildPlaceholderImage();
//                           },
//                         ),
//                       )
//                       : _buildPlaceholderImage(),
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         product.name,
//                         style: const TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 2),
//                       Text(
//                         product.description,
//                         style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         product.price.toStringAsFixed(2),
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Theme.of(context).primaryColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                   BlocBuilder<CartCubit, CartState>(
//                     builder: (context, state) {
//                       if (state is CartLoaded) {
//                         final cartItem =
//                             state.items
//                                 .where((item) => item.product.id == product.id)
//                                 .firstOrNull;

//                         if (cartItem != null) {
//                           return QuantitySelector(
//                             quantity: cartItem.quantity,
//                             onQuantityChanged: (quantity) {
//                               if (quantity == 0) {
//                                 context.read<CartCubit>().removeItem(
//                                   product.id,
//                                 );
//                               } else {
//                                 context.read<CartCubit>().updateItemQuantity(
//                                   product.id,
//                                   quantity,
//                                 );
//                               }
//                             },
//                           );
//                         } else {
//                           return SizedBox(
//                             width: double.infinity,
//                             height: 32,
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 context.read<CartCubit>().addItem(product);
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Text(
//                                       '${product.name} added to cart',
//                                     ),
//                                     duration: const Duration(
//                                       milliseconds: 1500,
//                                     ),
//                                     backgroundColor: Colors.green,
//                                   ),
//                                 );
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Theme.of(context).primaryColor,
//                                 foregroundColor: Colors.white,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 padding: EdgeInsets.zero,
//                               ),
//                               child: const Text(
//                                 'Add',
//                                 style: TextStyle(fontSize: 12),
//                               ),
//                             ),
//                           );
//                         }
//                       }
//                       return const SizedBox(height: 32);
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPlaceholderImage() {
//     return Center(child: Icon(Icons.image, size: 40, color: Colors.grey[400]));
//   }
// }
