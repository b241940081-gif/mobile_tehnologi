import 'package:flutter/material.dart';

import '../../core/widgets/auth_widgets.dart';

import '../customer/home_screen.dart';
import '../provider/provider_dashboard.dart';
import '../admin/admin_dashboard.dart';

import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  final email = TextEditingController();
  final password = TextEditingController();

  String role = 'customer';

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void login() {
    // Формын мэдээллийг шалгана
    if (!formKey.currentState!.validate()) return;

    Widget destination;

    // Сонгосон эрхээс хамааран дэлгэц сонгоно
    switch (role) {
      case 'customer':
        destination = const HomeScreen();
        break;

      case 'provider':
        destination = const ProviderDashboard();
        break;

      case 'admin':
        destination = const AdminDashboard();
        break;

      default:
        return;
    }

    // Өмнөх дэлгэцүүдийг цэвэрлэж нэвтэрнэ
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => destination),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Нэвтрэх',
      subtitle: 'TusGo-д тавтай морил. Үргэлжлүүлэхийн тулд нэвтэрнэ үү.',
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Хэрэглэгчийн эрх сонгох
            SegmentedButton<String>(
              segments: const [
                ButtonSegment<String>(
                  value: 'customer',
                  label: Text('Customer'),
                ),
                ButtonSegment<String>(
                  value: 'provider',
                  label: Text('Provider'),
                ),
                ButtonSegment<String>(value: 'admin', label: Text('Admin')),
              ],
              selected: {role},
              onSelectionChanged: (value) {
                setState(() {
                  role = value.first;
                });
              },
            ),

            const SizedBox(height: 24),

            // Имэйл
            AuthTextField(
              controller: email,
              label: 'И-мэйл хаяг',
              icon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null ||
                    !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                        .hasMatch(value.trim())) {
                  return 'Зөв и-мэйл оруулна уу';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            // Нууц үг
            AuthTextField(
              controller: password,
              label: 'Нууц үг',
              icon: Icons.lock_outline,
              password: true,
              validator: (value) {
                if (value == null || value.length < 6) {
                  return 'Нууц үг хамгийн багадаа 6 тэмдэгт байна';
                }

                return null;
              },
            ),

            const SizedBox(height: 24),

            // Нэвтрэх товч
            ElevatedButton(onPressed: login, child: const Text('Нэвтрэх')),

            const SizedBox(height: 16),

            // Бүртгүүлэх дэлгэц рүү шилжих
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                );
              },
              child: const Text('Бүртгэлгүй юу? Бүртгүүлэх'),
            ),
          ],
        ),
      ),
    );
  }
}
