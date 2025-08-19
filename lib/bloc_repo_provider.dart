import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shop_cart/feature/cart/bloc/cart_bloc.dart';
import 'package:shop_cart/feature/category/bloc/category_bloc.dart';
import 'package:shop_cart/feature/products/bloc/product_bloc.dart';
import 'package:shop_cart/feature/cart/cart_repository.dart';
import 'package:shop_cart/feature/search/bloc/search_bloc.dart';
import 'package:shop_cart/feature/products/product_repository.dart';

class RepoBlocProvider {
  static final List<SingleChildWidget> repoList = [];

  static final List<SingleChildWidget> blocList = [
    BlocProvider<ProductBloc>(
      create: (context) => ProductBloc(ProductRepository()),
    ),
    BlocProvider<CategoryBloc>(
      create: (context) => CategoryBloc(ProductRepository()),
    ),
    BlocProvider<CartBloc>(create: (context) => CartBloc(CartRepository())),
    BlocProvider<SearchBloc>(
      create: (context) => SearchBloc(ProductRepository()),
    ),
  ];
}
