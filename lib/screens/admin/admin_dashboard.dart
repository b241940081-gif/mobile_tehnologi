import 'package:flutter/material.dart';

import '../../data/mock_orders.dart';
import '../auth/login_screen.dart';
import 'admin_feedback_screen.dart';
import 'admin_orders_screen.dart';
import 'admin_services_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(Icons.admin_panel_settings_rounded, color: Color(0xFF2563EB)),
            SizedBox(width: 10),
            Text('TusGo Admin'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Гарах',
            icon: const Icon(Icons.logout_rounded),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
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
                padding: const EdgeInsets.all(18),
                children: [
                  const Text(
                    'Хяналтын самбар',
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Системийн захиалга болон үнэлгээний тойм',
                    style: TextStyle(color: Color(0xFF64748B)),
                  ),

                  const SizedBox(height: 24),

                  // Захиалгын статистик
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final columns = constraints.maxWidth >= 700 ? 5 : 2;

                      return GridView.count(
                        crossAxisCount: columns,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: constraints.maxWidth >= 700
                            ? 1.15
                            : 1.35,
                        children: [
                          _statCard(
                            'Нийт захиалга',
                            '${orders.length}',
                            Icons.receipt_long_rounded,
                          ),
                          _statCard(
                            'Хүлээгдэж буй',
                            '$pending',
                            Icons.schedule_rounded,
                          ),
                          _statCard(
                            'Идэвхтэй',
                            '$active',
                            Icons.work_history_rounded,
                          ),
                          _statCard(
                            'Дууссан',
                            '$completed',
                            Icons.check_circle_rounded,
                          ),
                          _statCard(
                            'Цуцлагдсан',
                            '$cancelled',
                            Icons.cancel_rounded,
                            color: const Color(0xFFDC2626),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Үнэлгээний статистик
                  _ratingSummary(
                    averageRating: averageRating,
                    ratedCount: rated.length,
                    thanks: thanks,
                    suggestions: suggestions,
                    complaints: complaints,
                  ),

                  const SizedBox(height: 12),

                  // Бүх үнэлгээ, санал хүсэлт харах
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AdminFeedbackScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.rate_review_rounded),
                      label: const Text('Бүх үнэлгээ, санал хүсэлт харах'),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ШИНЭ: Бүх захиалгыг харах
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AdminOrdersScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.receipt_long_rounded),
                      label: const Text('Бүх захиалгыг харах'),
                    ),
                  ),

                  const SizedBox(height: 12),

                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminServicesScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.miscellaneous_services_rounded),
                    label: const Text('Үйлчилгээ удирдах'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2563EB),
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const SizedBox(height: 24),

                  // Сүүлийн захиалгууд
                  const Text(
                    'Сүүлийн захиалгууд',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
                  ),

                  const SizedBox(height: 14),

                  if (orders.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Text('Захиалга байхгүй байна.'),
                      ),
                    ),

                  ...orders.take(10).map(_orderCard),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Статистикийн карт
  Widget _statCard(
    String label,
    String value,
    IconData icon, {
    Color color = const Color(0xFF2563EB),
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _decoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 28),
          Text(
            value,
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  // Үнэлгээний статистик
  Widget _ratingSummary({
    required double averageRating,
    required int ratedCount,
    required int thanks,
    required int suggestions,
    required int complaints,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _decoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Үнэлгээ, санал хүсэлт',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              const Icon(
                Icons.star_rounded,
                color: Color(0xFFF59E0B),
                size: 35,
              ),
              const SizedBox(width: 10),
              Text(
                '${averageRating.toStringAsFixed(1)} / 10',
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2563EB),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            'Нийт $ratedCount үнэлгээ',
            style: const TextStyle(color: Color(0xFF64748B)),
          ),

          const Divider(height: 30),

          _summaryRow('Талархал', thanks, Icons.favorite_rounded),

          _summaryRow('Санал', suggestions, Icons.lightbulb_outline_rounded),

          _summaryRow('Гомдол', complaints, Icons.report_problem_outlined),
        ],
      ),
    );
  }

  // Санал хүсэлтийн тоо
  Widget _summaryRow(String label, int count, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2563EB)),
          const SizedBox(width: 12),
          Expanded(child: Text(label)),
          Text('$count', style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  // Захиалгын карт
  Widget _orderCard(MockOrder order) {
    final isCancelled = order.status == OrderStatus.cancelled;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isCancelled
              ? const Color(0xFFFCA5A5)
              : const Color(0xFFE2E8F0),
        ),
      ),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.service,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      order.id,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    order.status.label,
                    style: TextStyle(
                      color: order.status.color,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  if (order.isRated) ...[
                    const SizedBox(height: 6),
                    Text(
                      '${order.rating}/10 ★',
                      style: const TextStyle(
                        color: Color(0xFFF59E0B),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          if (isCancelled) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Цуцалсан шалтгаан: ${order.cancellationReason ?? "-"}',
                    style: const TextStyle(color: Color(0xFF991B1B)),
                  ),
                  if (order.cancelledAt != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Цуцалсан огноо: ${_formatDateTime(order.cancelledAt!)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF991B1B),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDateTime(DateTime date) {
    String two(int value) => value.toString().padLeft(2, '0');
    return '${date.year}.${two(date.month)}.${two(date.day)} '
        '${two(date.hour)}:${two(date.minute)}';
  }

  // Картын загвар
  BoxDecoration _decoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFFE2E8F0)),
    );
  }
}
