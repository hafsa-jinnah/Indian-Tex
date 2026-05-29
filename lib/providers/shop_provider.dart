import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:firebase_auth/firebase_auth.dart';

import 'package:indian_tex/models/cart_item.dart';
import 'package:indian_tex/models/category_item.dart';
import 'package:indian_tex/models/order.dart';
import 'package:indian_tex/models/product.dart';
import 'package:indian_tex/utils/currency.dart';

class ShopProvider extends ChangeNotifier {

  bool _darkMode = false;

  Color _accentColor =
      const Color(0xFF8C1D40);

  String? _defaultShippingAddress;

  bool get isLoggedIn =>
      FirebaseAuth.instance.currentUser != null;

  bool get darkMode => _darkMode;

  Color get accentColor =>
      _accentColor;

  String? get defaultShippingAddress =>
      _defaultShippingAddress;

  // =========================
  // CATEGORIES
  // =========================

  final List<CategoryItem> categories = const [

    CategoryItem(
      id: 'c1',
      name: 'Kurti',
      imageUrl:
          'assets/images/kurti  name tag.jpg',
    ),

    CategoryItem(
      id: 'c2',
      name: 'Shalwars',
      imageUrl:
          'assets/images/shalwars name tag.jpg',
    ),

    CategoryItem(
      id: 'c3',
      name: 'Tops',
      imageUrl:
          'assets/images/top name tag.jpg',
    ),

    CategoryItem(
      id: 'c4',
      name: 'Pants',
      imageUrl:
          'assets/images/pants name tag.jpg',
    ),
  ];

  // =========================
  // PRODUCTS
  // =========================

  final List<Product> products = const [

    Product(
      id: 'p1',
      name: '3pcs Shalwar Set',
      price: 5500,
      discountedPrice: 5250,
      category: 'Kurti',

      description:
          'Elegant festive kurti with soft lining and modern fit.',

      imageUrl:
          'https://i.ibb.co/',

      imageUrls: [],

      clothType: 'Cotton',

      colors: ['White'],

      sizes: [
        'M',
        'L',
        'XL',
        '2XL',
      ],

      rating: 4.6,
    ),

    Product(
      id: 'p2',
      name: 'Rich Wedding Shalwar',

      price: 9000,

      discountedPrice: 8500,

      category: 'Shalwars',

      description:
          'Stylish, Comfortable and Modest.',

      imageUrl:
          'https://i.ibb.co/',

      imageUrls: [],

      clothType: 'Silk',

      colors: [
        'Navy Blue',
        'Dark Green',
        'Maroon',
      ],

      sizes: ['Free Size'],

      rating: 4.4,
    ),
  ];

  // =========================
  // LOCAL DATA
  // =========================

  final List<CartItem> _cart = [];

  final Set<String> _wishlist = {};

  final List<Order> _orders = [];

  final Map<String, Timer>
      _orderTimers = {};

  List<CartItem> get cartItems =>
      List.unmodifiable(_cart);

  Set<String> get wishlist =>
      Set.unmodifiable(_wishlist);

  List<Order> get orders =>
      List.unmodifiable(_orders);

  // =========================
  // SEARCH
  // =========================

  List<Product> productsByCategory(
    String category,
  ) {

    return products
        .where(
          (p) =>
              p.category == category,
        )
        .toList();
  }

  List<Product> searchProducts(
    String query,
  ) {

    final value =
        query.trim().toLowerCase();

    if (value.isEmpty) {
      return products;
    }

    return products.where((p) {

      return p.name
              .toLowerCase()
              .contains(value) ||
          p.category
              .toLowerCase()
              .contains(value);

    }).toList();
  }

  // =========================
  // ADD TO CART
  // =========================

  Future<void> addToCart(
    Product product, {
    required String size,
    required String color,
    int quantity = 1,
  }) async {

    if (FirebaseAuth
            .instance.currentUser ==
        null) {

      throw Exception(
        "User not logged in",
      );
    }

    final idx = _cart.indexWhere(

      (item) =>

          item.product.id ==
              product.id &&

          item.size == size &&

          item.color == color,
    );

    if (idx >= 0) {

      _cart[idx].quantity += quantity;

    } else {

      _cart.add(

        CartItem(
          product: product,
          size: size,
          color: color,
          quantity: quantity,
        ),
      );
    }

    notifyListeners();

    // =========================
    // SAVE CART TO FIRESTORE
    // =========================

    await FirebaseFirestore.instance
        .collection('cart')
        .add({

      'userId':
          FirebaseAuth
              .instance
              .currentUser!
              .uid,

      'productId': product.id,

      'name': product.name,

      'price':
          product.discountedPrice,

      'image':
          product.imageUrl,

      'size': size,

      'color': color,

      'quantity': quantity,
    });
  }

  // =========================
  // REMOVE CART ITEM
  // =========================

  Future<void> removeFromCart(
    String cartKey,
  ) async {

    _cart.removeWhere(
      (item) =>
          item.key == cartKey,
    );

    notifyListeners();
  }

  // =========================
  // UPDATE QUANTITY
  // =========================

