import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mock_notifications.dart';

// Захиалгын төлөвүүд
enum OrderStatus { pending, accepted, inProgress, completed, cancelled }

// Захиалгын төлөвийн нэр болон өнгө
extension OrderStatusInfo on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.pending:
        return 'Хүлээгдэж буй';
      case OrderStatus.accepted:
        return 'Хүлээн авсан';
      case OrderStatus.inProgress:
        return 'Гүйцэтгэж буй';
      case OrderStatus.completed:
        return 'Дууссан';
      case OrderStatus.cancelled:
        return 'Цуцлагдсан';
    }
  }

  Color get color {
    switch (this) {
      case OrderStatus.pending:
        return const Color(0xFFF59E0B);
      case OrderStatus.accepted:
        return const Color(0xFF2563EB);
      case OrderStatus.inProgress:
        return const Color(0xFF0EA5E9);
      case OrderStatus.completed:
        return const Color(0xFF16A34A);
      case OrderStatus.cancelled:
        return const Color(0xFFDC2626);
    }
  }
}

// Захиалгын модель
class MockOrder {
  final String id;
  final String service;
  final String address;
  final String phone;
  final String startTime;
  final String endTime;
  final String note;
  final String customerId;

  final IconData icon;
  final DateTime date;

  String? providerId;
  String? arrivalTime;

  OrderStatus status;

  // Үнэлгээ
  int? rating;
  String? feedbackType;
  String? feedbackComment;
  DateTime? ratedAt;

  // Цуцлалт
  String? cancellationReason;
  DateTime? cancelledAt;

  MockOrder({
    required this.id,
    required this.service,
    required this.icon,
    required this.address,
    required this.phone,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.note,
    required this.status,
    this.customerId = 'demo_customer',
    this.providerId,
    this.arrivalTime,
    this.rating,
    this.feedbackType,
    this.feedbackComment,
    this.ratedAt,
    this.cancellationReason,
    this.cancelledAt,
  });

  bool get isRated => rating != null;

  bool get canCancel =>
      status == OrderStatus.pending || status == OrderStatus.accepted;

  // Захиалгыг JSON болгон хувиргах
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service': service,
      'address': address,
      'phone': phone,
      'date': date.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'note': note,
      'customerId': customerId,
      'providerId': providerId,
      'arrivalTime': arrivalTime,
      'status': status.name,
      'rating': rating,
      'feedbackType': feedbackType,
      'feedbackComment': feedbackComment,
      'ratedAt': ratedAt?.toIso8601String(),
      'cancellationReason': cancellationReason,
      'cancelledAt': cancelledAt?.toIso8601String(),
    };
  }

  // JSON өгөгдлөөс захиалга сэргээх
  factory MockOrder.fromJson(Map<String, dynamic> json) {
    final statusName = json['status'] as String?;

    final restoredStatus = OrderStatus.values.firstWhere(
      (status) => status.name == statusName,
      orElse: () => OrderStatus.pending,
    );

    return MockOrder(
      id: json['id'] as String,
      service: json['service'] as String,
      icon: _iconForService(json['service'] as String),
      address: json['address'] as String,
      phone: json['phone'] as String,
      date: DateTime.parse(json['date'] as String),
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      note: json['note'] as String? ?? '',
      customerId: json['customerId'] as String? ?? 'demo_customer',
      providerId: json['providerId'] as String?,
      arrivalTime: json['arrivalTime'] as String?,
      status: restoredStatus,
      rating: (json['rating'] as num?)?.toInt(),
      feedbackType: json['feedbackType'] as String?,
      feedbackComment: json['feedbackComment'] as String?,
      ratedAt: json['ratedAt'] == null
          ? null
          : DateTime.parse(json['ratedAt'] as String),
      cancellationReason: json['cancellationReason'] as String?,
      cancelledAt: json['cancelledAt'] == null
          ? null
          : DateTime.parse(json['cancelledAt'] as String),
    );
  }

  // Үйлчилгээний нэрээр icon сэргээх
  static IconData _iconForService(String service) {
    switch (service) {
      case 'Ус хүргэлт':
        return Icons.water_drop_rounded;

      case 'Шатахуун хүргэлт':
        return Icons.local_gas_station_rounded;

      case 'Хог тээвэр':
        return Icons.delete_outline_rounded;

      case 'Цахилгааны үйлчилгээ':
        return Icons.electrical_services_rounded;

      case 'Ачаа тээвэр':
      case 'Ачаа зөөвөр':
      case 'Ачаа сав баглаа боодол':
        return Icons.local_shipping_rounded;

      case 'Зүлэг хадах':
        return Icons.grass_rounded;

      default:
        return Icons.home_repair_service_rounded;
    }
  }
}

