import 'package:shop_cart/feature/category/category.dart';
import 'package:shop_cart/feature/products/products.dart';

class ProductRepository {
  static const List<Category> _categories = [
    Category(
      id: '1',
      name: 'Electronics',
      description: 'Electronic devices and gadgets',
    ),
    Category(id: '2', name: 'Clothing', description: 'Fashion and apparel'),
    Category(
      id: '3',
      name: 'Books',
      description: 'Books and educational materials',
    ),
    Category(
      id: '4',
      name: 'Home & Garden',
      description: 'Home improvement and garden supplies',
    ),
  ];

  static const List<Product> _products = [
    Product(
      id: '1',
      name: 'iPhone 15',
      price: 999.99,
      description: 'Latest iPhone with advanced features',
      categoryId: '1',
    ),
    Product(
      id: '2',
      name: 'MacBook Pro',
      price: 1999.99,
      description: 'Powerful laptop for professionals',
      categoryId: '1',
    ),
    Product(
      id: '3',
      name: 'Nike Running Shoes',
      price: 129.99,
      description: 'Comfortable running shoes',
      categoryId: '2',
    ),
    Product(
      id: '4',
      name: 'Cotton T-Shirt',
      price: 24.99,
      description: '100% cotton comfortable t-shirt',
      categoryId: '2',
    ),
    Product(
      id: '5',
      name: 'Flutter Complete Guide',
      price: 49.99,
      description: 'Learn Flutter development from scratch',
      categoryId: '3',
    ),
    Product(
      id: '6',
      name: 'Smart Home Hub',
      price: 199.99,
      description: 'Control your smart home devices',
      categoryId: '4',
    ),
    Product(
      id: '7',
      name: 'Garden Tool Set',
      price: 89.99,
      description: 'Complete set of garden tools',
      categoryId: '4',
    ),
    Product(
      id: '8',
      name: 'Wireless Headphones',
      price: 149.99,
      description: 'High-quality wireless headphones',
      categoryId: '1',
    ),
  ];

  Future<List<Category>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _categories;
  }

  Future<List<Product>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _products;
  }

  Future<List<Product>> getProductsByCategory(String categoryId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _products
        .where((product) => product.categoryId == categoryId)
        .toList();
  }

  Future<List<Product>> searchProducts(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _products
        .where(
          (product) =>
              product.name.toLowerCase().contains(query.toLowerCase()) ||
              product.description.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }
}
