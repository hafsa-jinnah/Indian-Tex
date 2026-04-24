import 'package:indian_tex/models/product.dart';

class CartItem {
  CartItem({
    required this.product,
    required this.size,
    required this.color,
    this.quantity = 1,
  });

  final Product product;
  final String size;
  final String color;
  int quantity;

  double get lineTotal => product.discountedPrice * quantity;

  String get key => '${product.id}::$size::$color';
}
