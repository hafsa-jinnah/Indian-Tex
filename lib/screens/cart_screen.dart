import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:indian_tex/providers/shop_provider.dart';
import 'package:indian_tex/utils/currency.dart';
import 'package:indian_tex/widgets/cart_item_widget.dart';
import 'package:indian_tex/widgets/festive_pattern_background.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ShopProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: FestivePatternBackground(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFF7E8), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: provider.cartItems.isEmpty
              ? const Center(child: Text('Cart is empty'))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: provider.cartItems.length,
                        itemBuilder: (context, index) {
                          final item = provider.cartItems[index];
                          return CartItemWidget(
                            item: item,
                            onDecrease:
                                () => provider.updateQty(item.key, item.quantity - 1),
                            onIncrease:
                                () => provider.updateQty(item.key, item.quantity + 1),
                            onDelete: () => provider.removeFromCart(item.key),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Text('Subtotal'),
                              const Spacer(),
                              Text(
                                formatLkr(provider.total),
                                style:
                                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Text('Delivery'),
                              const Spacer(),
                              Text(formatLkr(deliveryChargeLkr)),
                            ],
                          ),
                          const Divider(height: 18),
                          Row(
                            children: [
                              const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                              const Spacer(),
                              Text(
                                formatLkr(provider.total + deliveryChargeLkr),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              if (!provider.isLoggedIn) {
                                Navigator.pushNamed(context, '/login');
                                return;
                              }
                              Navigator.pushNamed(context, '/checkout');
                            },
                            child: const Text('Proceed to Checkout'),
                          )
                        ],
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