  Future<void> updateQty(
    String cartKey,
    int qty,
  ) async {

    final idx = _cart.indexWhere(
      (item) =>
          item.key == cartKey,
    );

    if (idx == -1) return;

    if (qty <= 0) {

      _cart.removeAt(idx);

    } else {

      _cart[idx].quantity = qty;
    }

    notifyListeners();
  }

  // =========================
  // CLEAR CART
  // =========================

  void clearCart() {

    _cart.clear();

    notifyListeners();
  }

  // =========================
  // TOTAL
  // =========================

  double get total {

    return _cart.fold(

      0,

      (sum, item) =>
          sum + item.lineTotal,
    );
  }

  // =========================
  // PLACE ORDER
  // =========================

  Future<Order> placeOrder({
    required List<CartItem> items,
    required String shippingAddress,
  }) async {

    final order = Order(

      id:
          'ITX${1000 + _orders.length + 1}',

      items: items.map(

        (i) => CartItem(
          product: i.product,
          size: i.size,
          color: i.color,
          quantity: i.quantity,
        ),

      ).toList(),

      shippingAddress:
          shippingAddress,

      placedAt: DateTime.now(),

      deliveryCharge:
          deliveryChargeLkr
              .toDouble(),

      stage: OrderStage.packed,
    );

    _orders.insert(0, order);

    notifyListeners();

    // =========================
    // SAVE ORDER
    // =========================

    await FirebaseFirestore.instance
        .collection('orders')
        .add({

      'userId':
          FirebaseAuth
              .instance
              .currentUser
              ?.uid,

      'shippingAddress':
          shippingAddress,

      'total': total,

      'placedAt':
          DateTime.now(),

      'status': 'Packed',

      'items': items.map(

        (item) {

          return {

            'productId':
                item.product.id,

            'name':
                item.product.name,

            'price':
                item.product
                    .discountedPrice,

            'quantity':
                item.quantity,

            'image':
                item.product.imageUrl,

            'size':
                item.size,

            'color':
                item.color,
          };
        },

      ).toList(),
    });

    _startOrderAutoProgress(
      order.id,
    );

    return order;
  }

  // =========================
  // ORDER TRACKING
  // =========================

  void _startOrderAutoProgress(
    String orderId,
  ) {

    _orderTimers[orderId]
        ?.cancel();

    final timer = Timer.periodic(

      const Duration(
        seconds: 6,
      ),

      (_) {

        final idx =
            _orders.indexWhere(
          (o) => o.id == orderId,
        );

        if (idx == -1) return;

        final order =
            _orders[idx];

        if (order.stage ==
            OrderStage.delivered) {

          _orderTimers[orderId]
              ?.cancel();

          _orderTimers.remove(
            orderId,
          );

          return;
        }

        order.stage =
            OrderStage.values[
                order.stage.index + 1];

        notifyListeners();
      },
    );

    _orderTimers[orderId] =
        timer;
  }

  // =========================
  // WISHLIST
  // =========================

  void toggleWishlist(
    String productId,
  ) {

    if (_wishlist.contains(
      productId,
    )) {

      _wishlist.remove(
        productId,
      );

    } else {

      _wishlist.add(
        productId,
      );
    }

    notifyListeners();
  }

  // =========================
  // REGISTER
  // =========================

  Future<bool> register({

    required String name,

    required String email,

    required String homeAddress,

    required String telephone,

    required String password,

    required String confirmPassword,

  }) async {

    if (name.trim().isEmpty ||

        email.trim().isEmpty ||

        homeAddress.trim().isEmpty ||

        telephone.trim().length < 8 ||

        password.length < 6 ||

        password != confirmPassword) {

      return false;
    }

    try {

      // =========================
      // CREATE ACCOUNT
      // =========================

      final credential =

          await FirebaseAuth.instance
              .createUserWithEmailAndPassword(

        email: email,
        password: password,
      );

      // =========================
      // SAVE USER DATA
      // =========================

      await FirebaseFirestore.instance
          .collection('users')
          .doc(
            credential.user!.uid,
          )
          .set({

        'name': name,

        'email': email,

        'address':
            homeAddress,

        'telephone':
            telephone,

        'createdAt':
            DateTime.now(),
      });

      notifyListeners();

      return true;

    } catch (e) {

      debugPrint(
        'Register Error: $e',
      );

      return false;
    }
  }

  // =========================
  // LOGIN
  // =========================

  Future<bool> login({

    required String email,

    required String password,

  }) async {

    try {

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(

        email: email,
        password: password,
      );

      notifyListeners();

      return true;

    } catch (e) {

      debugPrint(
        'Login Error: $e',
      );

      return false;
    }
  }

  // =========================
  // LOGOUT
  // =========================

  Future<void> logout() async {

    await FirebaseAuth.instance
        .signOut();

    notifyListeners();
  }

  // =========================
  // SETTINGS
  // =========================

  void setAccentColor(
    Color color,
  ) {

    _accentColor = color;

    notifyListeners();
  }

  void setDarkMode(
    bool enabled,
  ) {

    _darkMode = enabled;

    notifyListeners();
  }

  void setDefaultShippingAddress(
    String address,
  ) {

    _defaultShippingAddress =

        address.trim().isEmpty
            ? null
            : address.trim();

    notifyListeners();
  }
}