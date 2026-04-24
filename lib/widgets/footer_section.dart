import 'package:flutter/material.dart';
import 'package:indian_tex/utils/app_theme.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightViolet.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Explore',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Pill(text: 'Men'),
              _Pill(text: 'Women'),
              _Pill(text: 'Accessories'),
              _Pill(text: 'Footwear'),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Contact: indiantex@gmail.com / 0777651323'),
          const SizedBox(height: 6),
          const Text('FAQ: Shipping, Returns, Size Guide, COD'),
          const SizedBox(height: 10),
          const Row(
            children: [
              Icon(Icons.facebook_outlined),
              SizedBox(width: 10),
              Icon(Icons.camera_alt_outlined),
              SizedBox(width: 10),
              Icon(Icons.play_circle_outline),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Copyright © 2026 Indian Tex. All rights reserved.',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(text),
    );
  }
}
