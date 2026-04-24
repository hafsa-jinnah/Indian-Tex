import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:indian_tex/models/order.dart';
import 'package:indian_tex/providers/shop_provider.dart';
import 'package:indian_tex/screens/order_tracking_screen.dart';
import 'package:indian_tex/utils/currency.dart';
import 'package:indian_tex/widgets/festive_pattern_background.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ShopProvider>();
    if (!provider.isLoggedIn) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Profile')),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, size: 50, color: Color(0xFF8C1D40)),
                const SizedBox(height: 10),
                const Text(
                  'Please login to access your festive profile.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  child: const Text('Login'),
                ),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  child: const Text('Create Account'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final items = <(String, String, IconData, Widget)>[
      (
        'My Orders',
        'Track delivery status in real time.',
        Icons.inventory_2_outlined,
        const _MyOrdersScreen(),
      ),
      (
        'My Wishlist',
        'Explore your curated style picks.',
        Icons.favorite_outline,
        const _MyWishlistScreen(),
      ),
      (
        'Settings',
        'Change app appearance and options.',
        Icons.settings_outlined,
        const _SettingsScreen(),
      ),
      (
        'Help Center',
        'Ask questions and get support.',
        Icons.support_agent_outlined,
        const _HelpCenterScreen(),
      ),
      (
        'Shipping Address',
        'Add, edit, delete, or change addresses.',
        Icons.local_shipping_outlined,
        const _ShippingAddressScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: FestivePatternBackground(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFF7E8), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: ListView.builder(
            padding: const EdgeInsets.all(14),
            itemCount: items.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8C1D40), Color(0xFFD17B0F)],
                    ),
                  ),
                  child: const Text(
                    'Namaste! Welcome to your festive Indian Tex profile.',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                );
              }
              final item = items[index - 1];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFFE0B2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepOrange.withValues(alpha: 0.08),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Icon(item.$3, color: const Color(0xFF8C1D40)),
                  title: Text(item.$1),
                  subtitle: Text(item.$2),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => item.$4));
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _MyOrdersScreen extends StatelessWidget {
  const _MyOrdersScreen();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ShopProvider>();
    final orders = provider.orders;
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: orders.isEmpty
          ? const Center(
              child: Text(
                'No orders yet.\nPlace an order to start tracking here.',
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(14),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final firstItem = order.items.first;
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFFE0B2)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepOrange.withValues(alpha: 0.06),
                        blurRadius: 14,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        firstItem.product.imageUrl,
                        width: 52,
                        height: 52,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text('Order ${order.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      '${_stageLabel(order.stage)} • ${formatLkr(order.total)} • ${firstItem.quantity} item(s)',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        OrderTrackingScreen.routeName,
                        arguments: order.id,
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

String _stageLabel(OrderStage stage) {
  switch (stage) {
    case OrderStage.packed:
      return 'Packed';
    case OrderStage.processing:
      return 'Processing';
    case OrderStage.shipped:
      return 'Shipped';
    case OrderStage.delivered:
      return 'Delivered';
  }
}

class _MyWishlistScreen extends StatelessWidget {
  const _MyWishlistScreen();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ShopProvider>();
    final wishlistProducts = provider.products
        .where((product) => provider.wishlist.contains(product.id))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('My Wishlist')),
      body: wishlistProducts.isEmpty
          ? const Center(
              child: Text(
                'No saved styles yet.\nTap heart on products to build your fashion board.',
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(14),
              itemCount: wishlistProducts.length,
              itemBuilder: (context, index) {
                final product = wishlistProducts[index];
                return Card(
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(product.imageUrl, width: 48, height: 48, fit: BoxFit.cover),
                    ),
                    title: Text(product.name),
                    subtitle: Text('Top Match for your style: ${product.category}'),
                    trailing: const Icon(Icons.auto_awesome, color: Colors.deepPurple),
                  ),
                );
              },
            ),
    );
  }
}

class _SettingsScreen extends StatefulWidget {
  const _SettingsScreen();

  @override
  State<_SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<_SettingsScreen> {
  bool notifications = true;
  bool orderAlerts = true;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ShopProvider>();
    final colors = <Color>[
      const Color(0xFF8C1D40),
      const Color(0xFFD17B0F),
      const Color(0xFF6C3BFF),
      const Color(0xFF0D7A6B),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            value: provider.darkMode,
            title: const Text('Dark Mode'),
            onChanged: provider.setDarkMode,
          ),
          SwitchListTile(
            value: notifications,
            title: const Text('App Notifications'),
            onChanged: (value) => setState(() => notifications = value),
          ),
          SwitchListTile(
            value: orderAlerts,
            title: const Text('Delivery Alerts'),
            onChanged: (value) => setState(() => orderAlerts = value),
          ),
          const ListTile(
            title: Text('Language'),
            subtitle: Text('English'),
          ),
          const ListTile(
            title: Text('Privacy'),
            subtitle: Text('Manage data and permissions'),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Choose App Color',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Wrap(
            spacing: 10,
            children: colors
                .map(
                  (color) => GestureDetector(
                    onTap: () => provider.setAccentColor(color),
                    child: Container(
                      margin: const EdgeInsets.only(left: 16, bottom: 8),
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: provider.accentColor == color
                              ? Colors.black
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _HelpCenterScreen extends StatefulWidget {
  const _HelpCenterScreen();

  @override
  State<_HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<_HelpCenterScreen> {
  final questionCtrl = TextEditingController();

  @override
  void dispose() {
    questionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help Center')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ask a question',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: questionCtrl,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Type your question about the app, orders, payment, or returns.',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (questionCtrl.text.trim().isEmpty) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Question submitted to support team')),
                );
                questionCtrl.clear();
              },
              child: const Text('Submit Question'),
            ),
            const SizedBox(height: 18),
            const Text('Quick Help'),
            const SizedBox(height: 8),
            const Text('• Delivery: 3-5 working days'),
            const Text('• Return Window: 7 days'),
            const Text('• Contact: support@indiantex.app'),
          ],
        ),
      ),
    );
  }
}

class _ShippingAddressScreen extends StatefulWidget {
  const _ShippingAddressScreen();

  @override
  State<_ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<_ShippingAddressScreen> {
  final addresses = <String>[
    'No 21, Lake Road, Colombo - 05 | +94 77 123 4567',
    '45, Main Street, Kandy | +94 71 890 1122',
  ];

  void _showAddressDialog({String? initial, int? index}) {
    final controller = TextEditingController(text: initial ?? '');
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(index == null ? 'Add Address' : 'Edit Address'),
          content: TextField(
            controller: controller,
            maxLines: 3,
            decoration: const InputDecoration(hintText: 'Name, address, phone'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final value = controller.text.trim();
                if (value.isEmpty) return;
                setState(() {
                  if (index == null) {
                    addresses.add(value);
                  } else {
                    addresses[index] = value;
                  }
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shipping Address')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddressDialog(),
        label: const Text('Add'),
        icon: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: addresses.length,
        itemBuilder: (context, index) {
          final address = addresses[index];
          return Card(
            child: ListTile(
              title: Text(address),
              subtitle: index == 0 ? const Text('Current default address') : null,
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    _showAddressDialog(initial: address, index: index);
                  } else if (value == 'delete') {
                    setState(() => addresses.removeAt(index));
                  } else if (value == 'change') {
                    setState(() {
                      final selected = addresses.removeAt(index);
                      addresses.insert(0, selected);
                    });
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                  PopupMenuItem(value: 'change', child: Text('Change as default')),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

