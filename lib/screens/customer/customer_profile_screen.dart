import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/mock_orders.dart';
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

  // Одоогийн validation болон хадгалах ажиллагааг хэвээр үлдээсэн.
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
        backgroundColor: AppColors.success,
      ),
    );

    setState(() {});
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
    return AnimatedBuilder(
      animation: MockOrders.instance,
      builder: (context, _) {
        final orders = MockOrders.instance.orders;
        final completed = orders
            .where((order) => order.status == OrderStatus.completed)
            .length;
        final active = orders
            .where(
              (order) =>
                  order.status == OrderStatus.pending ||
                  order.status == OrderStatus.accepted ||
                  order.status == OrderStatus.inProgress,
            )
            .length;

        return ColoredBox(
          color: AppColors.background,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 36),
                children: [
                  _profileHeader(),
                  const SizedBox(height: 22),
                  _statistics(
                    total: orders.length,
                    completed: completed,
                    active: active,
                  ),
                  const SizedBox(height: 27),
                  _sectionHeading(
                    'Хувийн мэдээлэл',
                    'Мэдээллээ шинэчилж, удирдаарай',
                    Icons.manage_accounts_outlined,
                  ),
                  const SizedBox(height: 15),
                  _informationCard(),
                  const SizedBox(height: 23),
                  _saveButton(),
                  const SizedBox(height: 13),
                  _logoutButton(),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'TusGo 2.0 • Таны өдөр тутмын найдвартай туслах',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.muted, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _profileHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 27),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26078BD3),
            blurRadius: 25,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: -90,
            right: -45,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.10),
              ),
            ),
          ),
          Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 95,
                    height: 95,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.25),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.75),
                        width: 2,
                      ),
                    ),
                    child: const CircleAvatar(
                      backgroundColor: Color(0xFFE5F6FF),
                      child: Icon(
                        Icons.person_rounded,
                        color: AppColors.primary,
                        size: 49,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: -3,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary, width: 2),
                      ),
                      child: const Icon(
                        Icons.verified_rounded,
                        color: AppColors.primary,
                        size: 19,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 17),
              const Text(
                'МИНИЙ ПРОФАЙЛ',
                style: TextStyle(
                  color: Color(0xFFD9F3FF),
                  fontSize: 11,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                nameController.text.trim().isEmpty
                    ? 'TusGo хэрэглэгч'
                    : nameController.text.trim(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                emailController.text,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFFE6F6FF), fontSize: 12),
              ),
              const SizedBox(height: 17),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.19),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.workspace_premium_rounded,
                      color: Colors.white,
                      size: 17,
                    ),
                    SizedBox(width: 7),
                    Text(
                      'TusGo Customer',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statistics({
    required int total,
    required int completed,
    required int active,
  }) {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            title: 'Нийт',
            value: total,
            icon: Icons.receipt_long_rounded,
            color: AppColors.primary,
            background: AppColors.primaryLight,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: _statCard(
            title: 'Дууссан',
            value: completed,
            icon: Icons.check_circle_outline_rounded,
            color: AppColors.success,
            background: const Color(0xFFE7F8EF),
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: _statCard(
            title: 'Идэвхтэй',
            value: active,
            icon: Icons.bolt_rounded,
            color: AppColors.pending,
            background: const Color(0xFFFFF4DF),
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required String title,
    required int value,
    required IconData icon,
    required Color color,
    required Color background,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 11),
          Text(
            '$value',
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeading(String title, String subtitle, IconData icon) {
    return Row(
      children: [
        Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: AppColors.primary, size: 23),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.navy,
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: AppColors.muted, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _informationCard() {
    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _fieldLabel('Таны нэр'),
          const SizedBox(height: 9),
          _profileField(
            controller: nameController,
            icon: Icons.person_outline_rounded,
            hint: 'Овог нэрээ оруулна уу',
          ),
          const SizedBox(height: 19),
          _fieldLabel('Утасны дугаар'),
          const SizedBox(height: 9),
          _profileField(
            controller: phoneController,
            icon: Icons.phone_outlined,
            hint: '8 оронтой утасны дугаар',
            keyboardType: TextInputType.phone,
            maxLength: 8,
          ),
          const SizedBox(height: 19),
          _fieldLabel('И-мэйл хаяг'),
          const SizedBox(height: 9),
          _profileField(
            controller: emailController,
            icon: Icons.email_outlined,
            hint: 'example@email.com',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 17),
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.primary,
                  size: 21,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Мэдээллээ өөрчилсний дараа '
                    'хадгалах товчийг дарна уу.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.navy,
        fontSize: 13,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _profileField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    TextInputType? keyboardType,
    int? maxLength,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.muted, fontSize: 12),
        prefixIcon: Icon(icon, color: AppColors.primary, size: 21),
        counterText: '',
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 17,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _saveButton() {
    return Container(
      height: 57,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(17),
        boxShadow: const [
          BoxShadow(
            color: Color(0x30078BD3),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: saveProfile,
          borderRadius: BorderRadius.circular(17),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.save_outlined, color: Colors.white, size: 21),
              SizedBox(width: 10),
              Text(
                'Мэдээлэл хадгалах',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(width: 9),
              Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logoutButton() {
    return SizedBox(
      height: 54,
      child: OutlinedButton.icon(
        onPressed: logout,
        icon: const Icon(Icons.logout_rounded),
        label: const Text(
          'Гарах',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.danger,
          backgroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFFF5C6C6)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
        ),
      ),
    );
  }
}
