import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AuthLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const AuthLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFEAF5FF), Color(0xFFF8FAFC), Color(0xFFFFFFFF)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.navy.withValues(alpha: 0.07),
                        blurRadius: 30,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.home_work_rounded,
                            color: AppColors.primary,
                            size: 34,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'TusGo',
                            style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.w800,
                              color: AppColors.navy,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: AppColors.muted,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 28),
                      child,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool password;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.password = false,
    this.keyboardType,
    this.validator,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool hidden = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.password && hidden,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: Icon(widget.icon),
        suffixIcon: widget.password
            ? IconButton(
                onPressed: () => setState(() => hidden = !hidden),
                icon: Icon(hidden ? Icons.visibility_off : Icons.visibility),
              )
            : null,
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
