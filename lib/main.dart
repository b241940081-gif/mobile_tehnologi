import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';

import 'data/mock_orders.dart';
import 'data/mock_notifications.dart';
import 'data/mock_provider.dart';
import 'data/mock_services.dart';

import 'screens/welcome/welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Захиалгуудыг сэргээх
  await MockOrders.instance.loadOrders();

  // Мэдэгдлүүдийг сэргээх
  await MockNotifications.instance.loadNotifications();

  // Provider-ийн мэдээллийг сэргээх
  await MockProvider.instance.loadProvider();

  // Admin-ийн үйлчилгээний тохиргоог сэргээх
  await MockServices.instance.loadServices();

  // Аппыг ажиллуулах
  runApp(const TusGoApp());
}

class TusGoApp extends StatelessWidget {
  const TusGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TusGo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const WelcomeScreen(),
    );
  }
}
