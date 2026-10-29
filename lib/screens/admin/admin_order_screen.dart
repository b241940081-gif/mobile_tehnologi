import 'package:flutter/material.dart';

import '../../data/mock_orders.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  OrderStatus? selectedStatus;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      appBar: AppBar(
        title: const Text('Бүх захиалгууд'),
        backgroundColor: Colors.white,
      ),
      body: AnimatedBuilder(
        animation: MockOrders.instance,
        builder: (context, _) {
          final orders = MockOrders.instance.orders.where((order) {
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

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  const Text(
                    'Захиалгын удирдлага',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Системийн бүх захиалгыг хянах',
                    style: TextStyle(color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Захиалгын дугаар, үйлчилгээ, хаяг...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
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

                  const SizedBox(height: 20),

                  Text(
                    'Нийт ${orders.length} захиалга',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF64748B),
                    ),
                  ),

                  const SizedBox(height: 14),

                  if (orders.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: Text('Захиалга олдсонгүй'),
                      ),
                    )
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

  Widget _filterChip(String label, OrderStatus? status) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selectedStatus == status,
        onSelected: (_) {
          setState(() {
            selectedStatus = status;
          });
        },
      ),
    );
  }

  Widget _orderCard(MockOrder order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      elevation: 0,
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFEAF2FF),
          child: Icon(order.icon, color: const Color(0xFF2563EB)),
        ),
        title: Text(
          order.service,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Text('${order.id}\n${order.address}'),
        isThreeLine: true,
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AdminOrderDetailsScreen(order: order),
            ),
          );
        },
      ),
    );
  }
}

class AdminOrderDetailsScreen extends StatelessWidget {
  final MockOrder order;

  const AdminOrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      appBar: AppBar(title: Text(order.id), backgroundColor: Colors.white),
      body: AnimatedBuilder(
        animation: MockOrders.instance,
        builder: (context, _) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.service,
                            style: const TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Chip(
                            label: Text(order.status.label),
                            backgroundColor: order.status.color.withValues(
                              alpha: 0.12,
                            ),
                            labelStyle: TextStyle(color: order.status.color),
                          ),
                          const Divider(height: 28),
                          _info('Захиалгын дугаар', order.id),
                          _info('Утас', order.phone),
                          _info('Хаяг', order.address),
                          _info(
                            'Огноо',
                            '${order.date.year}-${order.date.month}-${order.date.day}',
                          ),
                          _info('Цаг', '${order.startTime} - ${order.endTime}'),
                          _info('Очих цаг', order.arrivalTime ?? 'Тодорхойгүй'),
                          _info('Гүйцэтгэгч', order.providerId ?? 'Байхгүй'),
                          _info(
                            'Нэмэлт тайлбар',
                            order.note.isEmpty ? 'Байхгүй' : order.note,
                          ),
                          if (order.isRated) ...[
                            const Divider(height: 28),
                            const Text(
                              'Хэрэглэгчийн үнэлгээ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _info('Оноо', '${order.rating}/10'),
                            _info('Төрөл', order.feedbackType ?? '-'),
                            _info(
                              'Сэтгэгдэл',
                              order.feedbackComment ?? 'Байхгүй',
                            ),
                          ],
                        ],
                      ),
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

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
