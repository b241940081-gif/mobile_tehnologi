import 'package:flutter/material.dart';

import '../../data/mock_notifications.dart';
import '../../data/mock_orders.dart';

class NotificationsScreen extends StatelessWidget {
  final NotificationRole role;

  const NotificationsScreen({super.key, required this.role});

  static const _blue = Color(0xFF008FD3);
  static const _navy = Color(0xFF172F55);
  static const _muted = Color(0xFF7895B4);
  static const _background = Color(0xFFF1F9FF);
  static const _border = Color(0xFFD7E9F8);

  String formatDateTime(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$day.$month.${date.year} $hour:$minute';
  }

  String formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day.$month.${date.year}';
  }

  MockOrder? findOrder(String orderId) {
    for (final order in MockOrders.instance.orders) {
      if (order.id == orderId) {
        return order;
      }
    }
    return null;
  }

  void openNotification(BuildContext context, AppNotification notification) {
    MockNotifications.instance.markAsRead(notification.id);

    final orderId = notification.orderId;
    if (orderId == null) return;

    final order = findOrder(orderId);

    if (order == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$orderId дугаартай захиалга олдсонгүй.')),
      );
      return;
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Row(
            children: [
              const Icon(Icons.receipt_long_rounded, color: _blue),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Захиалга ${order.id}',
                  style: const TextStyle(
                    color: _navy,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 440,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: order.status.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      order.status.label,
                      style: TextStyle(
                        color: order.status.color,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _detailRow(
                    Icons.home_repair_service_outlined,
                    'Үйлчилгээ',
                    order.service,
                  ),
                  _detailRow(Icons.location_on_outlined, 'Хаяг', order.address),
                  _detailRow(Icons.phone_outlined, 'Утас', order.phone),
                  _detailRow(
                    Icons.calendar_today_outlined,
                    'Огноо',
                    formatDate(order.date),
                  ),
                  _detailRow(
                    Icons.schedule_outlined,
                    'Захиалсан цаг',
                    '${order.startTime} - ${order.endTime}',
                  ),
                  if (order.arrivalTime != null)
                    _detailRow(
                      Icons.access_time_rounded,
                      'Ирэх цаг',
                      order.arrivalTime!,
                    ),
                  if (order.note.trim().isNotEmpty)
                    _detailRow(
                      Icons.notes_rounded,
                      'Нэмэлт тайлбар',
                      order.note,
                    ),
                  if (order.status == OrderStatus.cancelled &&
                      order.cancellationReason != null)
                    _detailRow(
                      Icons.cancel_outlined,
                      'Цуцалсан шалтгаан',
                      order.cancellationReason!,
                    ),
                  if (order.rating != null) ...[
                    _detailRow(
                      Icons.star_rounded,
                      'Үнэлгээ',
                      '${order.rating}/10',
                    ),
                    if (order.feedbackType != null)
                      _detailRow(
                        Icons.feedback_outlined,
                        'Саналын төрөл',
                        order.feedbackType!,
                      ),
                    if (order.feedbackComment != null &&
                        order.feedbackComment!.isNotEmpty)
                      _detailRow(
                        Icons.comment_outlined,
                        'Сэтгэгдэл',
                        order.feedbackComment!,
                      ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Хаах'),
            ),
          ],
        );
      },
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _blue, size: 21),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: _muted),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: _navy,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _hero(int total, int unread) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF12B6EC), Color(0xFF0574B8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: _blue.withValues(alpha: 0.13),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.20),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.notifications_active_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                SizedBox(width: 8),
                Text(
                  'TUSGO UPDATES',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          const Text(
            'Таны мэдэгдлүүд',
            style: TextStyle(
              fontSize: 29,
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Захиалга болон үйлчилгээний шинэ мэдээллийг нэг дороос хараарай.',
            style: TextStyle(color: Colors.white, height: 1.5, fontSize: 14),
          ),
          const SizedBox(height: 23),
          Row(
            children: [
              Expanded(
                child: _heroStat(
                  Icons.notifications_outlined,
                  '$total',
                  'Нийт',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _heroStat(
                  Icons.mark_email_unread_outlined,
                  '$unread',
                  'Уншаагүй',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _heroStat(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.17),
        border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 25),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _notificationCard(BuildContext context, AppNotification notification) {
    final unread = !notification.isRead;

    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(
          color: unread ? const Color(0xFF9ADDF8) : _border,
          width: unread ? 1.4 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _navy.withValues(alpha: 0.035),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(23),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => openNotification(context, notification),
          child: Padding(
            padding: const EdgeInsets.all(17),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: unread
                        ? const Color(0xFFDDF5FF)
                        : const Color(0xFFF0F5FA),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    unread
                        ? Icons.notifications_active_rounded
                        : Icons.notifications_none_rounded,
                    color: unread ? _blue : _muted,
                    size: 25,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                color: _navy,
                                fontSize: 16,
                                fontWeight: unread
                                    ? FontWeight.w900
                                    : FontWeight.w700,
                              ),
                            ),
                          ),
                          if (unread)
                            Container(
                              width: 9,
                              height: 9,
                              decoration: const BoxDecoration(
                                color: _blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        notification.message,
                        style: const TextStyle(
                          color: Color(0xFF536E8D),
                          fontSize: 13,
                          height: 1.55,
                        ),
                      ),
                      const SizedBox(height: 13),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Icon(
                            Icons.schedule_rounded,
                            color: _muted,
                            size: 15,
                          ),
                          Text(
                            formatDateTime(notification.createdAt),
                            style: const TextStyle(color: _muted, fontSize: 12),
                          ),
                          if (notification.orderId != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: _background,
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: Text(
                                '#${notification.orderId}',
                                style: const TextStyle(
                                  color: _blue,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                const Icon(Icons.chevron_right_rounded, color: _muted),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 55),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _border),
        borderRadius: BorderRadius.circular(25),
      ),
      child: const Column(
        children: [
          Icon(Icons.notifications_off_outlined, size: 65, color: _blue),
          SizedBox(height: 17),
          Text(
            'Одоогоор мэдэгдэл алга',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 9),
          Text(
            'Шинэ захиалга болон үйлчилгээний мэдээлэл энд харагдана.',
            textAlign: TextAlign.center,
            style: TextStyle(color: _muted, height: 1.5),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        title: const Text(
          'Мэдэгдэл',
          style: TextStyle(color: _navy, fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        actions: [
          AnimatedBuilder(
            animation: MockNotifications.instance,
            builder: (context, _) {
              final unread = MockNotifications.instance.unreadCount(role);

              return TextButton.icon(
                onPressed: unread == 0
                    ? null
                    : () {
                        MockNotifications.instance.markAllAsRead(role);
                      },
                icon: const Icon(Icons.done_all_rounded, size: 18),
                label: const Text('Бүгдийг унших'),
                style: TextButton.styleFrom(
                  foregroundColor: _blue,
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 5),
        ],
      ),
      body: AnimatedBuilder(
        animation: MockNotifications.instance,
        builder: (context, _) {
          final notifications = MockNotifications.instance.forRole(role);

          final unread = MockNotifications.instance.unreadCount(role);

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 850),
              child: ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  _hero(notifications.length, unread),
                  const SizedBox(height: 29),
                  Row(
                    children: [
                      Container(
                        width: 49,
                        height: 49,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDDF5FF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.markunread_mailbox_outlined,
                          color: _blue,
                        ),
                      ),
                      const SizedBox(width: 13),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Мэдэгдлийн жагсаалт',
                              style: TextStyle(
                                color: _navy,
                                fontSize: 21,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Сүүлийн шинэчлэлтүүд',
                              style: TextStyle(color: _muted, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 19),
                  if (notifications.isEmpty)
                    _emptyState()
                  else
                    ...notifications.map(
                      (notification) =>
                          _notificationCard(context, notification),
                    ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
