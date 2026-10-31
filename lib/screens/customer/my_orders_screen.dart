import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/mock_orders.dart';
import 'order_details_screen.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  OrderStatus? filter;

  String _formatDate(DateTime date) {
    return '${date.year}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.day.toString().padLeft(2, '0')}';
  }

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

        final completedCount = allOrders
            .where((order) => order.status == OrderStatus.completed)
            .length;

        return ColoredBox(
          color: AppColors.background,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 22, 18, 35),
                children: [
                  _header(),
                  const SizedBox(height: 22),
                  _summarySection(
                    total: allOrders.length,
                    completed: completedCount,
                    cancelled: cancelledCount,
                  ),
                  const SizedBox(height: 29),
                  _sectionHeading(),
                  const SizedBox(height: 16),
                  _filters(),
                  const SizedBox(height: 20),
                  if (orders.isEmpty)
                    _emptyState()
                  else
                    ...orders.map(_orderCard),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(27),
        boxShadow: const [
          BoxShadow(
            color: Color(0x23078BD3),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -75,
            right: -45,
            child: Container(
              width: 165,
              height: 165,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.09),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Миний захиалгууд',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.7,
                      ),
                    ),
                    const SizedBox(height: 9),
                    const Text(
                      'Үйлчилгээний захиалга болон '
                      'явцыг нэг дороос хянаарай.',
                      style: TextStyle(
                        color: Color(0xFFE6F6FF),
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: Colors.white,
                  size: 29,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summarySection({
    required int total,
    required int completed,
    required int cancelled,
  }) {
    return Row(
      children: [
        Expanded(
          child: _summaryCard(
            title: 'Нийт',
            count: total,
            icon: Icons.layers_rounded,
            color: AppColors.primary,
            background: AppColors.primaryLight,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: _summaryCard(
            title: 'Дууссан',
            count: completed,
            icon: Icons.check_circle_outline_rounded,
            color: AppColors.success,
            background: const Color(0xFFE7F8EF),
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: _summaryCard(
            title: 'Цуцалсан',
            count: cancelled,
            icon: Icons.cancel_outlined,
            color: AppColors.danger,
            background: const Color(0xFFFFECEC),
          ),
        ),
      ],
    );
  }

  Widget _summaryCard({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
    required Color background,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: color, size: 21),
          ),
          const SizedBox(height: 10),
          Text(
            '$count',
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeading() {
    return const Row(
      children: [
        Expanded(
          child: Text(
            'Захиалгын түүх',
            style: TextStyle(
              color: AppColors.navy,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Icon(Icons.tune_rounded, color: AppColors.primary, size: 23),
      ],
    );
  }

  Widget _filters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _filterChip(
            label: 'Бүгд',
            selected: filter == null,
            onTap: () => setState(() => filter = null),
          ),
          const SizedBox(width: 8),
          ...OrderStatus.values.map(
            (status) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _filterChip(
                label: status.label,
                selected: filter == status,
                onTap: () => setState(() => filter = status),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: selected ? AppColors.primary : Colors.white,
      borderRadius: BorderRadius.circular(25),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : AppColors.muted,
              fontSize: 12,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  String? _serviceImage(String service) {
    final name = service.toLowerCase();
    const rules = <(String, String)>[
      ('хүүхэд', 'babysitting.jpg'),
      ('цонх', 'window_cleaning.jpg'),
      ('хашаа', 'yard_cleaning.jpg'),
      ('цас', 'snow_removal.jpg'),
      ('өвс', 'grass.jpg'),
      ('тавилга', 'furniture.jpg'),
      ('сантехник', 'plumbing.jpg'),
      ('цахилгаан', 'electric.jpg'),
      ('савлах', 'packing.jpg'),
      ('шуудайлах', 'packing.jpg'),
      ('нүүлгэлт', 'moving.jpg'),
      ('ачаа', 'moving.jpg'),
      ('хог', 'waste.jpg'),
      ('цэвэрлэгээ', 'cleaning.jpg'),
      ('түлээ', 'fuel.jpg'),
      ('нүүрс', 'fuel.jpg'),
      ('ус', 'water.jpg'),
    ];
    for (final rule in rules) {
      if (name.contains(rule.$1)) {
        return 'assets/images/services/${rule.$2}';
      }
    }
    return null;
  }

  Widget _orderCard(MockOrder order) {
    final isCancelled = order.status == OrderStatus.cancelled;
    final image = _serviceImage(order.service);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isCancelled
              ? AppColors.danger.withValues(alpha: 0.22)
              : AppColors.border,
        ),
        boxShadow: AppColors.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => OrderDetailsScreen(order: order)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 152,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (image != null)
                      Image.asset(
                        image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _orderImageFallback(order),
                      )
                    else
                      _orderImageFallback(order),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0x000B2D50), Color(0xC70B2D50)],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 18,
                      right: 18,
                      bottom: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.service,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.w900,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Захиалга #${order.id}',
                            style: const TextStyle(
                              color: Color(0xFFE8F6FF),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(17, 17, 17, 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _statusBadge(order.status),
                        const Spacer(),
                        Icon(
                          Icons.receipt_long_outlined,
                          color: AppColors.muted.withValues(alpha: 0.75),
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _infoRow(
                            Icons.calendar_month_outlined,
                            _formatDate(order.date),
                          ),
                          const SizedBox(height: 10),
                          _infoRow(
                            Icons.schedule_outlined,
                            '${order.startTime} – ${order.endTime}',
                          ),
                          const SizedBox(height: 10),
                          _infoRow(Icons.location_on_outlined, order.address),
                        ],
                      ),
                    ),
                    if (isCancelled) ...[
                      const SizedBox(height: 13),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF1F1),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.info_outline_rounded,
                              color: AppColors.danger,
                              size: 19,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Цуцалсан шалтгаан: ${order.cancellationReason ?? "-"}',
                                style: const TextStyle(
                                  color: Color(0xFF9B2525),
                                  fontSize: 12,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 15),
                    const Divider(height: 1, color: AppColors.border),
                    const SizedBox(height: 13),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Дэлгэрэнгүй харах',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColors.primary,
                          size: 19,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _orderImageFallback(MockOrder order) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: Center(
        child: Icon(
          order.icon,
          size: 66,
          color: Colors.white.withValues(alpha: 0.7),
        ),
      ),
    );
  }

  Widget _statusBadge(OrderStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.11),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: status.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            status.label,
            style: TextStyle(
              color: status.color,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 18),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.navy,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _emptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 50),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              color: AppColors.primary,
              size: 38,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Захиалга олдсонгүй',
            style: TextStyle(
              color: AppColors.navy,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Энэ төлөвт тохирох захиалга одоогоор алга.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted, fontSize: 12, height: 1.5),
          ),
        ],
      ),
    );
  }
}
