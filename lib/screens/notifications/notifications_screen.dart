import 'package:flutter/material.dart';

import '../../data/mock_notifications.dart';
import '../../data/mock_orders.dart';

class NotificationsScreen extends StatelessWidget {
  final NotificationRole role;

  const NotificationsScreen({super.key, required this.role});

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

  // Мэдэгдэлтэй холбоотой захиалгыг олох
  MockOrder? findOrder(String orderId) {
    for (final order in MockOrders.instance.orders) {
      if (order.id == orderId) {
        return order;
      }
    }

    return null;
  }

  // Мэдэгдэл дээр дарахад ажиллах
  void openNotification(BuildContext context, AppNotification notification) {
    // Эхлээд уншсан төлөвт шилжүүлнэ
    MockNotifications.instance.markAsRead(notification.id);

    final orderId = notification.orderId;

    // Захиалгатай холбоогүй мэдэгдэл бол зөвхөн уншина
    if (orderId == null) {
      return;
    }

    final order = findOrder(orderId);

    // Захиалга олдохгүй бол мэдээлэл харуулна
    if (order == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$orderId дугаартай захиалга олдсонгүй.')),
      );
      return;
    }

    // Customer болон Provider-ийн захиалгын
    // мэдээллийг дэлгэрэнгүй харуулах
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.receipt_long_rounded, color: Color(0xFF2563EB)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Захиалга ${order.id}',
                  style: const TextStyle(
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
                  // Захиалгын төлөв
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
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

                  const SizedBox(height: 18),

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
                      Icons.access_time_filled_rounded,
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
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Хаах'),
            ),
          ],
        );
      },
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF64748B)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      appBar: AppBar(
        title: const Text('Мэдэгдэл'),
        backgroundColor: Colors.white,
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
                icon: const Icon(Icons.done_all_rounded, size: 19),
                label: const Text('Бүгдийг унших'),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: AnimatedBuilder(
        animation: MockNotifications.instance,
        builder: (context, _) {
          final notifications = MockNotifications.instance.forRole(role);

          if (notifications.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none_rounded,
                    size: 72,
                    color: Color(0xFF94A3B8),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Одоогоор мэдэгдэл алга',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Шинэ мэдээлэл энд харагдана.',
                    style: TextStyle(color: Color(0xFF64748B)),
                  ),
                ],
              ),
            );
          }

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 850),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    color: notification.isRead
                        ? Colors.white
                        : const Color(0xFFEFF6FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: notification.isRead
                            ? const Color(0xFFE2E8F0)
                            : const Color(0xFF93C5FD),
                      ),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),

                      // Мэдэгдэл дээр дарахад
                      // захиалгын дэлгэрэнгүй мэдээлэл нээнэ
                      onTap: () {
                        openNotification(context, notification);
                      },

                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: notification.isRead
                                  ? const Color(0xFFF1F5F9)
                                  : const Color(0xFFDBEAFE),
                              child: Icon(
                                notification.isRead
                                    ? Icons.notifications_none_rounded
                                    : Icons.notifications_active_rounded,
                                color: const Color(0xFF2563EB),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          notification.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      if (!notification.isRead)
                                        Container(
                                          width: 9,
                                          height: 9,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF2563EB),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    notification.message,
                                    style: const TextStyle(
                                      color: Color(0xFF475569),
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time_rounded,
                                        size: 15,
                                        color: Color(0xFF94A3B8),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        formatDateTime(notification.createdAt),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF64748B),
                                        ),
                                      ),
                                      if (notification.orderId != null) ...[
                                        const SizedBox(width: 12),
                                        Flexible(
                                          child: Text(
                                            '#${notification.orderId}',
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF2563EB),
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
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
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
