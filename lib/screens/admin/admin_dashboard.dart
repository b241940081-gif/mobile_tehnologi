import 'package:flutter/material.dart';

import '../../data/mock_orders.dart';
import '../auth/login_screen.dart';
import 'admin_feedback_screen.dart';
import 'admin_orders_screen.dart';
import 'admin_services_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  static const _navy = Color(0xFF172B4D);
  static const _blue = Color(0xFF078ED4);
  static const _muted = Color(0xFF7894AD);
  static const _border = Color(0xFFDCEBF7);
  static const _background = Color(0xFFF2F9FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.home_work_rounded, color: _blue, size: 31),
            SizedBox(width: 9),
            Text(
              'TusGo',
              style: TextStyle(color: _navy, fontWeight: FontWeight.w900),
            ),
            SizedBox(width: 9),
            Text(
              'ADMIN',
              style: TextStyle(
                color: _blue,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.4,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Гарах',
            color: _navy,
            icon: const Icon(Icons.logout_rounded),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
          const SizedBox(width: 9),
        ],
      ),
      body: AnimatedBuilder(
        animation: MockOrders.instance,
        builder: (context, _) {
          final orders = MockOrders.instance.orders;
          final pending = orders
              .where((o) => o.status == OrderStatus.pending)
              .length;
          final active = orders
              .where(
                (o) =>
                    o.status == OrderStatus.accepted ||
                    o.status == OrderStatus.inProgress,
              )
              .length;
          final completed = orders
              .where((o) => o.status == OrderStatus.completed)
              .length;
          final cancelled = orders
              .where((o) => o.status == OrderStatus.cancelled)
              .length;
          final rated = orders.where((o) => o.isRated).toList();
          final averageRating = rated.isEmpty
              ? 0.0
              : rated.map((o) => o.rating!).reduce((a, b) => a + b) /
                    rated.length;
          final thanks = rated
              .where((o) => o.feedbackType == 'Талархал')
              .length;
          final suggestions = rated
              .where((o) => o.feedbackType == 'Санал')
              .length;
          final complaints = rated
              .where((o) => o.feedbackType == 'Гомдол')
              .length;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 22, 18, 36),
                children: [
                  _hero(orders.length),
                  const SizedBox(height: 27),
                  _sectionHeading(
                    'Системийн үзүүлэлт',
                    'Захиалгын төлөвийн ерөнхий мэдээлэл',
                    Icons.insights_rounded,
                  ),
                  const SizedBox(height: 15),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final columns = constraints.maxWidth >= 800
                          ? 5
                          : constraints.maxWidth >= 470
                          ? 3
                          : 2;
                      return GridView.count(
                        crossAxisCount: columns,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 11,
                        mainAxisSpacing: 11,
                        mainAxisExtent: 154,
                        children: [
                          _statCard(
                            'Нийт захиалга',
                            '${orders.length}',
                            Icons.receipt_long_rounded,
                            _blue,
                            const Color(0xFFDFF4FF),
                          ),
                          _statCard(
                            'Хүлээгдэж буй',
                            '$pending',
                            Icons.notifications_active_outlined,
                            const Color(0xFFF59E0B),
                            const Color(0xFFFFF4E2),
                          ),
                          _statCard(
                            'Идэвхтэй',
                            '$active',
                            Icons.handyman_rounded,
                            const Color(0xFF2563EB),
                            const Color(0xFFE8F0FF),
                          ),
                          _statCard(
                            'Дууссан',
                            '$completed',
                            Icons.check_circle_outline_rounded,
                            const Color(0xFF16A34A),
                            const Color(0xFFE6F8EE),
                          ),
                          _statCard(
                            'Цуцлагдсан',
                            '$cancelled',
                            Icons.cancel_outlined,
                            const Color(0xFFDC2626),
                            const Color(0xFFFFEBED),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 27),
                  _sectionHeading(
                    'Үнэлгээ ба санал хүсэлт',
                    'Хэрэглэгчдийн үйлчилгээний үнэлгээ',
                    Icons.star_rounded,
                  ),
                  const SizedBox(height: 14),
                  _ratingSummary(
                    averageRating: averageRating,
                    ratedCount: rated.length,
                    thanks: thanks,
                    suggestions: suggestions,
                    complaints: complaints,
                  ),
                  const SizedBox(height: 27),
                  _sectionHeading(
                    'Удирдлагын хэсэг',
                    'Системийн мэдээллийг хянах, удирдах',
                    Icons.dashboard_customize_rounded,
                  ),
                  const SizedBox(height: 14),
                  _actionCard(
                    context,
                    title: 'Бүх захиалгууд',
                    subtitle: 'Захиалгын дэлгэрэнгүй мэдээлэл',
                    icon: Icons.receipt_long_rounded,
                    color: _blue,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AdminOrdersScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 11),
                  _actionCard(
                    context,
                    title: 'Үнэлгээ, санал хүсэлт',
                    subtitle: 'Талархал, санал, гомдол харах',
                    icon: Icons.rate_review_rounded,
                    color: const Color(0xFFF59E0B),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AdminFeedbackScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 11),
                  _actionCard(
                    context,
                    title: 'Үйлчилгээ удирдах',
                    subtitle: 'Үйлчилгээ идэвхжүүлэх, идэвхгүй болгох',
                    icon: Icons.miscellaneous_services_rounded,
                    color: const Color(0xFF16A34A),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AdminServicesScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  _sectionHeading(
                    'Сүүлийн захиалгууд',
                    'Үйлчилгээний зураг, төлөв, үнэлгээний мэдээлэл',
                    Icons.history_rounded,
                  ),
                  const SizedBox(height: 14),
                  if (orders.isEmpty)
                    _surface(
                      child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(
                          child: Text(
                            'Захиалга байхгүй байна.',
                            style: TextStyle(color: _muted),
                          ),
                        ),
                      ),
                    )
                  else
                    ...orders.take(10).map(_orderCard),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'TusGo 2.0  •  Admin Dashboard',
                      style: TextStyle(color: _muted, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _hero(int total) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF10B6EE), Color(0xFF0871B5)],
        ),
        borderRadius: BorderRadius.circular(29),
        boxShadow: [
          BoxShadow(
            color: _blue.withValues(alpha: .15),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -45,
            top: -80,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: .10),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .19),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.verified_user_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(width: 7),
                    Text(
                      'TUSGO ADMIN',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                'Хяналтын самбар',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 29,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Захиалга, үйлчилгээ болон хэрэглэгчийн үнэлгээг нэг дороос удирдаарай.',
                style: TextStyle(
                  color: Colors.white,
                  height: 1.45,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 19),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .17),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Text(
                  'Нийт $total захиалга бүртгэгдсэн',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionHeading(String title, String subtitle, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFDDF4FF),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: _blue, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _navy,
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: _muted, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statCard(
    String label,
    String value,
    IconData icon,
    Color color,
    Color iconBackground,
  ) {
    return _surface(
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                color: _muted,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ratingSummary({
    required double averageRating,
    required int ratedCount,
    required int thanks,
    required int suggestions,
    required int complaints,
  }) {
    return _surface(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF4E2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.star_rounded,
                    color: Color(0xFFF59E0B),
                    size: 29,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${averageRating.toStringAsFixed(1)} / 10',
                        style: const TextStyle(
                          color: _navy,
                          fontSize: 27,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'Нийт $ratedCount үнэлгээ',
                        style: const TextStyle(color: _muted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Divider(color: _border),
            ),
            _summaryRow(
              'Талархал',
              thanks,
              Icons.favorite_rounded,
              const Color(0xFF16A34A),
            ),
            _summaryRow(
              'Санал',
              suggestions,
              Icons.lightbulb_outline_rounded,
              _blue,
            ),
            _summaryRow(
              'Гомдол',
              complaints,
              Icons.report_problem_outlined,
              const Color(0xFFDC2626),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, int count, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: _navy, fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            '$count',
            style: const TextStyle(color: _navy, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }

  Widget _actionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _border),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .10),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, color: color, size: 25),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: _navy,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(color: _muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: _blue,
                size: 17,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Үйлчилгээний нэрээр зураг сонгоно. Захиалгын өгөгдлийг өөрчлөхгүй.
  String? _serviceImage(String service) {
    final name = service.toLowerCase();
    const rules = <(String, String)>[
      ('хүүхэд', 'babysitting.jpg'),
      ('цонх', 'window_cleaning.jpg'),
      ('цас', 'snow_removal.jpg'),
      ('өвс', 'grass.jpg'),
      ('тавилга', 'furniture.jpg'),
      ('сантехник', 'plumbing.jpg'),
      ('цахилгаан', 'electric.jpg'),
      ('шуудай', 'packing.jpg'),
      ('савлах', 'packing.jpg'),
      ('нүүлгэлт', 'moving.jpg'),
      ('ачаа', 'moving.jpg'),
      ('хог', 'waste.jpg'),
      ('хашаа', 'yard_cleaning.jpg'),
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
    final image = _serviceImage(order.service);
    final isCancelled = order.status == OrderStatus.cancelled;
    final statusColor = order.status.color;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(23),
          border: Border.all(color: _border),
          boxShadow: [
            BoxShadow(
              color: _blue.withValues(alpha: .045),
              blurRadius: 19,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 160,
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
                        colors: [Color(0x080B2D50), Color(0xD90B2D50)],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 17,
                    right: 17,
                    bottom: 17,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.service,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Захиалга #${order.id}',
                          style: const TextStyle(
                            color: Color(0xFFE9F5FF),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(17),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: .11),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.circle, size: 8, color: statusColor),
                            const SizedBox(width: 7),
                            Text(
                              order.status.label,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (order.isRated)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF4E2),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            '${order.rating}/10 ★',
                            style: const TextStyle(
                              color: Color(0xFFD68A00),
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (isCancelled) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1F2),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Цуцалсан шалтгаан: ${order.cancellationReason ?? "-"}',
                            style: const TextStyle(
                              color: Color(0xFF991B1B),
                              fontSize: 12,
                            ),
                          ),
                          if (order.cancelledAt != null) ...[
                            const SizedBox(height: 5),
                            Text(
                              'Цуцалсан огноо: ${_formatDateTime(order.cancelledAt!)}',
                              style: const TextStyle(
                                color: Color(0xFF991B1B),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _orderImageFallback(MockOrder order) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF10B6EE), Color(0xFF0871B5)],
        ),
      ),
      child: Center(
        child: Icon(
          order.icon,
          size: 66,
          color: Colors.white.withValues(alpha: .7),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime date) {
    String two(int value) => value.toString().padLeft(2, '0');
    return '${date.year}.${two(date.month)}.${two(date.day)} ${two(date.hour)}:${two(date.minute)}';
  }

  Widget _surface({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2D83B5).withValues(alpha: .035),
            blurRadius: 17,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}
