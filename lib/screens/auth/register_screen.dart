import 'package:flutter/material.dart';

import '../../core/widgets/auth_widgets.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  void register() {
    if (!formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Demo бүртгэл амжилттай')));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Бүртгүүлэх',
      subtitle: 'TusGo-ийн шинэ хэрэглэгч болох мэдээллээ оруулна уу.',
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthTextField(
              controller: name,
              label: 'Овог нэр',
              icon: Icons.person_outline,
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Нэрээ оруулна уу'
                  : null,
            ),
            const SizedBox(height: 16),
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
            AuthTextField(
              controller: phone,
              label: 'Утасны дугаар',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (value) =>
                  RegExp(r'^\d{8}$').hasMatch(value?.trim() ?? '')
                  ? null
                  : '8 оронтой дугаар оруулна уу',
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: password,
              label: 'Нууц үг',
              icon: Icons.lock_outline,
              password: true,
              validator: (value) => value == null || value.length < 6
                  ? '6-аас дээш тэмдэгт оруулна уу'
                  : null,
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: confirmPassword,
              label: 'Нууц үг давтах',
              icon: Icons.lock_reset_outlined,
              password: true,
              validator: (value) {
                if (value != password.text) {
                  return 'Нууц үг таарахгүй байна';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: register,
              child: const Text('Бүртгэл үүсгэх'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Бүртгэлтэй юу? Нэвтрэх'),
            ),
          ],
        ),
      ),
    );
  }
}
