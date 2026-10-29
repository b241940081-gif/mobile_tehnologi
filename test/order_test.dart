import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tusgo_v2/data/mock_orders.dart';
import 'package:tusgo_v2/data/mock_notifications.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
  });

  final orders = MockOrders.instance;

  // Тест бүрд шинэ захиалга үүсгэх туслах функц
  MockOrder createTestOrder() {
    return orders.createOrder(
      service: 'Ус хүргэлт',
      icon: Icons.water_drop_rounded,
      address: 'Тест хаяг',
      phone: '99112233',
      date: DateTime(2026, 11, 1),
      startTime: '10:00',
      endTime: '14:00',
      note: 'Автомат тест',
    );
  }

  group('TusGo Order Tests', () {
    test('Customer creates a pending order', () {
      final order = createTestOrder();

      expect(order.status, OrderStatus.pending);
      expect(orders.orders.contains(order), true);
      expect(order.providerId, isNull);
    });

    test('Provider accepts an order', () {
      final order = createTestOrder();

      orders.acceptOrder(order, '11:00');

      expect(order.status, OrderStatus.accepted);
      expect(order.providerId, 'demo_provider');
      expect(order.arrivalTime, '11:00');
    });

    test('Invalid arrival time is rejected', () {
      final order = createTestOrder();

      orders.acceptOrder(order, '15:00');

      expect(order.status, OrderStatus.pending);
      expect(order.providerId, isNull);
    });

    test('Order moves to completed', () {
      final order = createTestOrder();

      orders.acceptOrder(order, '11:00');
      expect(order.status, OrderStatus.accepted);

      orders.advanceOrder(order);
      expect(order.status, OrderStatus.inProgress);

      orders.advanceOrder(order);
      expect(order.status, OrderStatus.completed);

      // Дууссан захиалгыг дахин шилжүүлэхгүй
      orders.advanceOrder(order);
      expect(order.status, OrderStatus.completed);
    });

    test('Customer can cancel pending order', () {
      final order = createTestOrder();

      final result = orders.cancelOrder(
        order: order,
        reason: 'Захиалга шаардлагагүй болсон',
      );

      expect(result, true);
      expect(order.status, OrderStatus.cancelled);
      expect(order.cancellationReason, 'Захиалга шаардлагагүй болсон');
      expect(order.cancelledAt, isNotNull);
    });

    test('Completed order cannot be cancelled', () {
      final order = createTestOrder();

      orders.acceptOrder(order, '11:00');
      orders.advanceOrder(order);
      orders.advanceOrder(order);

      final result = orders.cancelOrder(order: order, reason: 'Цуцлах');

      expect(result, false);
      expect(order.status, OrderStatus.completed);
    });

    test('Customer can rate completed order', () {
      final order = createTestOrder();

      orders.acceptOrder(order, '11:00');
      orders.advanceOrder(order);
      orders.advanceOrder(order);

      final result = orders.submitRating(
        order: order,
        rating: 9,
        feedbackType: 'Талархал',
        comment: 'Үйлчилгээ сайн байлаа',
      );

      expect(result, true);
      expect(order.rating, 9);
      expect(order.isRated, true);
      expect(order.feedbackType, 'Талархал');
    });

    test('Customer cannot rate the same order twice', () {
      final order = createTestOrder();

      orders.acceptOrder(order, '11:00');
      orders.advanceOrder(order);
      orders.advanceOrder(order);

      orders.submitRating(
        order: order,
        rating: 9,
        feedbackType: 'Талархал',
        comment: 'Сайн',
      );

      final secondResult = orders.submitRating(
        order: order,
        rating: 5,
        feedbackType: 'Санал',
        comment: 'Дахин үнэлэх',
      );

      expect(secondResult, false);
      expect(order.rating, 9);
    });

    test('Notifications are generated for order actions', () {
      final notifications = MockNotifications.instance;
      final beforeProvider = notifications
          .forRole(NotificationRole.provider)
          .length;
      final beforeCustomer = notifications
          .forRole(NotificationRole.customer)
          .length;

      final order = createTestOrder();

      expect(
        notifications.forRole(NotificationRole.provider).length,
        beforeProvider + 1,
      );

      orders.acceptOrder(order, '11:00');

      expect(
        notifications.forRole(NotificationRole.customer).length,
        beforeCustomer + 1,
      );
    });
  });
}
