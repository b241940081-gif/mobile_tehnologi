import 'package:flutter/material.dart';

import '../auth/login_screen.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  final nameController = TextEditingController(text: 'TusGo хэрэглэгч');

  final phoneController = TextEditingController(text: '99112233');

  final emailController = TextEditingController(text: 'customer@tusgo.mn');

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void saveProfile() {
    if (nameController.text.trim().isEmpty ||
        !RegExp(r'^\d{8}$').hasMatch(phoneController.text.trim()) ||
        !emailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Мэдээллээ зөв оруулна уу.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Профайл хадгалагдлаа.'),
        backgroundColor: Color(0xFF16A34A),
      ),
    );
  }

  void logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _header(),
            const SizedBox(height: 24),
            _profileCard(),
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: saveProfile,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Мэдээлэл хадгалах'),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 52,
              child: OutlinedButton.icon(
                onPressed: logout,
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Гарах'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFDC2626),
                  side: const BorderSide(color: Color(0xFFFECACA)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1D4ED8), Color(0xFF60A5FA)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Column(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person_rounded,
              size: 40,
              color: Color(0xFF2563EB),
            ),
          ),
          SizedBox(height: 14),
          Text(
            'Миний профайл',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Хувийн мэдээллээ удирдаарай',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _profileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Хувийн мэдээлэл',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Нэр',
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            maxLength: 8,
            decoration: const InputDecoration(
              labelText: 'Утас',
              prefixIcon: Icon(Icons.phone_outlined),
              counterText: '',
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Имэйл',
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
