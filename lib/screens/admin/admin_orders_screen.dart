import 'package:flutter/material.dart';

import '../../data/mock_orders.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  static const navy = Color(0xFF172D52);
  static const blue = Color(0xFF078FD2);
  static const background = Color(0xFFF1F9FF);
  static const muted = Color(0xFF7894AF);

  OrderStatus? selectedStatus;
  String searchQuery = '';

  String _date(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.'
        '${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        foregroundColor: navy,
        title: const Text(
          'Бүх захиалгууд',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 21),
        ),
      ),
      body: AnimatedBuilder(
        animation: MockOrders.instance,
        builder: (context, _) {
          final allOrders = MockOrders.instance.orders;

          final orders = allOrders.where((order) {
            final matchesStatus =
                selectedStatus == null || order.status == selectedStatus;

            final query = searchQuery.trim().toLowerCase();

            final matchesSearch =
                query.isEmpty ||
                order.id.toLowerCase().contains(query) ||
                order.service.toLowerCase().contains(query) ||
                order.address.toLowerCase().contains(query) ||
                order.phone.contains(query);

            return matchesStatus && matchesSearch;
          }).toList();

          final completed = allOrders
              .where((order) => order.status == OrderStatus.completed)
              .length;

          final cancelled = allOrders
              .where((order) => order.status == OrderStatus.cancelled)
              .length;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 32),
                children: [
                  _hero(allOrders.length),
                  const SizedBox(height: 22),

                  Row(
                    children: [
                      Expanded(
                        child: _statCard(
                          'Нийт',
                          allOrders.length,
                          Icons.receipt_long_rounded,
                          blue,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _statCard(
                          'Дууссан',
                          completed,
                          Icons.check_circle_outline_rounded,
                          const Color(0xFF16A34A),
                        ),
                      ),
                      const SizedBox(width: 10),
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

                  const SizedBox(height: 30),

                  _sectionHeading(
                    Icons.manage_search_rounded,
                    'Захиалгын удирдлага',
                    'Захиалгуудыг хайж, төлөвөөр шүүнэ үү.',
                  ),

                  const SizedBox(height: 18),

                  TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    style: const TextStyle(color: navy),
                    decoration: InputDecoration(
                      hintText: 'Дугаар, үйлчилгээ, хаягаар хайх',
                      hintStyle: const TextStyle(color: muted, fontSize: 14),
                      prefixIcon: const Icon(Icons.search_rounded, color: blue),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 18),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: const BorderSide(color: Color(0xFFDCEBF7)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: const BorderSide(color: blue, width: 1.5),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

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

                  const SizedBox(height: 22),

                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Захиалгын жагсаалт',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: navy,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDFF4FF),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          '${orders.length} захиалга',
                          style: const TextStyle(
                            color: blue,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  if (orders.isEmpty)
                    _emptyState()
                  else
                    ...orders.map(_orderCard),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _hero(int count) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF12B7EC), Color(0xFF0873B6)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: blue.withValues(alpha: 0.15),
            blurRadius: 24,
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
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.admin_panel_settings_rounded,
                  color: Colors.white,
                  size: 17,
                ),
                SizedBox(width: 7),
                Text(
                  'TUSGO ADMIN',
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
          const SizedBox(height: 23),
          const Text(
            'Захиалгын хяналт',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 9),
          const Text(
            'Системийн бүх захиалгын мэдээллийг '
            'нэг дороос хянаж удирдаарай.',
            style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Text(
              'Нийт $count захиалга бүртгэгдсэн',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String label, int count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 19),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: const Color(0xFFDCEBF7)),
      ),
      child: Column(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 13),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          const SizedBox(height: 5),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: const TextStyle(
                color: muted,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeading(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFFDDF4FF),
            borderRadius: BorderRadius.circular(17),
          ),
          child: Icon(icon, color: blue, size: 26),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: navy,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: muted, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _filterChip(String label, OrderStatus? status) {
    final selected = selectedStatus == status;

    return Padding(
      padding: const EdgeInsets.only(right: 9),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        showCheckmark: false,
        backgroundColor: Colors.white,
        selectedColor: blue,
        side: BorderSide(color: selected ? blue : const Color(0xFFDCEBF7)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        labelStyle: TextStyle(
          color: selected ? Colors.white : muted,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        onSelected: (_) {
          setState(() {
            selectedStatus = status;
          });
        },
      ),
    );
  }

  Widget _orderCard(MockOrder order) {
    final statusColor = order.status.color;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: const Color(0xFFDCEBF7)),
        boxShadow: [
          BoxShadow(
            color: navy.withValues(alpha: 0.025),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(23),
        child: InkWell(
          borderRadius: BorderRadius.circular(23),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AdminOrderDetailsScreen(order: order),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDFF4FF),
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: Icon(order.icon, color: blue, size: 29),
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.service,
                            style: const TextStyle(
                              color: navy,
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
                    const Icon(Icons.chevron_right_rounded, color: blue),
                  ],
                ),

                const SizedBox(height: 15),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, size: 9, color: statusColor),
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

                const SizedBox(height: 15),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      _miniInfo(Icons.location_on_outlined, order.address),
                      const SizedBox(height: 9),
                      _miniInfo(
                        Icons.calendar_month_outlined,
                        '${_date(order.date)}  •  '
                        '${order.startTime} – ${order.endTime}',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                Row(
                  children: [
                    const Icon(
                      Icons.open_in_new_rounded,
                      size: 16,
                      color: blue,
                    ),
                    const SizedBox(width: 7),
                    const Expanded(
                      child: Text(
                        'Дэлгэрэнгүй мэдээлэл',
                        style: TextStyle(
                          color: blue,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    if (order.isRated)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3DF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${order.rating}/10 ★',
                          style: const TextStyle(
                            color: Color(0xFFE58A00),
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _miniInfo(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 17, color: blue),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: navy,
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 45),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFDCEBF7)),
      ),
      child: const Column(
        children: [
          Icon(Icons.search_off_rounded, size: 55, color: muted),
          SizedBox(height: 14),
          Text(
            'Захиалга олдсонгүй',
            style: TextStyle(
              color: navy,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 7),
          Text(
            'Хайлтын үг эсвэл шүүлтүүрээ өөрчилнө үү.',
            textAlign: TextAlign.center,
            style: TextStyle(color: muted),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// ADMIN ORDER DETAILS
// =====================================================

class AdminOrderDetailsScreen extends StatelessWidget {
  final MockOrder order;

  const AdminOrderDetailsScreen({super.key, required this.order});

  static const navy = Color(0xFF172D52);
  static const blue = Color(0xFF078FD2);
  static const background = Color(0xFFF1F9FF);
  static const muted = Color(0xFF7894AF);

  String _date(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          'Захиалгын дэлгэрэнгүй',
          style: TextStyle(
            color: navy,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: navy,
        surfaceTintColor: Colors.white,
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
                  _hero(),
                  const SizedBox(height: 20),
                  _statusCard(),
                  const SizedBox(height: 20),
                  _detailsCard(),
                  if (order.isRated) ...[
                    const SizedBox(height: 20),
                    _ratingCard(),
                  ],
                  const SizedBox(height: 25),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _hero() {
    return Container(
      padding: const EdgeInsets.all(23),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF14B4EB), Color(0xFF0871B6)],
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.20),
              borderRadius: BorderRadius.circular(19),
            ),
            child: Icon(order.icon, color: Colors.white, size: 35),
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
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  'Захиалга: ${order.id}',
                  style: const TextStyle(color: Colors.white, fontSize: 13),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Захиалгын төлөв',
            style: TextStyle(
              color: navy,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
            decoration: BoxDecoration(
              color: order.status.color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, size: 10, color: order.status.color),
                const SizedBox(width: 9),
                Text(
                  order.status.label,
                  style: TextStyle(
                    color: order.status.color,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailsCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(Icons.receipt_long_rounded, 'Захиалгын мэдээлэл'),
          const SizedBox(height: 22),
          _info(Icons.tag_rounded, 'Захиалгын дугаар', order.id),
          _info(Icons.phone_outlined, 'Утасны дугаар', order.phone),
          _info(
            Icons.location_on_outlined,
            'Үйлчилгээ авах хаяг',
            order.address,
          ),
          _info(
            Icons.calendar_month_outlined,
            'Үйлчилгээ авах өдөр',
            _date(order.date),
          ),
          _info(
            Icons.schedule_rounded,
            'Захиалсан цаг',
            '${order.startTime} – ${order.endTime}',
          ),
          _info(
            Icons.access_time_rounded,
            'Үйлчилгээ үзүүлэгчийн ирэх цаг',
            order.arrivalTime ?? 'Тодорхойгүй',
          ),
          _info(
            Icons.engineering_outlined,
            'Гүйцэтгэгч',
            order.providerId ?? 'Байхгүй',
          ),
          _info(
            Icons.notes_rounded,
            'Нэмэлт тайлбар',
            order.note.isEmpty ? 'Байхгүй' : order.note,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _ratingCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(Icons.star_rounded, 'Хэрэглэгчийн үнэлгээ'),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7E8),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: Color(0xFFF59E0B),
                  size: 35,
                ),
                const SizedBox(width: 10),
                Text(
                  '${order.rating}/10',
                  style: const TextStyle(
                    color: navy,
                    fontSize: 27,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _info(
            Icons.category_outlined,
            'Санал хүсэлтийн төрөл',
            order.feedbackType ?? '-',
          ),
          _info(
            Icons.chat_bubble_outline_rounded,
            'Сэтгэгдэл',
            order.feedbackComment ?? 'Байхгүй',
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFDFF4FF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: blue),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: navy,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  Widget _info(
    IconData icon,
    String label,
    String value, {
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(icon, color: blue, size: 21),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: muted, fontSize: 12)),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 15,
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

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFDCEBF7)),
      ),
      child: child,
    );
  }
}
