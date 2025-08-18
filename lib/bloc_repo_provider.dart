import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shop_cart/category/bloc/category_bloc.dart';
import 'package:shop_cart/products/bloc/product_bloc.dart';
import 'package:shop_cart/cart_cubit.dart';
import 'package:shop_cart/cart_repository.dart';
import 'package:shop_cart/product_cubit.dart';
import 'package:shop_cart/product_repository.dart';

class RepoBlocProvider {
  static final List<SingleChildWidget> repoList = [];

  static final List<SingleChildWidget> blocList = [
    BlocProvider<ProductCubit>(
      create:
          (context) =>
              ProductCubit(context.read<ProductRepository>())..loadProducts(),
    ),
    BlocProvider<CartCubit>(
      create:
          (context) => CartCubit(context.read<CartRepository>())..loadCart(),
    ),
    BlocProvider<ProductBloc>(
      create: (context) => ProductBloc(ProductRepository()),
    ),
    BlocProvider<CategoryBloc>(
      create: (context) => CategoryBloc(ProductRepository()),
    ),
  ];
}
