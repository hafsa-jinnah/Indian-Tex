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
    final provider = context.watch<ShopProvider>();

    // =========================
    // ORDER HISTORY LIST
    // =========================

    final allOrders = provider.orders;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
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

          child: allOrders.isEmpty
              ? const Center(
                  child: Text(
                    'No Orders Yet',
                  ),
                )

              : ListView.builder(
                  padding: const EdgeInsets.all(16),

                  itemCount: allOrders.length,

                  itemBuilder: (context, index) {
                    final currentOrder =
                        allOrders[index];

                    final firstItem =
                        currentOrder.items.first;

                    return Container(
                      margin:
                          const EdgeInsets.only(
                        bottom: 16,
                      ),

                      padding:
                          const EdgeInsets.all(14),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius:
                            BorderRadius.circular(
                          16,
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.brown
                                .withOpacity(
                              0.10,
                            ),

                            blurRadius: 14,

                            offset:
                                const Offset(0, 8),
                          )
                        ],
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          // ======================
                          // ORDER ID
                          // ======================

                          Text(
                            'Order ID: ${currentOrder.id}',

                            style: const TextStyle(
                              fontWeight:
                                  FontWeight.bold,

                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 12),

                          // ======================
                          // PRODUCT DETAILS
                          // ======================

                          Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [

                              // PRODUCT IMAGE

                              ClipRRect(
                                borderRadius:
                                    BorderRadius
                                        .circular(12),

                                child: Image.network(
                                  firstItem
                                      .product.imageUrl,

                                  width: 72,
                                  height: 72,

                                  fit: BoxFit.cover,

                                  errorBuilder:
                                      (
                                    context,
                                    error,
                                    stackTrace,
                                  ) {
                                    return Container(
                                      width: 72,
                                      height: 72,

                                      color:
                                          Colors.grey
                                              .shade200,

                                      child:
                                          const Icon(
                                        Icons
                                            .image_not_supported,
                                      ),
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(
                                width: 12,
                              ),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,

                                  children: [

                                    // PRODUCT NAME

                                    Text(
                                      firstItem
                                          .product.name,

                                      maxLines: 2,

                                      overflow:
                                          TextOverflow
                                              .ellipsis,

                                      style:
                                          const TextStyle(
                                        fontWeight:
                                            FontWeight
                                                .bold,

                                        fontSize: 15,
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 6,
                                    ),

                                    // SIZE / COLOR / QUANTITY

                                    Text(
                                      'Qty: ${firstItem.quantity}',
                                    ),

                                    Text(
                                      'Size: ${firstItem.size}',
                                    ),

                                    Text(
                                      'Color: ${firstItem.color}',
                                    ),

                                    const SizedBox(
                                      height: 6,
                                    ),

                                    // TOTAL PRICE

                                    Text(
                                      'Total: ${formatLkr(currentOrder.total)}',

                                      style:
                                          const TextStyle(
                                        color: Colors
                                            .deepPurple,

                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // ======================
                          // SHIPPING ADDRESS
                          // ======================

                          Container(
                            padding:
                                const EdgeInsets
                                    .all(12),

                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFFFF7E8,
                              ),

                              borderRadius:
                                  BorderRadius
                                      .circular(12),
                            ),

                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [

                                const Text(
                                  'Shipping Address',

                                  style: TextStyle(
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),

                                const SizedBox(
                                  height: 5,
                                ),

                                Text(
                                  currentOrder
                                      .shippingAddress,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // ======================
                          // TRACKING
                          // ======================

                          const Text(
                            'Tracking',

                            style: TextStyle(
                              fontWeight:
                                  FontWeight.bold,

                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 10),

                          _TrackingTimeline(
                            stage:
                                currentOrder.stage,
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}

class _TrackingTimeline extends StatelessWidget {
  const _TrackingTimeline({
    required this.stage,
  });

  final OrderStage stage;

  @override
  Widget build(BuildContext context) {
    const steps = [

      (
        OrderStage.packed,
        'Packed',
        Icons.inventory_2_outlined,
      ),

      (
        OrderStage.processing,
        'Processing',
        Icons.settings_suggest_outlined,
      ),

      (
        OrderStage.shipped,
        'Shipped',
        Icons.local_shipping_outlined,
      ),

      (
        OrderStage.delivered,
        'Delivered',
        Icons.verified_outlined,
      ),
    ];

    return Column(
      children: List.generate(
        steps.length,

        (index) {
          final s = steps[index];

          final done =
              stage.index > s.$1.index;

          final active =
              stage == s.$1;

          final color =
              done || active
                  ? const Color(
                      0xFF8C1D40,
                    )
                  : Colors.black26;

          return Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              // ======================
              // ICONS & LINE
              // ======================

              Column(
                children: [

                  Container(
                    width: 34,
                    height: 34,

                    decoration: BoxDecoration(
                      color: done
                          ? color
                          : Colors.white,

                      borderRadius:
                          BorderRadius.circular(
                        999,
                      ),

                      border: Border.all(
                        color: color,
                        width: 2,
                      ),
                    ),

                    child: Icon(
                      s.$3,

                      size: 18,

                      color: done
                          ? Colors.white
                          : color,
                    ),
                  ),

                  if (index !=
                      steps.length - 1)

                    Container(
                      width: 2,
                      height: 26,

                      color:
                          stage.index >=
                                  s.$1.index
                              ? const Color(
                                  0xFF8C1D40,
                                )
                              : Colors.black12,
                    ),
                ],
              ),

              const SizedBox(width: 10),

              // ======================
              // STEP TEXT
              // ======================

              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.only(
                    top: 7,
                  ),

                  child: Text(
                    s.$2,

                    style: TextStyle(
                      fontWeight: active
                          ? FontWeight.bold
                          : FontWeight.w600,

                      color:
                          done || active
                              ? Colors.black87
                              : Colors.black45,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}