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
  final TextEditingController searchController = TextEditingController();

  OrderStatus? selectedFilter;
  String searchQuery = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  bool belongsToProvider(MockOrder order) {
    // Хүлээн авсан болон түүхэн захиалгууд зөвхөн энэ Provider-ийнх.
    if (order.status != OrderStatus.pending) {
      return order.providerId == 'demo_provider';
    }

    // Шинэ захиалга өөр Provider-д оноогдоогүй байх ёстой.
    if (order.providerId != null && order.providerId != 'demo_provider') {
      return false;
    }

    // Шинэ захиалга сонгосон үйлчилгээтэй таарч байх ёстой.
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
    return '${date.year}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.day.toString().padLeft(2, '0')}';
  }

  String formatDateTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '${formatDate(date)} $hour:$minute';
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

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                const Text(
                  'Миний захиалгууд',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Өөрт хамаарах захиалгуудын мэдээлэл',
                  style: TextStyle(color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() => searchQuery = value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Захиалга, үйлчилгээ, хаягаар хайх',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: searchQuery.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              searchController.clear();
                              setState(() => searchQuery = '');
                            },
                            icon: const Icon(Icons.close_rounded),
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
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

                const SizedBox(height: 18),

                Text(
                  'Нийт ${allOrders.length} захиалга'
                  ' • Илэрц ${filteredOrders.length}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF475569),
                  ),
                ),

                const SizedBox(height: 14),

                if (filteredOrders.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(child: Text('Захиалга олдсонгүй')),
                  ),

                ...filteredOrders.map(_orderCard),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _filterChip(String label, OrderStatus? status) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selectedFilter == status,
        onSelected: (_) {
          setState(() => selectedFilter = status);
        },
      ),
    );
  }

  Widget _orderCard(MockOrder order) {
    final isCancelled = order.status == OrderStatus.cancelled;
    final isInactivePending =
        order.status == OrderStatus.pending && !isOrderServiceActive(order);

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: isCancelled
              ? const Color(0xFFFCA5A5)
              : const Color(0xFFE2E8F0),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _showDetails(order),
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                runSpacing: 6,
                children: [
                  Chip(
                    label: Text(order.status.label),
                    backgroundColor: order.status.color.withValues(alpha: 0.12),
                    labelStyle: TextStyle(color: order.status.color),
                  ),
                  Chip(label: Text('#${order.id}')),
                  if (isInactivePending)
                    const Chip(
                      label: Text('Үйлчилгээ идэвхгүй'),
                      backgroundColor: Color(0xFFFEE2E2),
                      labelStyle: TextStyle(color: Color(0xFFB91C1C)),
                    ),
                ],
              ),

              const SizedBox(height: 8),

              _infoRow(Icons.calendar_month_outlined, formatDate(order.date)),
              _infoRow(
                Icons.access_time_rounded,
                '${order.startTime}–${order.endTime}',
              ),
              _infoRow(Icons.location_on_outlined, order.address),

              if (isInactivePending) ...[
                const SizedBox(height: 10),
                const Text(
                  'Энэ үйлчилгээ идэвхгүй тул шинэ захиалга хүлээн авах боломжгүй.',
                  style: TextStyle(color: Color(0xFFB91C1C)),
                ),
              ],

              if (isCancelled) ...[
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Цуцалсан шалтгаан: '
                    '${order.cancellationReason ?? "-"}',
                    style: const TextStyle(color: Color(0xFF991B1B)),
                  ),
                ),
              ],

              const SizedBox(height: 10),

              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Дэлгэрэнгүй харах',
                    style: TextStyle(
                      color: Color(0xFF2563EB),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 5),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: Color(0xFF2563EB),
                    size: 18,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF64748B)),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Color(0xFF64748B)),
            ),
          ),
        ],
      ),
    );
  }

  void _showDetails(MockOrder order) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Захиалга ${order.id}'),
          content: SizedBox(
            width: 450,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.service,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Төлөв: ${order.status.label}',
                    style: TextStyle(
                      color: order.status.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(height: 26),

                  _detailRow('Хаяг', order.address),
                  _detailRow('Утас', order.phone),
                  _detailRow('Өдөр', formatDate(order.date)),
                  _detailRow(
                    'Захиалсан цаг',
                    '${order.startTime}–${order.endTime}',
                  ),

                  if (order.arrivalTime != null)
                    _detailRow('Баталгаажсан ирэх цаг', order.arrivalTime!),

                  if (order.note.trim().isNotEmpty)
                    _detailRow('Тайлбар', order.note),

                  if (order.status == OrderStatus.cancelled) ...[
                    const Divider(height: 26),
                    const Text(
                      'Цуцлалтын мэдээлэл',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFDC2626),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _detailRow('Шалтгаан', order.cancellationReason ?? '-'),
                    if (order.cancelledAt != null)
                      _detailRow(
                        'Цуцалсан огноо',
                        formatDateTime(order.cancelledAt!),
                      ),
                  ],

                  if (order.isRated) ...[
                    const Divider(height: 26),
                    _detailRow('Үнэлгээ', '${order.rating}/10'),
                    _detailRow(
                      'Санал хүсэлтийн төрөл',
                      order.feedbackType ?? '-',
                    ),
                    if (order.feedbackComment != null)
                      _detailRow('Сэтгэгдэл', order.feedbackComment!),
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

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
