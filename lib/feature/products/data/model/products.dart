import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final double price;
  final String description;
  final String categoryId;
  final String? imageUrl;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.categoryId,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    price,
    description,
    categoryId,
    imageUrl,
  ];

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      description: json['description'],
      categoryId: json['categoryId'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'categoryId': categoryId,
      'imageUrl': imageUrl,
    };
  }
}
