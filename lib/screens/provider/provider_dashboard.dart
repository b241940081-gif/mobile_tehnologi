import 'package:flutter/material.dart';

import '../../core/widgets/provider_bottom_nav.dart';
import '../../data/mock_orders.dart';
import '../../data/mock_provider.dart';
import '../../data/mock_services.dart';
import '../../models/service_item.dart';

import '../auth/login_screen.dart';

import 'provider_profile_screen.dart';
import 'provider_services_screen.dart';
import 'provider_orders_screen.dart';
import '../../data/mock_notifications.dart';
import '../notifications/notifications_screen.dart';

class ProviderDashboard extends StatefulWidget {
  const ProviderDashboard({super.key});

  @override
  State<ProviderDashboard> createState() => _ProviderDashboardState();
}

class _ProviderDashboardState extends State<ProviderDashboard> {
  // 0 = Нүүр
  // 1 = Миний ажил
  // 2 = Захиалга
  // 3 = Профайл
  int selectedTab = 0;

  OrderStatus? selectedFilter;

  String formatDate(DateTime date) {
    return '${date.year}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.day.toString().padLeft(2, '0')}';
  }

  int minutesFromText(String value) {
    final parts = value.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  String timeFromMinutes(int minutes) {
    final hour = (minutes ~/ 60).toString().padLeft(2, '0');
    final minute = (minutes % 60).toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // Үйлчилгээ Admin-аас идэвхгүй болсон эсэх
  bool isOrderServiceActive(MockOrder order) {
    for (final service in services) {
      if (service.title == order.service) {
        return MockServices.instance.isActive(service.id);
      }
    }

    return false;
  }

  // Шинэ захиалга хүлээн авах
  Future<void> acceptOrder(MockOrder order) async {
    if (order.status != OrderStatus.pending || order.providerId != null) {
      return;
    }

    if (!isOrderServiceActive(order)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Энэ үйлчилгээ идэвхгүй тул шинэ захиалга хүлээн авах боломжгүй.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final start = minutesFromText(order.startTime);
    final end = minutesFromText(order.endTime);

    final selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: start ~/ 60, minute: start % 60),
      helpText: 'Ирэх цагаа сонгоно уу',
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (!mounted || selected == null) return;

    // Цаг сонгох үед үйлчилгээ идэвхгүй болсон байж болно.
    if (!isOrderServiceActive(order)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Үйлчилгээ идэвхгүй болсон тул захиалгыг хүлээн авах боломжгүй.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final selectedMinutes = selected.hour * 60 + selected.minute;

    if (selectedMinutes < start || selectedMinutes > end) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Ирэх цаг ${order.startTime}–${order.endTime} '
            'хооронд байх ёстой.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (order.status != OrderStatus.pending || order.providerId != null) {
      return;
    }

    MockOrders.instance.acceptOrder(order, timeFromMinutes(selectedMinutes));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Захиалгыг амжилттай хүлээн авлаа.'),
        backgroundColor: Color(0xFF16A34A),
      ),
    );
  }

