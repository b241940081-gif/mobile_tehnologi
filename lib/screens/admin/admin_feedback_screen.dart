import 'package:flutter/material.dart';

import '../../data/mock_orders.dart';

class AdminFeedbackScreen extends StatefulWidget {
  const AdminFeedbackScreen({super.key});

  @override
  State<AdminFeedbackScreen> createState() => _AdminFeedbackScreenState();
}

class _AdminFeedbackScreenState extends State<AdminFeedbackScreen> {
  String selectedFilter = 'Бүгд';

  final filters = const ['Бүгд', 'Талархал', 'Санал', 'Гомдол'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      appBar: AppBar(
        title: const Text('Үнэлгээ, санал хүсэлт'),
        backgroundColor: Colors.white,
      ),
      body: AnimatedBuilder(
        animation: MockOrders.instance,
        builder: (context, _) {
          final ratedOrders = MockOrders.instance.orders
              .where((order) => order.isRated)
              .where(
                (order) =>
                    selectedFilter == 'Бүгд' ||
                    order.feedbackType == selectedFilter,
              )
              .toList();

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  const Text(
                    'Хэрэглэгчдийн үнэлгээ',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    'Үйлчилгээний чанар болон санал хүсэлтийг хянах',
                    style: TextStyle(color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 22),

                  // Санал хүсэлтийн төрлөөр шүүх
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: filters.map((filter) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 9),
                          child: ChoiceChip(
                            label: Text(filter),
                            selected: selectedFilter == filter,
                            onSelected: (_) {
                              setState(() {
                                selectedFilter = filter;
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    'Нийт ${ratedOrders.length} үр дүн',
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 15),

                  if (ratedOrders.isEmpty)
                    _emptyState()
                  else
                    ...ratedOrders.map(_feedbackCard),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _feedbackCard(MockOrder order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFEAF2FF),
                child: Icon(order.icon, color: const Color(0xFF2563EB)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.service,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Захиалга: ${order.id}',
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: Color(0xFFF59E0B),
                    size: 25,
                  ),
                  Text(
                    '${order.rating}/10',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 30),

          // Санал хүсэлтийн төрөл
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: _feedbackColor(order.feedbackType).withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              order.feedbackType ?? 'Тодорхойгүй',
              style: TextStyle(
                color: _feedbackColor(order.feedbackType),
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ),

          const SizedBox(height: 14),

          Text(
            order.feedbackComment == null ||
                    order.feedbackComment!.trim().isEmpty
                ? 'Сэтгэгдэл үлдээгээгүй.'
                : order.feedbackComment!,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Color(0xFF334155),
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 15,
                color: Color(0xFF64748B),
              ),
              const SizedBox(width: 7),
              Text(
                order.ratedAt == null
                    ? 'Огноо байхгүй'
                    : _formatDate(order.ratedAt!),
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 55, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        children: [
          Icon(Icons.rate_review_outlined, size: 55, color: Color(0xFF94A3B8)),
          SizedBox(height: 15),
          Text(
            'Үнэлгээ олдсонгүй',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 8),
          Text(
            'Сонгосон төрөлд хамаарах үнэлгээ байхгүй байна.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  Color _feedbackColor(String? type) {
    switch (type) {
      case 'Талархал':
        return const Color(0xFF16A34A);
      case 'Санал':
        return const Color(0xFF2563EB);
      case 'Гомдол':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF64748B);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }
}
