import 'package:flutter/material.dart';
import 'package:indian_tex/models/cart_item.dart';
import 'package:indian_tex/utils/currency.dart';

class CartItemWidget extends StatelessWidget {
  const CartItemWidget({
    super.key,
    required this.item,
    required this.onDecrease,
    required this.onIncrease,
    required this.onDelete,
  });

  final CartItem item;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              item.product.imageUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                Text('Size: ${item.size} • Color: ${item.color}'),
                Text(
                  formatLkr(item.product.discountedPrice),
                  style: const TextStyle(color: Colors.deepPurple),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  IconButton(onPressed: onDecrease, icon: const Icon(Icons.remove_circle_outline)),
                  Text('${item.quantity}'),
                  IconButton(onPressed: onIncrease, icon: const Icon(Icons.add_circle_outline)),
                ],
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              ),
            ],
          )
        ],
      ),
    );
  }
}