// Захиалгын өгөгдөл болон үйлдлүүд
class MockOrders extends ChangeNotifier {
  MockOrders._();

  static final MockOrders instance = MockOrders._();

  static const String _storageKey = 'tusgo_orders_v1';

  // Анхны туршилтын захиалгууд
  final List<MockOrder> orders = [
    MockOrder(
      id: 'TG-1001',
      service: 'Ус хүргэлт',
      icon: Icons.water_drop_rounded,
      address: 'Улаанбаатар, Баянзүрх дүүрэг',
      phone: '99112233',
      date: DateTime(2026, 11, 1),
      startTime: '11:00',
      endTime: '14:00',
      note: 'Хашааны хаалгаар ороорой.',
      status: OrderStatus.pending,
    ),
    MockOrder(
      id: 'TG-1002',
      service: 'Цахилгааны үйлчилгээ',
      icon: Icons.electrical_services_rounded,
      address: 'Улаанбаатар, Сүхбаатар дүүрэг',
      phone: '99887766',
      date: DateTime(2026, 10, 27),
      startTime: '09:00',
      endTime: '11:00',
      arrivalTime: '09:30',
      note: 'Гэрлийн унтраалга засуулах.',
      status: OrderStatus.completed,
      providerId: 'demo_provider',
    ),
    MockOrder(
      id: 'TG-1003',
      service: 'Хог тээвэр',
      icon: Icons.delete_outline_rounded,
      address: 'Улаанбаатар, Сонгинохайрхан дүүрэг',
      phone: '99001122',
      date: DateTime(2026, 11, 3),
      startTime: '13:00',
      endTime: '16:00',
      arrivalTime: '14:00',
      note: 'Ахуйн хог ачуулах.',
      status: OrderStatus.accepted,
      providerId: 'demo_provider',
    ),
  ];

  // Хадгалсан өгөгдлийг сэргээх
  Future<void> loadOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedData = prefs.getString(_storageKey);

      if (savedData == null) {
        // Анх удаа ажиллаж байвал demo өгөгдлийг хадгална
        await saveOrders();
        return;
      }

      final decoded = jsonDecode(savedData) as List<dynamic>;

      final restoredOrders = decoded.map((item) {
        return MockOrder.fromJson(Map<String, dynamic>.from(item as Map));
      }).toList();

      orders
        ..clear()
        ..addAll(restoredOrders);

