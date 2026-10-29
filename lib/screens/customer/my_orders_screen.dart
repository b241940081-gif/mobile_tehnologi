import 'package:flutter/material.dart';

import '../../data/mock_orders.dart';
import 'order_details_screen.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  OrderStatus? filter;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: MockOrders.instance,
      builder: (context, _) {
        final allOrders = MockOrders.instance.orders;

        final orders = allOrders
            .where((order) => filter == null || order.status == filter)
            .toList();

        final cancelledCount = allOrders
            .where((order) => order.status == OrderStatus.cancelled)
            .length;

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'Миний захиалгууд',
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Захиалгын мэдээлэл болон явцыг хянах',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),

                // Захиалгын тоон мэдээлэл
                Row(
                  children: [
                    Expanded(
                      child: _summaryCard(
                        title: 'Нийт захиалга',
                        count: allOrders.length,
                        icon: Icons.receipt_long_outlined,
                        color: const Color(0xFF2563EB),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _summaryCard(
                        title: 'Цуцлагдсан',
                        count: cancelledCount,
                        icon: Icons.cancel_outlined,
                        color: const Color(0xFFDC2626),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                // Захиалгын төлөвөөр шүүх
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ChoiceChip(
                        label: const Text('Бүгд'),
                        selected: filter == null,
                        onSelected: (_) {
                          setState(() => filter = null);
                        },
                      ),
                      const SizedBox(width: 8),
                      ...OrderStatus.values.map(
                        (status) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(status.label),
                            selected: filter == status,
                            onSelected: (_) {
                              setState(() => filter = status);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                if (orders.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(child: Text('Захиалга олдсонгүй')),
                  ),

                ...orders.map((order) => _orderCard(order)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _summaryCard({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.20)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderCard(MockOrder order) {
    final isCancelled = order.status == OrderStatus.cancelled;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: isCancelled
              ? const Color(0xFFFCA5A5)
              : const Color(0xFFE2E8F0),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => OrderDetailsScreen(order: order)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: isCancelled
                        ? const Color(0xFFFEE2E2)
                        : const Color(0xFFEAF2FF),
                    child: Icon(
                      order.icon,
                      color: isCancelled
                          ? const Color(0xFFDC2626)
                          : const Color(0xFF2563EB),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      order.service,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: order.status.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        order.status.label,
                        style: TextStyle(
                          color: order.status.color,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('Захиалга #${order.id}'),
              const SizedBox(height: 6),
              Text(
                '${order.date.year}.'
                '${order.date.month.toString().padLeft(2, '0')}.'
                '${order.date.day.toString().padLeft(2, '0')}'
                '  •  ${order.startTime}–${order.endTime}',
                style: const TextStyle(color: Colors.grey),
              ),

              // Цуцалсан шалтгаан
              if (isCancelled) ...[
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 18,
                        color: Color(0xFFDC2626),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Цуцалсан шалтгаан: '
                          '${order.cancellationReason ?? "-"}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF991B1B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const Divider(height: 28),

              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Дэлгэрэнгүй харах',
                    style: TextStyle(
                      color: Color(0xFF2563EB),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 5),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: Color(0xFF2563EB),
                    size: 18,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
