import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum NotificationRole { customer, provider }

// Мэдэгдлийн модель
class AppNotification {
  final String id;
  final NotificationRole role;
  final String title;
  final String message;
  final DateTime createdAt;
  final String? orderId;

  bool isRead;

  AppNotification({
    required this.id,
    required this.role,
    required this.title,
    required this.message,
    required this.createdAt,
    this.orderId,
    this.isRead = false,
  });

  // Мэдэгдлийг JSON болгон хувиргах
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role.name,
      'title': title,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
      'orderId': orderId,
      'isRead': isRead,
    };
  }

  // JSON өгөгдлөөс мэдэгдэл сэргээх
  factory AppNotification.fromJson(Map<String, dynamic> json) {
    final roleName = json['role'] as String?;

    final restoredRole = NotificationRole.values.firstWhere(
      (role) => role.name == roleName,
      orElse: () => NotificationRole.customer,
    );

    return AppNotification(
      id: json['id'] as String,
      role: restoredRole,
      title: json['title'] as String,
      message: json['message'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      orderId: json['orderId'] as String?,
      isRead: json['isRead'] as bool? ?? false,
    );
  }
}

// Мэдэгдлийн өгөгдөл болон үйлдлүүд
class MockNotifications extends ChangeNotifier {
  MockNotifications._();

  static final MockNotifications instance = MockNotifications._();

  static const String _storageKey = 'tusgo_notifications_v1';

  final List<AppNotification> _notifications = [];

  // Хадгалсан мэдэгдлүүдийг сэргээх
  Future<void> loadNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedData = prefs.getString(_storageKey);

      if (savedData == null) {
        return;
      }

      final decoded = jsonDecode(savedData) as List<dynamic>;

      final restoredNotifications = decoded.map((item) {
        return AppNotification.fromJson(Map<String, dynamic>.from(item as Map));
      }).toList();

      _notifications
        ..clear()
        ..addAll(restoredNotifications);

      notifyListeners();
    } catch (error) {
      debugPrint('Мэдэгдэл сэргээхэд алдаа гарлаа: $error');
    }
  }

  // Мэдэгдлүүдийг Local Storage-д хадгалах
  Future<void> saveNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final encoded = jsonEncode(
        _notifications.map((notification) => notification.toJson()).toList(),
      );

      final success = await prefs.setString(_storageKey, encoded);

      if (!success) {
        debugPrint('Мэдэгдлийг хадгалж чадсангүй.');
      }
    } catch (error) {
      debugPrint('Мэдэгдэл хадгалахад алдаа гарлаа: $error');
    }
  }

  // UI шинэчлэх болон хадгалах
  void _notifyAndSave() {
    notifyListeners();
    saveNotifications();
  }

  // Тухайн хэрэглэгчийн мэдэгдлүүд
  List<AppNotification> forRole(NotificationRole role) {
    final result = _notifications
        .where((notification) => notification.role == role)
        .toList();

    result.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return result;
  }

  // Уншаагүй мэдэгдлийн тоо
  int unreadCount(NotificationRole role) {
    return _notifications
        .where(
          (notification) => notification.role == role && !notification.isRead,
        )
        .length;
  }

  // Шинэ мэдэгдэл нэмэх
  void add({
    required NotificationRole role,
    required String title,
    required String message,
    String? orderId,
  }) {
    final now = DateTime.now();

    _notifications.add(
      AppNotification(
        id: now.microsecondsSinceEpoch.toString(),
        role: role,
        title: title,
        message: message,
        createdAt: now,
        orderId: orderId,
      ),
    );

    _notifyAndSave();
  }

  // Нэг мэдэгдлийг уншсан болгох
  void markAsRead(String id) {
    for (final notification in _notifications) {
      if (notification.id == id && !notification.isRead) {
        notification.isRead = true;

        _notifyAndSave();
        return;
      }
    }
  }

  // Бүх мэдэгдлийг уншсан болгох
  void markAllAsRead(NotificationRole role) {
    bool changed = false;

    for (final notification in _notifications) {
      if (notification.role == role && !notification.isRead) {
        notification.isRead = true;
        changed = true;
      }
    }

    if (changed) {
      _notifyAndSave();
    }
  }
}
