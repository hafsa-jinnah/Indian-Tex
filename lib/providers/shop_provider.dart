import 'dart:async';

import 'package:flutter/material.dart';
import 'package:indian_tex/models/cart_item.dart';
import 'package:indian_tex/models/category_item.dart';
import 'package:indian_tex/models/order.dart';
import 'package:indian_tex/models/product.dart';
import 'package:indian_tex/utils/currency.dart';

class ShopProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _darkMode = false;
  Color _accentColor = const Color(0xFF8C1D40);
  String? _defaultShippingAddress;

  bool get isLoggedIn => _isLoggedIn;
  bool get darkMode => _darkMode;
  Color get accentColor => _accentColor;
  String? get defaultShippingAddress => _defaultShippingAddress;

  final List<CategoryItem> categories = const [
    CategoryItem(
      id: 'c1',
      name: 'Kurti',
      imageUrl: 'assets/images/kurti  name tag.jpg',
    ),
    CategoryItem(
      id: 'c2',
      name: 'Shalwars',
      imageUrl: 'assets/images/shalwars name tag.jpg',
    ),
    CategoryItem(
      id: 'c3',
      name: 'Tops',
      imageUrl: 'assets/images/top name tag.jpg',
    ),
    CategoryItem(
      id: 'c4',
      name: 'Pants',
      imageUrl: 'assets/images/pants name tag.jpg',
    ),
    CategoryItem(
      id: 'c5',
      name: 'Shawl',
      imageUrl: 'assets/images/shawls name tag.jpg',
    ),
    CategoryItem(
      id: 'c6',
      name: 'Sarees',
      imageUrl: 'assets/images/sarees name tag.jpg',
    ),
    CategoryItem(
      id: 'c7',
      name: 'Accessories',
      imageUrl: 'assets/images/Accessories name tag.jpg',
    ),
  ];

  final List<Product> products = const [
    Product(
      id: 'p1',
      name: '3pcs Shalwar Set',
      price: 5500,
      discountedPrice: 5250,
      category: 'Kurti',
      description: 'Elegant festive kurti with soft lining and modern fit.',
      imageUrl: 'assets/images/kurti 1.jpg',
      imageUrls: [
        
      ],
      clothType: 'Cotton',
      colors: ['White'],
      sizes: ['M', 'L', 'XL','2XL'],
      rating: 4.6,
    ),
    Product(
      id: 'p2',
      name: 'Rich Wedding Shalwar',
      price: 9000,
      discountedPrice: 8500,
      category: 'Shalwars',
      description: 'Stylish,Comfortable and Modest.',
      imageUrl: 'assets/images/Shalwar1.jpeg',
      imageUrls: [
        'assets/images/Shalwar2.jpg',
        'assets/images/Shalwar3.jpg',
      ],
      clothType: 'Silk',
      colors: ['Navy Blue', 'Dark Green', 'Maroon'],
      sizes: ['Free Size'],
      rating: 4.4,
    ),
    Product(
      id: 'p3',
      name: 'Stoned Work Short cord set',
      price: 5500,
      discountedPrice: 5350,
      category: 'Tops',
      description: 'Smooth premium top with breathable fabric and fine stitching.',
      imageUrl: 'assets/images/Cord set 1.jpg',
      imageUrls: [
        
      ],
      clothType: 'Denim',
      colors: ['Black'],
      sizes: ['M', 'L','XL','2XL'],
      rating: 4.7,
    ),
    Product(
      id: 'p4',
      name: 'Plaza Pants',
      price: 700,
      discountedPrice: 650,
      category: 'Pants',
      description: 'Wide-leg plaza pants designed for comfort and style.',
      imageUrl: 'assets/images/Plaza pant.jpg',
      imageUrls: [
        'assets/images/plaza pant 1.jpg',
        'assets/images/plaza pant 2.jpg',
        'assets/images/plaza pant 3.jpg',
        'assets/images/plaza pant 4.jpg',
      ],
      clothType: 'Viscose',
      colors: ['Grey', 'Black', 'Brown','Yellow','Red','Navy Blue','Light Blue','White','Maroon','Coffee Brown','Dark Green','Wine','Orange','Bottle Green'],
      sizes: ['Free Size'],
      rating: 4.5,
    ),
    Product(
      id: 'p5',
      name: 'Chiffon Shawl',
      price: 400,
      discountedPrice: 350,
      category: 'Shawl',
      description:
          'Soft premium chiffon shawl with lightweight drape and elegant finish.',
      imageUrl: 'assets/images/chiffon shawl.jpg',
      imageUrls: [
        'assets/images/chiffon shawl 1.jpg',
        'assets/images/chiffon shawl 2.jpg',
        'assets/images/chiffon shawl 3.jpg',
      ],
      clothType: 'Pure Chiffon',
      colors: ['Ivory', 'Rose Gold', 'Black','Brown','Yellow','Red','Navy Blue','Light Blue','White','Maroon','Coffee Brown','Dark Green','Wine','Orange','Bottle Green'],
      sizes: ['Free Size'],
      rating: 4.8,
    ),
    Product(
      id: 'p6',
      name: 'Deeptex Saree',
      price: 2500,
      discountedPrice: 2350,
      category: 'Sarees',
      description:
          'Made from soft and breathable cotton,this saree is ideal for daily wear and warm weather.',
      imageUrl: 'assets/images/Saree 1.jpg',
      imageUrls: [
        
      ],
      clothType: 'Pure Cotton',
      colors: ['Red and Blue'],
      sizes: ['Free Size'],
      rating: 4.9,
    ),
    Product(
      id: 'p7',
      name: 'Festive Jewelry Set',
      price: 1799,
      discountedPrice: 1299,
      category: 'Accessories',
      description:
          'Stone-work accessory set crafted for festive occasions and weddings.',
      imageUrl: 'assets/images/festive jewelry set.jpeg',
      imageUrls: [
        
      ],
      clothType: 'Alloy + Stone',
      colors: ['Gold', 'Rose Gold', 'Silver'],
      sizes: ['Standard'],
      rating: 4.5,
    ),
  ];

  final List<CartItem> _cart = [];
  final Set<String> _wishlist = {};
  final List<Order> _orders = [];
  final Map<String, Timer> _orderTimers = {};

  List<CartItem> get cartItems => List.unmodifiable(_cart);
  Set<String> get wishlist => Set.unmodifiable(_wishlist);
  List<Order> get orders => List.unmodifiable(_orders);

  List<Product> productsByCategory(String category) {
    return products.where((p) => p.category == category).toList();
  }

  List<Product> searchProducts(String query) {
    final value = query.trim().toLowerCase();
    if (value.isEmpty) return products;
    return products
        .where(
          (p) =>
              p.name.toLowerCase().contains(value) ||
              p.category.toLowerCase().contains(value),
        )
        .toList();
  }

  void addToCart(
    Product product, {
    required String size,
    required String color,
    int quantity = 1,
  }) {
    final idx = _cart.indexWhere(
      (item) => item.product.id == product.id && item.size == size && item.color == color,
    );
    if (idx >= 0) {
      _cart[idx].quantity += quantity;
    } else {
      _cart.add(CartItem(product: product, size: size, color: color, quantity: quantity));
    }
    notifyListeners();
  }

  void removeFromCart(String cartKey) {
    _cart.removeWhere((item) => item.key == cartKey);
    notifyListeners();
  }

  void updateQty(String cartKey, int qty) {
    final idx = _cart.indexWhere((item) => item.key == cartKey);
    if (idx == -1) return;
    if (qty <= 0) {
      _cart.removeAt(idx);
    } else {
      _cart[idx].quantity = qty;
    }
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  Order placeOrder({
    required List<CartItem> items,
    required String shippingAddress,
  }) {
    final order = Order(
      id: 'ITX${1000 + _orders.length + 1}',
      items: items.map((i) => CartItem(product: i.product, size: i.size, color: i.color, quantity: i.quantity)).toList(),
      shippingAddress: shippingAddress,
      placedAt: DateTime.now(),
      deliveryCharge: deliveryChargeLkr.toDouble(),
      stage: OrderStage.packed,
    );
    _orders.insert(0, order);
    notifyListeners();
    _startOrderAutoProgress(order.id);
    return order;
  }

  void _startOrderAutoProgress(String orderId) {
    _orderTimers[orderId]?.cancel();
    final timer = Timer.periodic(const Duration(seconds: 6), (_) {
      final idx = _orders.indexWhere((o) => o.id == orderId);
      if (idx == -1) return;
      final order = _orders[idx];
      if (order.stage == OrderStage.delivered) {
        _orderTimers[orderId]?.cancel();
        _orderTimers.remove(orderId);
        return;
      }
      order.stage = OrderStage.values[order.stage.index + 1];
      notifyListeners();
    });
    _orderTimers[orderId] = timer;
  }

  void toggleWishlist(String productId) {
    if (_wishlist.contains(productId)) {
      _wishlist.remove(productId);
    } else {
      _wishlist.add(productId);
    }
    notifyListeners();
  }

  double get total => _cart.fold(0, (sum, item) => sum + item.lineTotal);

  void setDefaultShippingAddress(String address) {
    _defaultShippingAddress = address.trim().isEmpty ? null : address.trim();
    notifyListeners();
  }

  bool login({
    required String email,
    required String password,
  }) {
    if (email.trim().isEmpty || !email.contains('@') || password.length < 6) {
      return false;
    }
    _isLoggedIn = true;
    notifyListeners();
    return true;
  }

  bool register({
    required String name,
    required String email,
    required String homeAddress,
    required String telephone,
    required String password,
    required String confirmPassword,
  }) {
    if (name.trim().isEmpty ||
        email.trim().isEmpty ||
        homeAddress.trim().isEmpty ||
        telephone.trim().length < 8 ||
        password.length < 6 ||
        password != confirmPassword) {
      return false;
    }
    _isLoggedIn = true;
    notifyListeners();
    return true;
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  void setAccentColor(Color color) {
    _accentColor = color;
    notifyListeners();
  }

  void setDarkMode(bool enabled) {
    _darkMode = enabled;
    notifyListeners();
  }
}
