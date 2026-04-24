import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:indian_tex/providers/shop_provider.dart';
import 'package:indian_tex/widgets/product_card.dart';

class ProductListingScreen extends StatelessWidget {
  const ProductListingScreen({super.key});

  static const routeName = '/listing';

  @override
  Widget build(BuildContext context) {
    final queryArg = ModalRoute.of(context)?.settings.arguments as String?;
    final provider = context.watch<ShopProvider>();
    final isCategory = queryArg != null &&
        provider.categories.any((category) => category.name == queryArg);
    final products = queryArg == null
        ? provider.products
        : isCategory
            ? provider.productsByCategory(queryArg)
            : provider.searchProducts(queryArg);

    return Scaffold(
      appBar: AppBar(title: Text(queryArg ?? 'All Products')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF6F1FF), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: GridView.builder(
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.62,
            ),
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                product: product,
                inWishlist: provider.wishlist.contains(product.id),
                onWishlistTap: () => provider.toggleWishlist(product.id),
                onTap: () => Navigator.pushNamed(context, '/details', arguments: product),
              );
            },
          ),
        ),
      ),
    );
  }
}
