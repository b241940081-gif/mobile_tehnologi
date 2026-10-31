import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
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

  bool showPassword = false;
  bool showConfirmPassword = false;

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  // Өмнөх demo бүртгэлийн логикийг хадгалсан.
  void register() {
    if (!formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Demo бүртгэл амжилттай')));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void backToLogin() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 26),
                      _buildRegisterCard(),
                      const SizedBox(height: 20),
                      const Text(
                        'TUSGO • YOUR EVERYDAY HELPER',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 1.7,
                          fontWeight: FontWeight.w700,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          height: 350,
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(42)),
          ),
          child: Stack(
            children: [
              Positioned(top: -80, right: -75, child: _circle(230, 0.10)),
              Positioned(top: 150, left: -95, child: _circle(200, 0.08)),
              Positioned(bottom: -60, right: 35, child: _circle(150, 0.08)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circle(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: opacity),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 66,
          height: 66,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
          ),
          child: const Icon(
            Icons.home_work_rounded,
            color: Colors.white,
            size: 36,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'TusGo',
          style: TextStyle(
            color: Colors.white,
            fontSize: 35,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Таны өдөр тутмын найдвартай туслах',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFE5F6FF),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(23, 27, 23, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(29),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1B17476D),
            blurRadius: 35,
            offset: Offset(0, 15),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Бүртгэл үүсгэх ✨',
              style: TextStyle(
                color: AppColors.navy,
                fontSize: 25,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.6,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'TusGo-д нэгдэж, хэрэгтэй үйлчилгээгээ '
              'хялбар захиалаарай.',
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 12,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 25),

            _fieldLabel('Овог нэр'),
            const SizedBox(height: 9),
            TextFormField(
              controller: name,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration: _inputDecoration(
                hint: 'Овог нэрээ оруулна уу',
                icon: Icons.person_outline_rounded,
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Нэрээ оруулна уу'
                  : null,
            ),

            const SizedBox(height: 19),

            _fieldLabel('И-мэйл хаяг'),
            const SizedBox(height: 9),
            TextFormField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: _inputDecoration(
                hint: 'example@email.com',
                icon: Icons.mail_outline_rounded,
              ),
              validator: (value) {
                if (value == null ||
                    !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                        .hasMatch(value.trim())) {
                  return 'Зөв и-мэйл оруулна уу';
                }
                return null;
              },
            ),

            const SizedBox(height: 19),

            _fieldLabel('Утасны дугаар'),
            const SizedBox(height: 9),
            TextFormField(
              controller: phone,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              decoration: _inputDecoration(
                hint: '8 оронтой дугаар',
                icon: Icons.phone_outlined,
              ),
              validator: (value) =>
                  RegExp(r'^\d{8}$').hasMatch(value?.trim() ?? '')
                  ? null
                  : '8 оронтой дугаар оруулна уу',
            ),

            const SizedBox(height: 19),

            _fieldLabel('Нууц үг'),
            const SizedBox(height: 9),
            TextFormField(
              controller: password,
              obscureText: !showPassword,
              textInputAction: TextInputAction.next,
              decoration:
                  _inputDecoration(
                    hint: '6-аас дээш тэмдэгт',
                    icon: Icons.lock_outline_rounded,
                  ).copyWith(
                    suffixIcon: IconButton(
                      tooltip: showPassword ? 'Нууц үг нуух' : 'Нууц үг харах',
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                      icon: Icon(
                        showPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.muted,
                        size: 21,
                      ),
                    ),
                  ),
              validator: (value) => value == null || value.length < 6
                  ? '6-аас дээш тэмдэгт оруулна уу'
                  : null,
            ),

            const SizedBox(height: 19),

            _fieldLabel('Нууц үг давтах'),
            const SizedBox(height: 9),
            TextFormField(
              controller: confirmPassword,
              obscureText: !showConfirmPassword,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => register(),
              decoration:
                  _inputDecoration(
                    hint: 'Нууц үгээ дахин оруулна уу',
                    icon: Icons.lock_reset_outlined,
                  ).copyWith(
                    suffixIcon: IconButton(
                      tooltip: showConfirmPassword
                          ? 'Нууц үг нуух'
                          : 'Нууц үг харах',
                      onPressed: () {
                        setState(() {
                          showConfirmPassword = !showConfirmPassword;
                        });
                      },
                      icon: Icon(
                        showConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.muted,
                        size: 21,
                      ),
                    ),
                  ),
              validator: (value) {
                if (value != password.text) {
                  return 'Нууц үг таарахгүй байна';
                }
                return null;
              },
            ),

            const SizedBox(height: 28),

            _registerButton(),

            const SizedBox(height: 19),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Flexible(
                  child: Text(
                    'Бүртгэлтэй юу?',
                    style: TextStyle(color: AppColors.muted, fontSize: 12),
                  ),
                ),
                TextButton(
                  onPressed: backToLogin,
                  child: const Text(
                    'Нэвтрэх',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _fieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.navy,
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.muted, fontSize: 13),
      prefixIcon: Icon(icon, color: AppColors.primary, size: 21),
      filled: true,
      fillColor: AppColors.background,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 17),
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
        borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
      ),
    );
  }

  Widget _registerButton() {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(17),
        boxShadow: const [
          BoxShadow(
            color: Color(0x30078BD3),
            blurRadius: 16,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: register,
          borderRadius: BorderRadius.circular(17),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Бүртгэл үүсгэх',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(width: 10),
              Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 21),
            ],
          ),
        ),
      ),
    );
  }
}
