import 'package:indian_tex/models/cart_item.dart';

enum OrderStage {
  packed,
  processing,
  shipped,
  delivered,
}

class Order {
  Order({
    required this.id,
    required this.items,
    required this.shippingAddress,
    required this.placedAt,
    required this.deliveryCharge,
    this.stage = OrderStage.packed,
  });

  final String id;
  final List<CartItem> items;
  final String shippingAddress;
  final DateTime placedAt;
  final double deliveryCharge;
  OrderStage stage;

  double get subtotal => items.fold(0, (sum, i) => sum + i.lineTotal);
  double get total => subtotal + deliveryCharge;
}