      notifyListeners();
    } catch (error) {
      debugPrint('Захиалга сэргээхэд алдаа гарлаа: $error');
    }
  }

  // Одоогийн захиалгуудыг хадгалах
  Future<void> saveOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final encoded = jsonEncode(
        orders.map((order) => order.toJson()).toList(),
      );

      final success = await prefs.setString(_storageKey, encoded);

      if (!success) {
        debugPrint('Захиалгыг хадгалж чадсангүй.');
      }
    } catch (error) {
      debugPrint('Захиалга хадгалахад алдаа гарлаа: $error');
    }
  }

  // Өөрчлөлтийг UI-д мэдэгдэж, хадгална
  void _notifyAndSave() {
    notifyListeners();
    saveOrders();
  }

  // 1. Customer шинэ захиалга үүсгэх
  MockOrder createOrder({
    required String service,
    required IconData icon,
    required String address,
    required String phone,
    required DateTime date,
    required String startTime,
    required String endTime,
    required String note,
    String customerId = 'demo_customer',
  }) {
    final nextNumber =
        orders.fold<int>(1000, (maxId, order) {
          final number = int.tryParse(order.id.replaceFirst('TG-', '')) ?? 1000;

          return number > maxId ? number : maxId;
        }) +
        1;

    final order = MockOrder(
      id: 'TG-$nextNumber',
      service: service,
      icon: icon,
      address: address,
      phone: phone,
      date: date,
      startTime: startTime,
      endTime: endTime,
      note: note,
      status: OrderStatus.pending,
      customerId: customerId,
    );

    orders.insert(0, order);
    _notifyAndSave();

    // Provider-д шинэ захиалгын мэдэгдэл
    MockNotifications.instance.add(
      role: NotificationRole.provider,
      title: 'Шинэ захиалга ирлээ',
      message:
          '$service үйлчилгээний шинэ захиалга '
          'бүртгэгдлээ. Захиалгын дугаар: ${order.id}.',
      orderId: order.id,
    );

    return order;
  }

  // 2. Provider захиалга хүлээн авах
  void acceptOrder(
    MockOrder order,
    String arrivalTime, {
    String providerId = 'demo_provider',
  }) {
    if (!orders.contains(order)) return;
    if (order.status != OrderStatus.pending) return;
    if (order.providerId != null) return;

    final start = _timeToMinutes(order.startTime);
    final end = _timeToMinutes(order.endTime);
    final arrival = _timeToMinutes(arrivalTime);

    if (arrival < start || arrival > end) return;

    order.arrivalTime = arrivalTime;
    order.providerId = providerId;
    order.status = OrderStatus.accepted;

    _notifyAndSave();

    // Customer-д захиалга хүлээн авсан мэдэгдэл
    MockNotifications.instance.add(
      role: NotificationRole.customer,
      title: 'Таны захиалгыг хүлээн авлаа',
      message:
          '${order.service} үйлчилгээний '
          '${order.id} дугаартай захиалгыг Provider '
          'хүлээн авлаа. Ирэх цаг: $arrivalTime.',
      orderId: order.id,
    );
  }

  // 3. Provider ажил эхлүүлэх / дуусгах
  void advanceOrder(MockOrder order) {
    if (!orders.contains(order)) return;

    if (order.status == OrderStatus.accepted) {
      order.status = OrderStatus.inProgress;

      _notifyAndSave();

      MockNotifications.instance.add(
        role: NotificationRole.customer,
        title: 'Таны үйлчилгээ эхэллээ',
        message:
            '${order.id} дугаартай ${order.service} '
            'үйлчилгээний ажил эхэллээ.',
        orderId: order.id,
      );
    } else if (order.status == OrderStatus.inProgress) {
      order.status = OrderStatus.completed;

      _notifyAndSave();

      MockNotifications.instance.add(
        role: NotificationRole.customer,
        title: 'Таны үйлчилгээ дууслаа',
        message:
            '${order.id} дугаартай ${order.service} '
            'үйлчилгээ амжилттай дууслаа. '
            'Та үйлчилгээг үнэлэх боломжтой.',
        orderId: order.id,
      );
    }
  }

  // 4. Захиалгын төлөв өөрчлөх
  void updateStatus(MockOrder order, OrderStatus status) {
    if (!orders.contains(order)) return;
    if (order.status == OrderStatus.cancelled) return;
    if (status == OrderStatus.cancelled) return;

    order.status = status;
    _notifyAndSave();
  }

  // 5. Customer захиалга цуцлах
  bool cancelOrder({required MockOrder order, required String reason}) {
    if (!orders.contains(order)) return false;
    if (!order.canCancel) return false;

    final trimmedReason = reason.trim();
    if (trimmedReason.isEmpty) return false;

    final assignedProvider = order.providerId != null;

    order.status = OrderStatus.cancelled;
    order.cancellationReason = trimmedReason;
    order.cancelledAt = DateTime.now();

    _notifyAndSave();

    // Provider-д цуцлалтын мэдэгдэл
    if (assignedProvider) {
      MockNotifications.instance.add(
        role: NotificationRole.provider,
        title: 'Захиалга цуцлагдлаа',
        message:
            '${order.id} дугаартай ${order.service} '
            'захиалгыг Customer цуцаллаа. '
            'Шалтгаан: $trimmedReason',
        orderId: order.id,
      );
    }

    return true;
  }

  // 6. Customer үйлчилгээ үнэлэх
  bool submitRating({
    required MockOrder order,
    required int rating,
    required String feedbackType,
    required String comment,
  }) {
    if (!orders.contains(order)) return false;
    if (order.status != OrderStatus.completed) return false;
    if (order.isRated) return false;
    if (rating < 1 || rating > 10) return false;

    if (!['Талархал', 'Санал', 'Гомдол'].contains(feedbackType)) {
      return false;
    }

    order.rating = rating;
    order.feedbackType = feedbackType;
    order.feedbackComment = comment.trim();
    order.ratedAt = DateTime.now();

    _notifyAndSave();

    // Provider-д үнэлгээний мэдэгдэл
    if (order.providerId != null) {
      MockNotifications.instance.add(
        role: NotificationRole.provider,
        title: 'Шинэ үнэлгээ ирлээ',
        message:
            '${order.id} дугаартай ${order.service} '
            'үйлчилгээнд $rating/10 онооны үнэлгээ ирлээ. '
            'Төрөл: $feedbackType.',
        orderId: order.id,
      );
    }

    return true;
  }

  // Цагийг минутад хөрвүүлэх
  int _timeToMinutes(String time) {
    final parts = time.split(':');

    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }
}
