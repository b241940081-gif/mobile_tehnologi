import 'package:flutter/material.dart';

import '../../data/mock_orders.dart';
import 'rating_screen.dart';

class OrderDetailsScreen extends StatelessWidget {
  final MockOrder order;

  const OrderDetailsScreen({super.key, required this.order});

  Future<void> _openRating(BuildContext context) async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => RatingScreen(order: order)),
    );
  }

  Future<void> _cancelOrder(BuildContext context) async {
    if (!order.canCancel) return;

    final reasonController = TextEditingController();

    final reason = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Захиалга цуцлах'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${order.id} дугаартай захиалгыг '
                'цуцлах гэж байна.',
              ),
              const SizedBox(height: 12),
              const Text(
                'Цуцлах шалтгаанаа бичнэ үү.',
                style: TextStyle(color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: reasonController,
                maxLines: 3,
                maxLength: 200,
                decoration: const InputDecoration(
                  hintText: 'Жишээ: Захиалга шаардлагагүй болсон...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Буцах'),
            ),
            TextButton(
              onPressed: () {
                final value = reasonController.text.trim();

                if (value.isEmpty) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(
                      content: Text('Цуцлах шалтгаанаа оруулна уу.'),
                    ),
                  );
                  return;
                }

                Navigator.pop(dialogContext, value);
              },
              child: const Text(
                'Цуцлах',
                style: TextStyle(
                  color: Color(0xFFDC2626),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    // Dialog бүрэн хаагдсаны дараа controller-ийг цэвэрлэнэ.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      reasonController.dispose();
    });

    if (!context.mounted || reason == null) return;

    final success = MockOrders.instance.cancelOrder(
      order: order,
      reason: reason,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Захиалга амжилттай цуцлагдлаа.'
              : 'Энэ захиалгыг цуцлах боломжгүй байна.',
        ),
        backgroundColor: success
            ? const Color(0xFF16A34A)
            : const Color(0xFFDC2626),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      appBar: AppBar(
        title: const Text('Захиалгын дэлгэрэнгүй'),
        backgroundColor: Colors.white,
      ),
      body: AnimatedBuilder(
        animation: MockOrders.instance,
        builder: (context, _) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  _header(),
                  const SizedBox(height: 18),
                  _statusCard(),
                  const SizedBox(height: 18),
                  _informationCard(),
                  if (order.status == OrderStatus.cancelled) ...[
                    const SizedBox(height: 18),
                    _cancellationInfo(),
                  ],
                  if (order.canCancel) ...[
                    const SizedBox(height: 18),
                    _cancelSection(context),
                  ],
                  const SizedBox(height: 18),
                  _ratingSection(context),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1D4ED8), Color(0xFF60A5FA)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(order.icon, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.service,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  'Захиалга: ${order.id}',
                  style: const TextStyle(color: Color(0xFFDBEAFE)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusCard() {
    return _card(
      children: [
        const Text(
          'Захиалгын төлөв',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: order.status.color.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.circle, size: 10, color: order.status.color),
              const SizedBox(width: 9),
              Text(
                order.status.label,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: order.status.color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _informationCard() {
    return _card(
      children: [
        const Text(
          'Захиалгын мэдээлэл',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 18),
        _infoRow(Icons.location_on_outlined, 'Хаяг', order.address),
        _infoRow(Icons.phone_outlined, 'Утас', order.phone),
        _infoRow(
          Icons.calendar_month_outlined,
          'Өдөр',
          _formatDate(order.date),
        ),
        _infoRow(
          Icons.access_time_rounded,
          'Захиалсан цаг',
          '${order.startTime} – ${order.endTime}',
        ),
        if (order.arrivalTime != null)
          _infoRow(
            Icons.schedule_rounded,
            'Үйлчилгээ үзүүлэгчийн ирэх цаг',
            order.arrivalTime!,
          ),
        if (order.note.trim().isNotEmpty)
          _infoRow(Icons.notes_rounded, 'Нэмэлт тайлбар', order.note),
      ],
    );
  }

  Widget _cancelSection(BuildContext context) {
    return _card(
      children: [
        const Text(
          'Захиалга цуцлах',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        const Text(
          'Үйлчилгээ эхлээгүй байгаа үед '
          'захиалгаа цуцлах боломжтой.',
          style: TextStyle(color: Color(0xFF64748B), height: 1.5),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            onPressed: () => _cancelOrder(context),
            icon: const Icon(Icons.cancel_outlined),
            label: const Text('Захиалга цуцлах'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFDC2626),
              side: const BorderSide(color: Color(0xFFDC2626)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _cancellationInfo() {
    return _card(
      children: [
        const Row(
          children: [
            Icon(Icons.cancel_rounded, color: Color(0xFFDC2626)),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Цуцлалтын мэдээлэл',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _infoRow(
          Icons.notes_rounded,
          'Цуцалсан шалтгаан',
          order.cancellationReason ?? '-',
        ),
        if (order.cancelledAt != null)
          _infoRow(
            Icons.calendar_month_outlined,
            'Цуцалсан огноо',
            _formatDateTime(order.cancelledAt!),
          ),
      ],
    );
  }

  Widget _ratingSection(BuildContext context) {
    if (order.status != OrderStatus.completed) {
      return const SizedBox.shrink();
    }

    if (order.isRated) {
      return _card(
        children: [
          const Row(
            children: [
              Icon(Icons.verified_rounded, color: Color(0xFF16A34A)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Үнэлгээ өгсөн',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.star_rounded,
                color: Color(0xFFF59E0B),
                size: 30,
              ),
              const SizedBox(width: 8),
              Text(
                '${order.rating}/10',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2563EB),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('Төрөл: ${order.feedbackType ?? '-'}'),
          if (order.feedbackComment != null &&
              order.feedbackComment!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              order.feedbackComment!,
              style: const TextStyle(color: Color(0xFF475569), height: 1.5),
            ),
          ],
          const SizedBox(height: 12),
          const Text(
            'Энэ захиалгад үнэлгээ өгсөн тул '
            'дахин үнэлэх боломжгүй.',
            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
        ],
      );
    }

    return _card(
      children: [
        const Text(
          'Үйлчилгээг үнэлэх',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 9),
        const Text(
          'Үйлчилгээ дууссан байна. '
          'Үйлчилгээний чанарыг үнэлж, '
          'санал хүсэлтээ үлдээнэ үү.',
          style: TextStyle(color: Color(0xFF64748B), height: 1.5),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () => _openRating(context),
            icon: const Icon(Icons.star_rounded),
            label: const Text('Үнэлгээ өгөх'),
          ),
        ),
      ],
    );
  }

  Widget _card({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 17),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: const Color(0xFF2563EB)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
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

  String _formatDate(DateTime date) {
    return '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  String _formatDateTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '${_formatDate(date)} $hour:$minute';
  }
}