  // Хүлээн авсан ажлыг эхлүүлэх, дуусгах
  void updateOrder(MockOrder order) {
    if (order.providerId != 'demo_provider') return;

    if (order.status != OrderStatus.accepted &&
        order.status != OrderStatus.inProgress) {
      return;
    }

    MockOrders.instance.advanceOrder(order);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Захиалгын төлөв: ${order.status.label}')),
    );
  }

  // Түр туршилтын мэдэгдэл: Алхам 17.4-д энэ товчийг авна.
  void addTestNotification() {
    MockNotifications.instance.add(
      role: NotificationRole.provider,
      title: 'Шинэ захиалга ирлээ',
      message: 'Ус хүргэлтийн шинэ захиалга бүртгэгдлээ.',
      orderId: 'TG-1001',
    );
  }

  void logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Row(
          children: [
            Icon(Icons.home_work_rounded, color: Color(0xFF2563EB), size: 28),
            SizedBox(width: 8),
            Text(
              'TusGo',
              style: TextStyle(
                color: Color(0xFF0F172A),
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        actions: [
          AnimatedBuilder(
            animation: MockNotifications.instance,
            builder: (context, _) {
              final unread = MockNotifications.instance.unreadCount(
                NotificationRole.provider,
              );
              return IconButton(
                tooltip: 'Мэдэгдэл',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationsScreen(
                        role: NotificationRole.provider,
                      ),
                    ),
                  );
                },
                icon: Badge(
                  isLabelVisible: unread > 0,
                  label: Text(unread > 99 ? '99+' : '$unread'),
                  child: const Icon(Icons.notifications_none_rounded),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Гарах',
            onPressed: logout,
            icon: const Icon(Icons.logout_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      bottomNavigationBar: ProviderBottomNav(
        currentIndex: selectedTab,
        onTap: (index) {
          setState(() {
            selectedTab = index;
          });
        },
      ),
      body: IndexedStack(
        index: selectedTab,
        children: [
          ProviderServicesScreen(
            onOpenWork: () {
              setState(() {
                selectedTab = 1;
              });
            },
          ),
          _dashboardBody(),
          const ProviderOrdersScreen(),
          const ProviderProfileScreen(),
        ],
      ),
    );
  }

  Widget _dashboardBody() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        MockOrders.instance,
        MockProvider.instance,
        MockServices.instance,
      ]),
      builder: (context, _) {
        final allOrders = MockOrders.instance.orders.where((order) {
          final matchesService = services.any(
            (service) =>
                service.title == order.service &&
                MockProvider.instance.provides(service.id),
          );
          // Шинэ захиалга зөвхөн сонгосон үйлчилгээнд хамаарна.
          if (order.status == OrderStatus.pending) {
            return matchesService && order.providerId == null;
          }

          // Хүлээн авсан болон түүхэн захиалга зөвхөн энэ Provider-ийнх.
          // Үйлчилгээний сонголт өөрчлөгдсөн ч өмнөх ажлууд харагдана.
          return order.providerId == 'demo_provider';
        }).toList();

        final pending = allOrders
            .where((order) => order.status == OrderStatus.pending)
            .length;

        final active = allOrders
            .where(
              (order) =>
                  order.status == OrderStatus.accepted ||
                  order.status == OrderStatus.inProgress,
            )
            .length;

        final completed = allOrders
            .where((order) => order.status == OrderStatus.completed)
            .length;

        final cancelled = allOrders
            .where((order) => order.status == OrderStatus.cancelled)
            .length;

        final visibleOrders = allOrders
            .where(
              (order) =>
                  selectedFilter == null || order.status == selectedFilter,
            )
            .toList();

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _heroBanner(),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        'Шинэ',
                        pending,
                        Icons.pending_actions_rounded,
                        const Color(0xFFF59E0B),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _statCard(
                        'Идэвхтэй',
                        active,
                        Icons.handyman_rounded,
                        const Color(0xFF2563EB),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _statCard(
                        'Дууссан',
                        completed,
                        Icons.check_circle_rounded,
                        const Color(0xFF16A34A),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _statCard(
                        'Цуцлагдсан',
                        cancelled,
                        Icons.cancel_outlined,
                        const Color(0xFFDC2626),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Миний ажил',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 14),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _filterChip('Бүгд', null),
                      ...OrderStatus.values.map(
                        (status) => _filterChip(status.label, status),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                if (visibleOrders.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: Text(
                        'Таны сонгосон үйлчилгээний '
                        'захиалга одоогоор байхгүй.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ...visibleOrders.map(_orderCard),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _heroBanner() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1D4ED8), Color(0xFF60A5FA)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PROVIDER DASHBOARD',
            style: TextStyle(
              color: Color(0xFFDBEAFE),
              fontSize: 12,
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Миний ажлууд',
            style: TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Өөрийн үйлчилгээний захиалгуудыг '
            'эндээс удирдаарай.',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String label, int count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 23),
          const SizedBox(height: 10),
          Text(
            '$count',
            style: TextStyle(
              color: color,
              fontSize: 27,
              fontWeight: FontWeight.w900,
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

  Widget _filterChip(String label, OrderStatus? status) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selectedFilter == status,
        onSelected: (_) {
          setState(() {
            selectedFilter = status;
          });
        },
      ),
    );
  }

  Widget _orderCard(MockOrder order) {
    final isServiceActive = isOrderServiceActive(order);
    final isCancelled = order.status == OrderStatus.cancelled;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF2FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(order.icon, color: const Color(0xFF2563EB)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  order.service,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              Chip(
                label: Text(order.status.label),
                backgroundColor: order.status.color.withValues(alpha: 0.12),
                labelStyle: TextStyle(color: order.status.color),
              ),
              Chip(label: Text('#${order.id}')),
              if (!isServiceActive && !isCancelled)
                const Chip(
                  label: Text('Үйлчилгээ идэвхгүй'),
                  backgroundColor: Color(0xFFFEE2E2),
                  labelStyle: TextStyle(color: Color(0xFFB91C1C)),
                ),
            ],
          ),
          const SizedBox(height: 8),
          _detailRow(Icons.calendar_month_outlined, formatDate(order.date)),
          _detailRow(
            Icons.access_time_rounded,
            '${order.startTime}–${order.endTime}',
          ),
          _detailRow(Icons.location_on_outlined, order.address),
          _detailRow(Icons.phone_outlined, order.phone),
          if (order.arrivalTime != null)
            _detailRow(
              Icons.check_circle_outline,
              'Баталгаажсан ирэх цаг: ${order.arrivalTime}',
              color: const Color(0xFF16A34A),
            ),
          if (isCancelled) ...[
            const SizedBox(height: 8),
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
                  const Text(
                    'Захиалга цуцлагдсан',
                    style: TextStyle(
                      color: Color(0xFFB91C1C),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Шалтгаан: ${order.cancellationReason ?? "Тодорхойгүй"}',
                    style: const TextStyle(color: Color(0xFF991B1B)),
                  ),
                  if (order.cancelledAt != null) ...[
                    const SizedBox(height: 5),
                    Text(
                      'Цуцалсан: ${formatDate(order.cancelledAt!)} '
                      '${order.cancelledAt!.hour.toString().padLeft(2, '0')}:'
                      '${order.cancelledAt!.minute.toString().padLeft(2, '0')}',
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
          if (order.note.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                'Тайлбар: ${order.note}',
                style: const TextStyle(color: Color(0xFF64748B)),
              ),
            ),
          const SizedBox(height: 16),

          // Идэвхтэй үйлчилгээний шинэ захиалга
          if (order.status == OrderStatus.pending && isServiceActive)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => acceptOrder(order),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Захиалга хүлээн авах'),
              ),
            ),

          // Идэвхгүй үйлчилгээний шинэ захиалга
          if (order.status == OrderStatus.pending && !isServiceActive)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Энэ үйлчилгээ идэвхгүй болсон тул '
                'шинэ захиалга хүлээн авах боломжгүй.',
                style: TextStyle(color: Color(0xFFB91C1C)),
              ),
            ),

          // Өмнө нь хүлээн авсан ажлыг үргэлжлүүлнэ
          if (order.status == OrderStatus.accepted)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => updateOrder(order),
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Ажил эхлүүлэх'),
              ),
            ),

          if (order.status == OrderStatus.inProgress)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => updateOrder(order),
                icon: const Icon(Icons.task_alt_rounded),
                label: const Text('Ажил дуусгах'),
              ),
            ),

          if (isCancelled)
            const Row(
              children: [
                Icon(Icons.block_rounded, color: Color(0xFFDC2626)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Энэ захиалгыг үргэлжлүүлэх боломжгүй.',
                    style: TextStyle(
                      color: Color(0xFFDC2626),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

          if (order.status == OrderStatus.completed)
            const Row(
              children: [
                Icon(Icons.verified_rounded, color: Color(0xFF16A34A)),
                SizedBox(width: 8),
                Text(
                  'Үйлчилгээ дууссан',
                  style: TextStyle(
                    color: Color(0xFF16A34A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _detailRow(
    IconData icon,
    String value, {
    Color color = const Color(0xFF64748B),
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(value, style: TextStyle(color: color, height: 1.4)),
          ),
        ],
      ),
    );
  }
}
