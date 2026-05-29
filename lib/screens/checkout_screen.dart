import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:indian_tex/models/cart_item.dart';
import 'package:indian_tex/models/product.dart';
import 'package:indian_tex/providers/shop_provider.dart';
import 'package:indian_tex/screens/order_tracking_screen.dart';
import 'package:indian_tex/utils/currency.dart';
import 'package:indian_tex/widgets/festive_pattern_background.dart';

enum PaymentMode { online, cod }

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  static const routeName = '/checkout';

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final formKey = GlobalKey<FormState>();

  PaymentMode mode = PaymentMode.cod;

  final fullNameCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final cardNoCtrl = TextEditingController();
  final holderCtrl = TextEditingController();
  final cvvCtrl = TextEditingController();

  @override
  void dispose() {
    fullNameCtrl.dispose();
    addressCtrl.dispose();
    cityCtrl.dispose();
    phoneCtrl.dispose();
    cardNoCtrl.dispose();
    holderCtrl.dispose();
    cvvCtrl.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final provider = context.read<ShopProvider>();
    final saved = provider.defaultShippingAddress;

    if (saved != null && addressCtrl.text.trim().isEmpty) {
      addressCtrl.text = saved;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ShopProvider>();

    final buyNowProduct =
        ModalRoute.of(context)?.settings.arguments as Product?;

    final subtotal = buyNowProduct?.discountedPrice ?? provider.total;

    final total = subtotal + deliveryChargeLkr;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: FestivePatternBackground(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFFF7E8),
                Colors.white,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Form(
            key: formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [

                // ======================
                // ORDER SUMMARY
                // ======================

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFFFE0B2),
                    ),
                  ),
                  child: Column(
                    children: [
                      _RowLine(
                        label: 'Subtotal',
                        value: formatLkr(subtotal),
                      ),

                      const SizedBox(height: 8),

                      _RowLine(
                        label: 'Delivery',
                        value: formatLkr(deliveryChargeLkr),
                      ),

                      const Divider(height: 18),

                      _RowLine(
                        label: 'Total',
                        value: formatLkr(total),
                        bold: true,
                        valueColor: Colors.deepPurple,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ======================
                // PAYMENT METHOD
                // ======================

                const Text(
                  'Payment Method',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                SegmentedButton<PaymentMode>(
                  segments: const [
                    ButtonSegment(
                      value: PaymentMode.online,
                      label: Text('Online'),
                      icon: Icon(Icons.credit_card),
                    ),
                    ButtonSegment(
                      value: PaymentMode.cod,
                      label: Text('Cash on Delivery'),
                      icon: Icon(Icons.local_shipping_outlined),
                    ),
                  ],
                  selected: {mode},
                  onSelectionChanged: (newValue) {
                    setState(() {
                      mode = newValue.first;
                    });
                  },
                ),

                const SizedBox(height: 20),

                // ======================
                // SHIPPING DETAILS
                // ======================

                const Text(
                  'Delivery Details',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                TextFormField(
                  controller: fullNameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                  ),
                  validator: _required,
                ),

                const SizedBox(height: 10),

                TextFormField(
                  controller: addressCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                  ),
                  validator: _required,
                ),

                const SizedBox(height: 10),

                TextFormField(
                  controller: cityCtrl,
                  decoration: const InputDecoration(
                    labelText: 'City',
                  ),
                  validator: _required,
                ),

                const SizedBox(height: 10),

                TextFormField(
                  controller: phoneCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Telephone Number',
                  ),
                  validator: _required,
                ),

                // ======================
                // CARD DETAILS
                // ======================

                if (mode == PaymentMode.online) ...[

                  const SizedBox(height: 20),

                  const Text(
                    'Card Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextFormField(
                    controller: cardNoCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Card Number',
                    ),
                    validator: (v) {
                      if (v == null ||
                          v.replaceAll(' ', '').length < 12) {
                        return 'Enter valid card number';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 10),

                  TextFormField(
                    controller: holderCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Card Holder Name',
                    ),
                    validator: _required,
                  ),

                  const SizedBox(height: 10),

                  TextFormField(
                    controller: cvvCtrl,
                    decoration: const InputDecoration(
                      labelText: 'CVV',
                    ),
                    validator: (v) {
                      if (v == null || v.length < 3) {
                        return 'Enter valid CVV';
                      }

                      return null;
                    },
                  ),
                ],

                const SizedBox(height: 24),

                // ======================
                // PLACE ORDER BUTTON
                // ======================

                ElevatedButton(
                  onPressed: () async {

                    if (!(formKey.currentState?.validate() ?? false)) {
                      return;
                    }

                    provider.setDefaultShippingAddress(
                      addressCtrl.text,
                    );

                    final items = buyNowProduct == null
                        ? List<CartItem>.from(provider.cartItems)
                        : [
                            CartItem(
                              product: buyNowProduct,
                              size: buyNowProduct.sizes.first,
                              color: buyNowProduct.colors.first,
                              quantity: 1,
                            ),
                          ];

                    final order = await context
                        .read<ShopProvider>()
                        .placeOrder(
                          items: items,
                          shippingAddress:
                              "${addressCtrl.text.trim()}, ${cityCtrl.text.trim()}",
                        );

                    if (buyNowProduct == null) {
                      context.read<ShopProvider>().clearCart();
                    }

                    if (!mounted) return;

                    showDialog<void>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text(
                          'Order Successful',
                        ),
                        content: Text(
                          mode == PaymentMode.online
                              ? 'Online payment completed successfully.'
                              : 'Order placed successfully with Cash on Delivery.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {

                              Navigator.pop(context);

                              Navigator.pushNamed(
                                context,
                                OrderTrackingScreen.routeName,
                                arguments: order.id,
                              );
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text(
                    'Pay / Place Order',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }

    return null;
  }
}

class _RowLine extends StatelessWidget {
  const _RowLine({
    required this.label,
    required this.value,
    this.bold = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool bold;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontWeight: bold
          ? FontWeight.bold
          : FontWeight.w600,
    );

    return Row(
      children: [
        Text(
          label,
          style: style,
        ),

        const Spacer(),

        Text(
          value,
          style: style.copyWith(
            color: valueColor,
          ),
        ),
      ],
    );
  }
}