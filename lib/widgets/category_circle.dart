import 'package:flutter/material.dart';
import 'package:indian_tex/models/category_item.dart';

class CategoryCircle extends StatelessWidget {
  const CategoryCircle({
    super.key,
    required this.category,
    required this.onTap,
  });

  final CategoryItem category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ImageProvider providerImage = (category.imageUrl.startsWith('assets/')
        ? AssetImage(category.imageUrl)
        : NetworkImage(category.imageUrl)) as ImageProvider;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: SizedBox(
        width: 86,
        child: Column(
          children: [
            Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: providerImage,
                  fit: BoxFit.contain,
                ),
                color: const Color(0xFFFFF1DF),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withValues(alpha: 0.2),
                    blurRadius: 10,
                  )
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              category.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
