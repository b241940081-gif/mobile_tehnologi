import 'package:flutter/material.dart';

import '../../data/mock_orders.dart';
import '../../data/mock_provider.dart';
import '../../data/mock_services.dart';
import '../../models/service_item.dart';

class ProviderOrdersScreen extends StatefulWidget {
  const ProviderOrdersScreen({super.key});

  @override
  State<ProviderOrdersScreen> createState() => _ProviderOrdersScreenState();
}

class _ProviderOrdersScreenState extends State<ProviderOrdersScreen> {
  static const _blue = Color(0xFF078FD5);
  static const _navy = Color(0xFF182E52);
  static const _muted = Color(0xFF7994AE);
  static const _surface = Color(0xFFF2F9FE);
  static const _line = Color(0xFFDCEAF6);

  final TextEditingController searchController = TextEditingController();
  OrderStatus? selectedFilter;
  String searchQuery = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  bool belongsToProvider(MockOrder order) {
    if (order.status != OrderStatus.pending) {
      return order.providerId == 'demo_provider';
    }
    if (order.providerId != null && order.providerId != 'demo_provider') {
      return false;
    }
    return services.any(
      (service) =>
          service.title == order.service &&
          MockProvider.instance.provides(service.id),
    );
  }

  bool isOrderServiceActive(MockOrder order) {
    for (final service in services) {
      if (service.title == order.service) {
        return MockServices.instance.isActive(service.id);
      }
    }
    return false;
  }

