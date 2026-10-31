import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: AppColors.danger),
              SizedBox(width: 10),
              Expanded(child: Text('Захиалга цуцлах')),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
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
                  style: TextStyle(color: AppColors.muted),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: reasonController,
                  maxLines: 3,
                  maxLength: 200,
                  decoration: InputDecoration(
                    hintText: 'Жишээ: Захиалга шаардлагагүй болсон...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
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
                  color: AppColors.danger,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );
      },
    );

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
        backgroundColor: success ? AppColors.success : AppColors.danger,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        centerTitle: true,
        title: const Text('Захиалгын дэлгэрэнгүй'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: AnimatedBuilder(
        animation: MockOrders.instance,
        builder: (context, _) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(17, 24, 17, 35),
                children: [
                  _heroHeader(),
                  const SizedBox(height: 22),
                  _statusCard(),
                  const SizedBox(height: 20),
                  _informationCard(),
                  if (order.status == OrderStatus.cancelled) ...[
                    const SizedBox(height: 20),
                    _cancellationInfo(),
                  ],
                  if (order.canCancel) ...[
                    const SizedBox(height: 20),
                    _cancelSection(context),
                  ],
                  if (order.status == OrderStatus.completed) ...[
                    const SizedBox(height: 20),
                    _ratingSection(context),
                  ],
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String? _serviceImage() {
    final name = order.service.toLowerCase();

    const imageRules = <(String, String)>[
      ('хүүхэд', 'babysitting.jpg'),
      ('цонх', 'window_cleaning.jpg'),
      ('хашаа', 'yard_cleaning.jpg'),
      ('хашааны', 'yard_cleaning.jpg'),
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

    for (final rule in imageRules) {
      if (name.contains(rule.$1)) {
        return 'assets/images/services/${rule.$2}';
      }
    }

    return null;
  }

  Widget _heroHeader() {
    final image = _serviceImage();

    return Container(
      height: 245,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: AppColors.primaryGradient,
        boxShadow: const [
          BoxShadow(
            color: Color(0x23078BD3),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (image != null)
            Image.asset(
              image,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _heroImageFallback(),
            )
          else
            _heroImageFallback(),

          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x080B2D50),
                  Color(0x660B2D50),
                  Color(0xEE0B2D50),
                ],
                stops: [0.0, 0.46, 1.0],
              ),
            ),
          ),

          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified_rounded,
                    color: AppColors.primary,
                    size: 17,
                  ),
                  SizedBox(width: 7),
                  Text(
                    'TUSGO SERVICE',
                    style: TextStyle(
                      color: AppColors.navy,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            left: 22,
            right: 22,
            bottom: 23,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ЗАХИАЛГЫН ДЭЛГЭРЭНГҮЙ',
                  style: TextStyle(
                    color: Color(0xFFC8EDFF),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  order.service,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  'Захиалга #${order.id}',
                  style: const TextStyle(
                    color: Color(0xFFEAF7FF),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroImageFallback() {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: Center(
        child: Icon(
          order.icon,
          size: 85,
          color: Colors.white.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  Widget _statusCard() {
    return _card(
      children: [
        _sectionHeading('Захиалгын явц', Icons.timeline_rounded),
        const SizedBox(height: 17),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
          decoration: BoxDecoration(
            color: order.status.color.withValues(alpha: 0.11),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.circle, size: 9, color: order.status.color),
              const SizedBox(width: 8),
              Text(
                order.status.label,
                style: TextStyle(
                  color: order.status.color,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 23),
        if (order.status == OrderStatus.cancelled)
          _cancelledTimeline()
        else
          _progressTimeline(),
      ],
    );
  }

  Widget _progressTimeline() {
    final steps = [
      (
        OrderStatus.pending,
        'Захиалга илгээсэн',
        'Таны захиалга бүртгэгдсэн',
        Icons.receipt_long_rounded,
      ),
      (
        OrderStatus.accepted,
        'Захиалга хүлээн авсан',
        'Үйлчилгээ үзүүлэгч зөвшөөрсөн',
        Icons.handshake_outlined,
      ),
      (
        OrderStatus.inProgress,
        'Үйлчилгээ эхэлсэн',
        'Үйлчилгээ хийгдэж байна',
        Icons.handyman_outlined,
      ),
      (
        OrderStatus.completed,
        'Үйлчилгээ дууссан',
        'Захиалга амжилттай биелсэн',
        Icons.check_circle_outline_rounded,
      ),
    ];

    final currentIndex = switch (order.status) {
      OrderStatus.pending => 0,
      OrderStatus.accepted => 1,
      OrderStatus.inProgress => 2,
      OrderStatus.completed => 3,
      OrderStatus.cancelled => 0,
    };

    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final reached = index <= currentIndex;
        final isCurrent = index == currentIndex;
        final isLast = index == steps.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 40,
                child: Column(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: reached
                            ? AppColors.primary
                            : AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        reached && !isCurrent ? Icons.check_rounded : step.$4,
                        color: reached ? Colors.white : AppColors.muted,
                        size: 18,
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          color: index < currentIndex
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 3, bottom: isLast ? 0 : 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.$2,
                        style: TextStyle(
                          color: reached ? AppColors.navy : AppColors.muted,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        step.$3,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),
                      if (isCurrent) ...[
                        const SizedBox(height: 7),
                        const Text(
                          'Одоогийн төлөв',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _cancelledTimeline() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Icon(Icons.cancel_rounded, color: AppColors.danger, size: 26),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Энэ захиалга цуцлагдсан байна.',
              style: TextStyle(
                color: AppColors.danger,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _informationCard() {
    return _card(
      children: [
        _sectionHeading('Захиалгын мэдээлэл', Icons.info_outline_rounded),
        const SizedBox(height: 22),
        _infoRow(
          Icons.location_on_outlined,
          'Үйлчилгээ авах хаяг',
          order.address,
        ),
        _infoRow(Icons.phone_outlined, 'Утасны дугаар', order.phone),
        _infoRow(
          Icons.calendar_month_outlined,
          'Үйлчилгээ авах өдөр',
          _formatDate(order.date),
        ),
        _infoRow(
          Icons.schedule_outlined,
          'Үйлчилгээ авах цаг',
          '${order.startTime} – ${order.endTime}',
        ),
        if (order.arrivalTime != null)
          _infoRow(
            Icons.access_time_filled_rounded,
            'Үйлчилгээ үзүүлэгчийн ирэх цаг',
            order.arrivalTime!,
          ),
        if (order.note.trim().isNotEmpty)
          _infoRow(Icons.notes_rounded, 'Нэмэлт тайлбар', order.note),
      ],
    );
  }

  Widget _cancellationInfo() {
    return _card(
      children: [
        _sectionHeading(
          'Цуцлалтын мэдээлэл',
          Icons.cancel_outlined,
          color: AppColors.danger,
        ),
        const SizedBox(height: 20),
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

  Widget _cancelSection(BuildContext context) {
    return _card(
      children: [
        _sectionHeading(
          'Захиалга цуцлах',
          Icons.warning_amber_rounded,
          color: AppColors.danger,
        ),
        const SizedBox(height: 10),
        const Text(
          'Үйлчилгээ эхлээгүй байгаа үед '
          'захиалгаа цуцлах боломжтой.',
          style: TextStyle(color: AppColors.muted, fontSize: 12, height: 1.5),
        ),
        const SizedBox(height: 17),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            onPressed: () => _cancelOrder(context),
            icon: const Icon(Icons.cancel_outlined),
            label: const Text('Захиалга цуцлах'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.danger,
              side: const BorderSide(color: AppColors.danger),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _ratingSection(BuildContext context) {
    if (order.isRated) {
      return _card(
        children: [
          _sectionHeading(
            'Үнэлгээ өгсөн',
            Icons.verified_rounded,
            color: AppColors.success,
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              const Icon(
                Icons.star_rounded,
                color: Color(0xFFF59E0B),
                size: 32,
              ),
              const SizedBox(width: 9),
              Text(
                '${order.rating}/10',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 29,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Text(
            'Төрөл: ${order.feedbackType ?? '-'}',
            style: const TextStyle(
              color: AppColors.navy,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (order.feedbackComment != null &&
              order.feedbackComment!.isNotEmpty) ...[
            const SizedBox(height: 11),
            Text(
              order.feedbackComment!,
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ],
          const SizedBox(height: 14),
          const Text(
            'Энэ захиалгад үнэлгээ өгсөн тул '
            'дахин үнэлэх боломжгүй.',
            style: TextStyle(color: AppColors.muted, fontSize: 11),
          ),
        ],
      );
    }

    return _card(
      children: [
        _sectionHeading('Үйлчилгээг үнэлэх', Icons.star_outline_rounded),
        const SizedBox(height: 10),
        const Text(
          'Үйлчилгээ дууссан байна. Үйлчилгээний '
          'чанарыг үнэлж, санал хүсэлтээ үлдээнэ үү.',
          style: TextStyle(color: AppColors.muted, fontSize: 12, height: 1.5),
        ),
        const SizedBox(height: 18),
        Container(
          height: 53,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _openRating(context),
              borderRadius: BorderRadius.circular(16),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star_rounded, color: Colors.white, size: 22),
                  SizedBox(width: 9),
                  Text(
                    'Үнэлгээ өгөх',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 19,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionHeading(
    String title,
    IconData icon, {
    Color color = AppColors.primary,
  }) {
    return Row(
      children: [
        Container(
          width: 39,
          height: 39,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 21),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.navy,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  Widget _card({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 37,
            height: 37,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: AppColors.primary, size: 19),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: AppColors.muted, fontSize: 11),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.navy,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    height: 1.4,
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
