import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:indian_tex/providers/shop_provider.dart';
import 'package:indian_tex/widgets/product_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:indian_tex/models/product.dart'; // 

class ProductListingScreen extends StatelessWidget {
  const ProductListingScreen({super.key});

  static const routeName = '/listing';

  @override
  Widget build(BuildContext context) {
    final queryArg =
        ModalRoute.of(context)?.settings.arguments as String?;
    final provider = context.watch<ShopProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(queryArg ?? 'All Products'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF6F1FF), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('products')
              .snapshots(),

          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData ||
                snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No products found"));
            }

            // ✅ FILTERING
            final docs = snapshot.data!.docs.where((doc) {
              final data = doc.data();

              if (queryArg == null || queryArg.isEmpty) {
                return true;
              }

              final name =
                  (data['name'] ?? '').toString().toLowerCase();
              final category =
                  (data['category'] ?? '').toString().toLowerCase();
              final query = queryArg.toLowerCase();

              return category == query || name.contains(query);
            }).toList();

            return Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.builder(
                itemCount: docs.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.62,
                ),
                itemBuilder: (context, index) {
                  final data = docs[index].data();

                  // 
                  final product = Product(
                    id: docs[index].id,
                    name: data['name'] ?? '',
                    price: (data['price'] ?? 0).toDouble(),
                    discountedPrice:
                        (data['discountedPrice'] ??
                                data['price'] ??
                                0)
                            .toDouble(),
                    category: data['category'] ?? '',
                    description: data['description'] ?? '',
                    imageUrl: data['image'] ?? '',
                    imageUrls: (data['imageUrls'] as List?)
                        ?.map((e) => e.toString())
                        .toList(),
                    clothType: data['clothType'] ?? '',
                    colors: (data['colors'] as List?)
                            ?.map((e) => e.toString())
                            .toList() ??
                        [],
                    sizes: (data['sizes'] as List?)
                            ?.map((e) => e.toString())
                            .toList() ??
                        [],
                    rating: (data['rating'] ?? 0).toDouble(),
                  );

                  return ProductCard(
                    product: product,
                    inWishlist: provider.wishlist.contains(product.id),
                    onWishlistTap: () =>
                        provider.toggleWishlist(product.id),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/details',
                        arguments: product,
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}