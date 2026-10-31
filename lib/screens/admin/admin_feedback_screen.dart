import 'package:flutter/material.dart';

import '../../data/mock_orders.dart';

class AdminFeedbackScreen extends StatefulWidget {
  const AdminFeedbackScreen({super.key});

  @override
  State<AdminFeedbackScreen> createState() => _AdminFeedbackScreenState();
}

class _AdminFeedbackScreenState extends State<AdminFeedbackScreen> {
  static const Color primary = Color(0xFF078ED3);
  static const Color dark = Color(0xFF182F53);
  static const Color muted = Color(0xFF7892AD);
  static const Color background = Color(0xFFF1F9FF);
  static const Color border = Color(0xFFD9EAF7);

  String selectedFilter = 'Бүгд';

  final filters = const ['Бүгд', 'Талархал', 'Санал', 'Гомдол'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          'Үнэлгээ, санал хүсэлт',
          style: TextStyle(fontWeight: FontWeight.w800, color: dark),
        ),
        backgroundColor: Colors.white,
        foregroundColor: dark,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: AnimatedBuilder(
        animation: MockOrders.instance,
        builder: (context, _) {
          final allRated = MockOrders.instance.orders
              .where((order) => order.isRated)
              .toList();

          final ratedOrders = allRated
              .where(
                (order) =>
                    selectedFilter == 'Бүгд' ||
                    order.feedbackType == selectedFilter,
              )
              .toList();

          final total = allRated.length;

          final average = total == 0
              ? 0.0
              : allRated.fold<int>(
                      0,
                      (sum, order) => sum + (order.rating ?? 0),
                    ) /
                    total;

          final thanks = allRated
              .where((order) => order.feedbackType == 'Талархал')
              .length;

          final suggestions = allRated
              .where((order) => order.feedbackType == 'Санал')
              .length;

          final complaints = allRated
              .where((order) => order.feedbackType == 'Гомдол')
              .length;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 36),
                children: [
                  _heroBanner(total, average),
                  const SizedBox(height: 26),
                  _sectionHeading(
                    Icons.insights_rounded,
                    'Үнэлгээний тойм',
                    'Хэрэглэгчдийн санал хүсэлтийн үзүүлэлт',
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final columns = constraints.maxWidth >= 600 ? 4 : 2;

                      return GridView.count(
                        crossAxisCount: columns,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: columns == 4 ? 1.3 : 1.25,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _statCard(
                            'Нийт үнэлгээ',
                            '$total',
                            Icons.rate_review_rounded,
                            primary,
                          ),
                          _statCard(
                            'Талархал',
                            '$thanks',
                            Icons.favorite_rounded,
                            const Color(0xFF12A65A),
                          ),
                          _statCard(
                            'Санал',
                            '$suggestions',
                            Icons.lightbulb_rounded,
                            const Color(0xFF2563EB),
                          ),
                          _statCard(
                            'Гомдол',
                            '$complaints',
                            Icons.report_problem_rounded,
                            const Color(0xFFEF4444),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  _sectionHeading(
                    Icons.chat_bubble_outline_rounded,
                    'Хэрэглэгчдийн сэтгэгдэл',
                    'Үнэлгээг төрлөөр нь ангилан хараарай',
                  ),
                  const SizedBox(height: 18),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: filters.map((filter) {
                        return _filterChip(filter);
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Санал хүсэлтийн жагсаалт',
                          style: TextStyle(
                            color: dark,
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDDF4FF),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          '${ratedOrders.length} үр дүн',
                          style: const TextStyle(
                            color: primary,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
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

  Widget _heroBanner(int total, double average) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF13B5E9), Color(0xFF0573B6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.14),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.20),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_rounded, color: Colors.white, size: 17),
                SizedBox(width: 7),
                Text(
                  'TUSGO ADMIN',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Хэрэглэгчдийн үнэлгээ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 9),
          const Text(
            'Үйлчилгээний чанар, талархал, санал болон '
            'гомдлыг нэг дороос хянаарай.',
            style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.17),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: Color(0xFFFFD66B),
                  size: 39,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${average.toStringAsFixed(1)} / 10',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'Дундаж үнэлгээ • Нийт $total үнэлгээ',
                        style: const TextStyle(
                          color: Color(0xFFE2F5FF),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeading(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: const Color(0xFFDCF4FF),
            borderRadius: BorderRadius.circular(17),
          ),
          child: Icon(icon, color: primary, size: 26),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: dark,
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(color: muted, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A7DB2).withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: color, size: 25),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: const TextStyle(
              color: muted,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String filter) {
    final selected = selectedFilter == filter;

    return Padding(
      padding: const EdgeInsets.only(right: 9),
      child: ChoiceChip(
        label: Text(filter),
        selected: selected,
        showCheckmark: false,
        backgroundColor: Colors.white,
        selectedColor: primary,
        side: BorderSide(color: selected ? primary : border),
        labelStyle: TextStyle(
          color: selected ? Colors.white : muted,
          fontWeight: FontWeight.w800,
          fontSize: 13,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        onSelected: (_) {
          setState(() {
            selectedFilter = filter;
          });
        },
      ),
    );
  }

  Widget _feedbackCard(MockOrder order) {
    final typeColor = _feedbackColor(order.feedbackType);
    final typeIcon = _feedbackIcon(order.feedbackType);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A7DB2).withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFDCF4FF),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(order.icon, color: primary, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.service,
                      style: const TextStyle(
                        color: dark,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Захиалга #${order.id}',
                      style: const TextStyle(color: muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: Color(0xFFFFA000),
                    size: 25,
                  ),
                  Text(
                    '${order.rating ?? 0}/10',
                    style: const TextStyle(
                      color: dark,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(typeIcon, color: typeColor, size: 17),
                    const SizedBox(width: 7),
                    Text(
                      order.feedbackType ?? 'Тодорхойгүй',
                      style: TextStyle(
                        color: typeColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (order.ratedAt != null)
                Flexible(
                  child: Text(
                    _formatDate(order.ratedAt!),
                    textAlign: TextAlign.end,
                    style: const TextStyle(color: muted, fontSize: 11),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              order.feedbackComment == null ||
                      order.feedbackComment!.trim().isEmpty
                  ? 'Сэтгэгдэл үлдээгээгүй.'
                  : order.feedbackComment!,
              style: const TextStyle(color: dark, fontSize: 14, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 55, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: border),
      ),
      child: const Column(
        children: [
          Icon(Icons.rate_review_outlined, size: 58, color: primary),
          SizedBox(height: 16),
          Text(
            'Үнэлгээ олдсонгүй',
            style: TextStyle(
              color: dark,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Сонгосон төрөлд хамаарах үнэлгээ байхгүй байна.',
            textAlign: TextAlign.center,
            style: TextStyle(color: muted, height: 1.5),
          ),
        ],
      ),
    );
  }

  IconData _feedbackIcon(String? type) {
    switch (type) {
      case 'Талархал':
        return Icons.favorite_rounded;
      case 'Санал':
        return Icons.lightbulb_outline_rounded;
      case 'Гомдол':
        return Icons.warning_amber_rounded;
      default:
        return Icons.chat_bubble_outline_rounded;
    }
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
        return muted;
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