  String formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }

  String formatDateTime(DateTime date) {
    return '${formatDate(date)} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        MockOrders.instance,
        MockProvider.instance,
        MockServices.instance,
      ]),
      builder: (context, _) {
        final allOrders = MockOrders.instance.orders
            .where(belongsToProvider)
            .toList();
        final filteredOrders = allOrders.where((order) {
          final query = searchQuery.trim().toLowerCase();
          final matchesSearch =
              query.isEmpty ||
              order.id.toLowerCase().contains(query) ||
              order.service.toLowerCase().contains(query) ||
              order.address.toLowerCase().contains(query);
          final matchesStatus =
              selectedFilter == null || order.status == selectedFilter;
          return matchesSearch && matchesStatus;
        }).toList();

        final pendingCount = allOrders
            .where((order) => order.status == OrderStatus.pending)
            .length;
        final completedCount = allOrders
            .where((order) => order.status == OrderStatus.completed)
            .length;

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              children: [
                _hero(),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        'Нийт',
                        allOrders.length,
                        Icons.receipt_long_rounded,
                        _blue,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _statCard(
                        'Шинэ',
                        pendingCount,
                        Icons.notifications_active_outlined,
                        const Color(0xFFF59E0B),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _statCard(
                        'Дууссан',
                        completedCount,
                        Icons.check_circle_outline_rounded,
                        const Color(0xFF16A34A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 26),
                const Text(
                  'Захиалгын жагсаалт',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                    color: _navy,
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  'Өөрт хамаарах захиалгуудаа нэг дороос хараарай.',
                  style: TextStyle(color: _muted, fontSize: 13),
                ),
                const SizedBox(height: 17),
                TextField(
                  controller: searchController,
                  onChanged: (value) => setState(() => searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Захиалга, үйлчилгээ, хаягаар хайх',
                    hintStyle: const TextStyle(color: _muted, fontSize: 14),
                    prefixIcon: const Icon(Icons.search_rounded, color: _blue),
                    suffixIcon: searchQuery.isNotEmpty
                        ? IconButton(
                            tooltip: 'Хайлтыг цэвэрлэх',
                            onPressed: () {
                              searchController.clear();
                              setState(() => searchQuery = '');
                            },
                            icon: const Icon(Icons.close_rounded),
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 18),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(17),
                      borderSide: const BorderSide(color: _line),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(17),
                      borderSide: const BorderSide(color: _blue, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
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
                Text(
                  'Нийт ${allOrders.length} захиалга  •  Илэрц ${filteredOrders.length}',
                  style: const TextStyle(
                    color: _muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),
                if (filteredOrders.isEmpty) _emptyState(),
                ...filteredOrders.map(_orderCard),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _hero() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF13B5EB), Color(0xFF0067A9)],
        ),
        borderRadius: BorderRadius.circular(27),
        boxShadow: [
          BoxShadow(
            color: _blue.withValues(alpha: 0.16),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_rounded, color: Colors.white, size: 16),
                SizedBox(width: 7),
                Text(
                  'TUSGO PROVIDER',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Миний захиалгууд',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Шинэ захиалга, ажлын явц болон түүхээ хялбар удирдаарай.',
            style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String title, int count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: _line),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: color, size: 23),
          ),
          const SizedBox(height: 10),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            title,
            style: const TextStyle(
              color: _muted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, OrderStatus? status) {
    final selected = selectedFilter == status;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => setState(() => selectedFilter = status),
        backgroundColor: Colors.white,
        selectedColor: _blue,
        side: BorderSide(color: selected ? _blue : _line),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        labelStyle: TextStyle(
          color: selected ? Colors.white : _muted,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      ),
    );
  }

  Widget _emptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 42, horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: _line),
      ),
      child: const Column(
        children: [
          Icon(Icons.inbox_outlined, color: _blue, size: 46),
          SizedBox(height: 12),
          Text(
            'Захиалга олдсонгүй',
            style: TextStyle(
              color: _navy,
              fontWeight: FontWeight.w800,
              fontSize: 17,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Хайлт эсвэл төлөвийн шүүлтүүрээ өөрчилж үзээрэй.',
            textAlign: TextAlign.center,
            style: TextStyle(color: _muted),
          ),
        ],
      ),
    );
  }

  // Match the stored order's service title to the existing local photo.
  String? _servicePhoto(MockOrder order) {
    final name = order.service.toLowerCase();
    const rules = <(String, String)>[
      ('хүүхэд', 'babysitting.jpg'),
      ('цонх', 'window_cleaning.jpg'),
      ('хашаа', 'yard_cleaning.jpg'),
      ('цас', 'snow_removal.jpg'),
      ('өвс', 'grass.jpg'),
      ('тавилга', 'furniture.jpg'),
      ('сантехник', 'plumbing.jpg'),
      ('цахилгаан', 'electric.jpg'),
      ('шуудай', 'packing.jpg'),
      ('савлах', 'packing.jpg'),
      ('багц', 'packing.jpg'),
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

  Widget _photoFallback(MockOrder order) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF12B6ED), Color(0xFF0068AC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.center,
      child: Icon(order.icon, size: 65, color: Colors.white70),
    );
  }

  Widget _orderPhoto(MockOrder order, {double height = 185}) {
    final path = _servicePhoto(order);
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (path != null)
            Image.asset(
              path,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _photoFallback(order),
            )
          else
            _photoFallback(order),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x050B2D50), Color(0xDD0B2D50)],
              ),
            ),
          ),
          Positioned(
            left: 19,
            right: 19,
            bottom: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.service,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Захиалга #${order.id}',
                  style: const TextStyle(
                    color: Color(0xFFE7F6FF),
                    fontSize: 12,
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

  Widget _orderCard(MockOrder order) {
    final isCancelled = order.status == OrderStatus.cancelled;
    final isInactivePending =
        order.status == OrderStatus.pending && !isOrderServiceActive(order);

    return Container(
      margin: const EdgeInsets.only(bottom: 17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isCancelled ? const Color(0xFFFBCACA) : _line,
        ),
        boxShadow: [
          BoxShadow(
            color: _navy.withValues(alpha: 0.055),
            blurRadius: 19,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showDetails(order),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _orderPhoto(order),
              Padding(
                padding: const EdgeInsets.all(17),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _statusBadge(order.status),
                        if (isInactivePending)
                          _pill(
                            'Үйлчилгээ идэвхгүй',
                            const Color(0xFFB91C1C),
                            const Color(0xFFFEE2E2),
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _surface,
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: Column(
                        children: [
                          _infoRow(
                            Icons.calendar_month_outlined,
                            formatDate(order.date),
                          ),
                          _infoRow(
                            Icons.access_time_rounded,
                            '${order.startTime} – ${order.endTime}',
                          ),
                          _infoRow(
                            Icons.location_on_outlined,
                            order.address,
                            last: true,
                          ),
                        ],
                      ),
                    ),
                    if (isInactivePending) ...[
                      const SizedBox(height: 12),
                      const Text(
                        'Энэ үйлчилгээ идэвхгүй тул шинэ захиалга хүлээн авах боломжгүй.',
                        style: TextStyle(
                          color: Color(0xFFB91C1C),
                          fontSize: 12,
                        ),
                      ),
                    ],
                    if (isCancelled) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Цуцалсан шалтгаан: ${order.cancellationReason ?? "-"}',
                          style: const TextStyle(
                            color: Color(0xFF991B1B),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    const Divider(height: 1, color: _line),
                    const SizedBox(height: 14),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Дэлгэрэнгүй харах',
                          style: TextStyle(
                            color: _blue,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: _blue,
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

  Widget _statusBadge(OrderStatus status) =>
      _pill(status.label, status.color, status.color.withValues(alpha: 0.10));

  Widget _pill(String text, Color foreground, Color background) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: foreground,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            text,
            style: TextStyle(
              color: foreground,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String value, {bool last = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 17, color: _blue),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: _navy, fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  void _showDetails(MockOrder order) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 510, maxHeight: 690),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(19),
                        child: _orderPhoto(order, height: 180),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Захиалгын төлөв',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: _navy,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _statusBadge(order.status),
                      const SizedBox(height: 22),
                      const Text(
                        'Захиалгын мэдээлэл',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: _navy,
                        ),
                      ),
                      const SizedBox(height: 15),
                      _detailRow(
                        Icons.location_on_outlined,
                        'Хаяг',
                        order.address,
                      ),
                      _detailRow(Icons.phone_outlined, 'Утас', order.phone),
                      _detailRow(
                        Icons.calendar_month_outlined,
                        'Өдөр',
                        formatDate(order.date),
                      ),
                      _detailRow(
                        Icons.access_time_rounded,
                        'Захиалсан цаг',
                        '${order.startTime} – ${order.endTime}',
                      ),
                      if (order.arrivalTime != null)
                        _detailRow(
                          Icons.schedule_rounded,
                          'Баталгаажсан ирэх цаг',
                          order.arrivalTime!,
                        ),
                      if (order.note.trim().isNotEmpty)
                        _detailRow(
                          Icons.notes_rounded,
                          'Нэмэлт тайлбар',
                          order.note,
                        ),
                      if (order.status == OrderStatus.cancelled) ...[
                        const Divider(height: 30, color: _line),
                        const Text(
                          'Цуцлалтын мэдээлэл',
                          style: TextStyle(
                            color: Color(0xFFDC2626),
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _detailRow(
                          Icons.info_outline_rounded,
                          'Шалтгаан',
                          order.cancellationReason ?? '-',
                        ),
                        if (order.cancelledAt != null)
                          _detailRow(
                            Icons.event_busy_outlined,
                            'Цуцалсан огноо',
                            formatDateTime(order.cancelledAt!),
                          ),
                      ],
                      if (order.isRated) ...[
                        const Divider(height: 30, color: _line),
                        const Text(
                          'Хэрэглэгчийн үнэлгээ',
                          style: TextStyle(
                            color: _navy,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _detailRow(
                          Icons.star_rounded,
                          'Үнэлгээ',
                          '${order.rating}/10',
                        ),
                        _detailRow(
                          Icons.feedback_outlined,
                          'Санал хүсэлтийн төрөл',
                          order.feedbackType ?? '-',
                        ),
                        if (order.feedbackComment != null)
                          _detailRow(
                            Icons.chat_bubble_outline_rounded,
                            'Сэтгэгдэл',
                            order.feedbackComment!,
                          ),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Хаах',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 17),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFE6F6FE),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: _blue, size: 19),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: _muted, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: _navy,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
