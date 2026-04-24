import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:indian_tex/models/product.dart';
import 'package:indian_tex/providers/shop_provider.dart';
import 'package:indian_tex/utils/currency.dart';
import 'package:indian_tex/widgets/festive_pattern_background.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  static const routeName = '/details';

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String? selectedSize;
  String? selectedColor;
  int qty = 1;
  final _pageController = PageController();
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    selectedSize ??= product.sizes.first;
    selectedColor ??= product.colors.first;
    final provider = context.watch<ShopProvider>();
    final images = product.allImages;

    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: FestivePatternBackground(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFF7E8), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
          Hero(
            tag: 'product_${product.id}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 280,
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: images.length,
                      onPageChanged: (value) => setState(() => _page = value),
                      itemBuilder: (context, index) => Container(
                        color: const Color(0xFFFFF1DF),
                        alignment: Alignment.center,
                        child: Image.network(
                          images[index],
                          height: 280,
                          fit: BoxFit.contain,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 10,
                      right: 10,
                      bottom: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          images.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: _page == index ? 18 : 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: _page == index ? Colors.white : Colors.white70,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(product.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(child: Text(product.category)),
              IconButton(
                onPressed: () => provider.toggleWishlist(product.id),
                icon: Icon(
                  provider.wishlist.contains(product.id)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.pink,
                ),
              ),
              const Icon(Icons.star_rounded, color: Colors.amber),
              Text(
                product.rating.toStringAsFixed(1),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text('Price: ${formatLkr(product.price)}'),
          Text(
            'Discounted: ${formatLkr(product.discountedPrice)}',
            style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Delivery charge: ${formatLkr(deliveryChargeLkr)}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Text('Cloth: ${product.clothType}'),
          const SizedBox(height: 8),
          const Text('Colour'),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            initialValue: selectedColor,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.palette_outlined),
              hintText: 'Select colour',
            ),
            items: product.colors
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (value) => setState(() => selectedColor = value),
          ),
          const SizedBox(height: 12),
          const Text('Select Size'),
          Wrap(
            spacing: 8,
            children: product.sizes
                .map(
                  (size) => ChoiceChip(
                    label: Text(size),
                    selected: selectedSize == size,
                    onSelected: (_) => setState(() => selectedSize = size),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          const Text('Quantity'),
          const SizedBox(height: 6),
          Row(
            children: [
              IconButton(
                onPressed: qty <= 1 ? null : () => setState(() => qty -= 1),
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFFE0B2)),
                ),
                child: Text(
                  '$qty',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                onPressed: () => setState(() => qty += 1),
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _InfoChip(icon: Icons.local_shipping_outlined, text: 'Delivery 3–5 days'),
              _InfoChip(icon: Icons.autorenew_rounded, text: '7-day returns'),
              _InfoChip(icon: Icons.verified_outlined, text: 'Premium quality'),
            ],
          ),
          const SizedBox(height: 14),
          Text(product.description),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    if (!provider.isLoggedIn) {
                      Navigator.pushNamed(context, '/login');
                      return;
                    }
                    provider.addToCart(
                      product,
                      size: selectedSize!,
                      color: selectedColor!,
                      quantity: qty,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Added to cart')),
                    );
                  },
                  child: const Text('Add to Cart'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (!provider.isLoggedIn) {
                      Navigator.pushNamed(context, '/login');
                      return;
                    }
                    Navigator.pushNamed(context, '/checkout', arguments: product);
                  },
                  child: const Text('Buy Now'),
                ),
              ),
            ],
          )
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFFFE0B2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF8C1D40)),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
