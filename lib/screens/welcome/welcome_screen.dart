import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../auth/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF8FCFF), Color(0xFFD9EEFF), Color(0xFFB8DFFF)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.home_work_rounded,
                          color: AppColors.primary,
                          size: 40,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'TusGo',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            color: AppColors.navy,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 50),

                    const Text(
                      'Тус хэрэгтэй үед — TusGo.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        height: 1.2,
                        fontWeight: FontWeight.w900,
                        color: AppColors.navy,
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Өдөр тутмын хэрэгцээт үйлчилгээг '
                      'нэг дороос хялбар захиалаарай.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: AppColors.muted,
                      ),
                    ),

                    const SizedBox(height: 32),

                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=900',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.engineering_rounded,
                              size: 150,
                              color: AppColors.primary,
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _feature(Icons.verified_outlined, 'Найдвартай'),
                        const SizedBox(width: 20),
                        _feature(Icons.schedule, 'Хурдан'),
                        const SizedBox(width: 20),
                        _feature(Icons.favorite_border, 'Хялбар'),
                      ],
                    ),

                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Эхлэх',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 12),
                            Icon(Icons.arrow_forward_rounded),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _feature(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.primary, size: 17),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.navy,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
