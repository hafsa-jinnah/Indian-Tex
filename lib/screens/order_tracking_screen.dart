import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:indian_tex/models/order.dart';
import 'package:indian_tex/providers/shop_provider.dart';
import 'package:indian_tex/utils/currency.dart';
import 'package:indian_tex/widgets/festive_pattern_background.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  static const routeName = '/order-tracking';

  @override
  Widget build(BuildContext context) {
    final orderId = ModalRoute.of(context)!.settings.arguments as String;
    final provider = context.watch<ShopProvider>();
    final order = provider.orders.firstWhere(
      (o) => o.id == orderId,
      orElse: () => Order(
        id: orderId,
        items: const [],
        shippingAddress: '',
        placedAt: DateTime.now(),
        deliveryCharge: deliveryChargeLkr.toDouble(),
        stage: OrderStage.packed,
      ),
    );
    if (order.items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Order $orderId')),
        body: const Center(child: Text('Order not found')),
      );
    }
    final firstItem = order.items.first;

    return Scaffold(
      appBar: AppBar(title: Text('Order ${order.id}')),
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
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.brown.withValues(alpha: 0.10),
                      blurRadius: 14,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        firstItem.product.imageUrl,
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            firstItem.product.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text('Qty: ${firstItem.quantity} • Size: ${firstItem.size} • ${firstItem.color}'),
                          const SizedBox(height: 4),
                          Text(
                            'Total: ${formatLkr(order.total)}',
                            style: const TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFFE0B2)),
                ),
                child: Column(
                  children: [
                    _RowLine(label: 'Subtotal', value: formatLkr(order.subtotal)),
                    const SizedBox(height: 8),
                    _RowLine(label: 'Delivery', value: formatLkr(order.deliveryCharge)),
                    const Divider(height: 18),
                    _RowLine(
                      label: 'Total',
                      value: formatLkr(order.total),
                      bold: true,
                      valueColor: Colors.deepPurple,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFFE0B2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Shipping Address', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(order.shippingAddress),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text('Tracking', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              _TrackingTimeline(stage: order.stage),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1DF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Status updates automatically while your order moves through packing, shipping and delivery.',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
    final style = TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.w600);
    return Row(
      children: [
        Text(label, style: style),
        const Spacer(),
        Text(value, style: style.copyWith(color: valueColor)),
      ],
    );
  }
}

class _TrackingTimeline extends StatelessWidget {
  const _TrackingTimeline({required this.stage});

  final OrderStage stage;

  @override
  Widget build(BuildContext context) {
    const steps = [
      (OrderStage.packed, 'Packed', Icons.inventory_2_outlined),
      (OrderStage.processing, 'Processing', Icons.settings_suggest_outlined),
      (OrderStage.shipped, 'Shipped', Icons.local_shipping_outlined),
      (OrderStage.delivered, 'Delivered', Icons.verified_outlined),
    ];

    return Column(
      children: List.generate(steps.length, (index) {
        final s = steps[index];
        final done = stage.index > s.$1.index;
        final active = stage == s.$1;
        final color = done || active ? const Color(0xFF8C1D40) : Colors.black26;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: done ? color : Colors.white,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: color, width: 2),
                  ),
                  child: Icon(
                    s.$3,
                    size: 18,
                    color: done ? Colors.white : color,
                  ),
                ),
                if (index != steps.length - 1)
                  Container(
                    width: 2,
                    height: 26,
                    color: stage.index >= s.$1.index ? const Color(0xFF8C1D40) : Colors.black12,
                  ),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 7),
                child: Text(
                  s.$2,
                  style: TextStyle(
                    fontWeight: active ? FontWeight.bold : FontWeight.w600,
                    color: done || active ? Colors.black87 : Colors.black45,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

