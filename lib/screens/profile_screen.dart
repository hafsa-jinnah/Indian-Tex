import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
                const Icon(
                  Icons.lock_outline,
                  size: 50,
                  color: Color(0xFF8C1D40),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Please login to access your festive profile.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/login'),
                  child: const Text('Login'),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/register'),
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
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final userData =
              snapshot.data?.data() as Map<String, dynamic>?;

          final userName = userData?['name'] ?? 'User';

          final userEmail =
              userData?['email'] ?? 'No Email';

          final userPhone =
              userData?['telephone'] ?? 'No Phone';

          return FestivePatternBackground(
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
              child: ListView.builder(
                padding: const EdgeInsets.all(14),
                itemCount: items.length + 2,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
                      margin:
                          const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF8C1D40),
                            Color(0xFFD17B0F),
                          ],
                        ),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              size: 35,
                              color: Color(0xFF8C1D40),
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  userEmail,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  userPhone,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          IconButton(
                            onPressed: () {
                              _showEditProfileDialog(
                                context,
                                userName,
                                userPhone,
                              );
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (index == items.length + 1) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          minimumSize:
                              const Size.fromHeight(50),
                        ),
                        onPressed: () async {
                          await provider.logout();

                          if (!context.mounted) return;

                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (route) => false,
                          );
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text('Logout'),
                      ),
                    );
                  }

                  final item = items[index - 1];

                  return Container(
                    margin:
                        const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFFFE0B2),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepOrange
                              .withOpacity(0.08),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Icon(
                        item.$3,
                        color: const Color(0xFF8C1D40),
                      ),
                      title: Text(item.$1),
                      subtitle: Text(item.$2),
                      trailing: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => item.$4,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _showEditProfileDialog(
    BuildContext context,
    String currentName,
    String currentPhone,
  ) {
    final nameController =
        TextEditingController(text: currentName);

    final phoneController =
        TextEditingController(text: currentPhone);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Telephone',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth
                        .instance.currentUser!.uid)
                    .update({
                  'name':
                      nameController.text.trim(),
                  'telephone':
                      phoneController.text.trim(),
                });

                if (!context.mounted) return;

                Navigator.pop(context);

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content:
                        Text('Profile Updated'),
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
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
              child: Text('No orders yet.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(14),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final firstItem = order.items.first;

                return Card(
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(8),
                      child: Image.network(
                        firstItem.product.imageUrl,
                        width: 55,
                        height: 55,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) {
                          return Container(
                            width: 55,
                            height: 55,
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.image),
                          );
                        },
                      ),
                    ),
                    title: Text(
                      'Order ${order.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${_stageLabel(order.stage)} • ${formatLkr(order.total)}',
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),
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
        .where(
          (product) =>
              provider.wishlist.contains(product.id),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('My Wishlist')),
      body: wishlistProducts.isEmpty
          ? const Center(
              child: Text('No wishlist items'),
            )
          : ListView.builder(
              itemCount: wishlistProducts.length,
              itemBuilder: (context, index) {
                final product =
                    wishlistProducts[index];

                return Card(
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(8),
                      child: Image.network(
                        product.imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(product.name),
                    subtitle: Text(product.category),
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
  State<_SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<_SettingsScreen> {
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
            onChanged: (value) {
              setState(() {
                notifications = value;
              });
            },
          ),

          SwitchListTile(
            value: orderAlerts,
            title: const Text('Delivery Alerts'),
            onChanged: (value) {
              setState(() {
                orderAlerts = value;
              });
            },
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              8,
            ),
            child: Text(
              'Choose App Color',
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          Wrap(
            spacing: 10,
            children: colors
                .map(
                  (color) => GestureDetector(
                    onTap: () =>
                        provider.setAccentColor(color),
                    child: Container(
                      margin: const EdgeInsets.only(
                        left: 16,
                        bottom: 8,
                      ),
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              provider.accentColor ==
                                      color
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
  State<_HelpCenterScreen> createState() =>
      _HelpCenterScreenState();
}

class _HelpCenterScreenState
    extends State<_HelpCenterScreen> {
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
      body: FestivePatternBackground(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFFFE0B2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ask a Question',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: questionCtrl,
                      maxLines: 4,
                      decoration:
                          const InputDecoration(
                        hintText:
                            'Type your question here',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Question Submitted',
                            ),
                          ),
                        );
                      },
                      child:
                          const Text('Submit'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShippingAddressScreen extends StatefulWidget {
  const _ShippingAddressScreen();

  @override
  State<_ShippingAddressScreen> createState() =>
      _ShippingAddressScreenState();
}

class _ShippingAddressScreenState
    extends State<_ShippingAddressScreen> {
  final List<String> addresses = [
    'No 21, Lake Road, Colombo',
  ];

  void _showAddressDialog({
    String? initial,
    int? index,
  }) {
    final controller =
        TextEditingController(text: initial ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            index == null
                ? 'Add Address'
                : 'Edit Address',
          ),
          content: TextField(
            controller: controller,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Enter Address',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context),
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                final value =
                    controller.text.trim();

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
      appBar:
          AppBar(title: const Text('Shipping Address')),

      floatingActionButton:
          FloatingActionButton(
        backgroundColor:
            const Color(0xFF8C1D40),
        onPressed: () {
          _showAddressDialog();
        },
        child: const Icon(Icons.add),
      ),

      body: FestivePatternBackground(
        child: ListView.builder(
          padding: const EdgeInsets.all(14),
          itemCount: addresses.length,
          itemBuilder: (context, index) {
            final address = addresses[index];

            return Container(
              margin:
                  const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFFFE0B2),
                ),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.location_on,
                  color: Color(0xFF8C1D40),
                ),

                title: Text(address),

                trailing:
                    PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showAddressDialog(
                        initial: address,
                        index: index,
                      );
                    }

                    if (value == 'delete') {
                      setState(() {
                        addresses.removeAt(index);
                      });
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}