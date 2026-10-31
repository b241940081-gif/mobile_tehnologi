import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../auth/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _getStarted(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 20,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 40,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildHeader(),

                          const SizedBox(height: 28),

                          _buildHeroCard(),

                          const SizedBox(height: 25),

                          _buildIntro(),

                          const SizedBox(height: 24),

                          _buildFeatures(),

                          const Spacer(),

                          const SizedBox(height: 28),

                          _buildStartButton(context),

                          const SizedBox(height: 15),

                          const Text(
                            'Таны өдөр тутмын найдвартай туслах',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.muted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 47,
          height: 47,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(15),
            boxShadow: AppColors.cardShadow,
          ),
          child: const Icon(
            Icons.home_work_rounded,
            color: Colors.white,
            size: 27,
          ),
        ),

        const SizedBox(width: 11),

        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TusGo',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.9,
                color: AppColors.navy,
                height: 1.1,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'HOME SERVICES',
              style: TextStyle(
                fontSize: 9,
                letterSpacing: 2,
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),

        const Spacer(),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                size: 13,
                color: AppColors.primary,
              ),
              SizedBox(width: 5),
              Text(
                '2.0',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeroCard() {
    return AspectRatio(
      aspectRatio: 0.93,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: AppColors.primary,
          boxShadow: const [
            BoxShadow(
              color: Color(0x25078BD3),
              blurRadius: 28,
              offset: Offset(0, 14),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/hero_worker.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
              errorBuilder: (_, _, _) {
                return const Center(
                  child: Icon(
                    Icons.home_repair_service_rounded,
                    size: 110,
                    color: Colors.white,
                  ),
                );
              },
            ),

            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x100C3569),
                    Color(0x000C3569),
                    Color(0xE8072D60),
                  ],
                  stops: [0, 0.38, 1],
                ),
              ),
            ),

            Positioned(
              top: 17,
              left: 17,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.93),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.verified_rounded,
                      size: 15,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Найдвартай үйлчилгээ',
                      style: TextStyle(
                        color: AppColors.navy,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Positioned(
              left: 22,
              right: 22,
              bottom: 23,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ТУСЛАМЖ ТАНЫ ДЭРГЭД',
                    style: TextStyle(
                      color: Color(0xFFBCEEFF),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.7,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Бүх үйлчилгээ\nнэг дор.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 31,
                      fontWeight: FontWeight.w900,
                      height: 1.12,
                      letterSpacing: -0.8,
                    ),
                  ),
                  SizedBox(height: 9),
                  Text(
                    'Хэрэгтэй үед тань бид тусална.',
                    style: TextStyle(color: Color(0xFFEAF7FF), fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntro() {
    return const Column(
      children: [
        Text(
          'Өдөр тутмын ажлаа\nилүү хялбар болго.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.navy,
            fontSize: 27,
            height: 1.18,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.7,
          ),
        ),
        SizedBox(height: 11),
        Text(
          'Ус хүргэлт, түлээ нүүрс, цэвэрлэгээ, засвар '
          'болон бусад үйлчилгээг нэг дороос захиалаарай.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.muted, fontSize: 13, height: 1.55),
        ),
      ],
    );
  }

  Widget _buildFeatures() {
    return Row(
      children: [
        Expanded(
          child: _feature(
            Icons.verified_user_rounded,
            'Найдвартай',
            const Color(0xFFE7F4FF),
            AppColors.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _feature(
            Icons.bolt_rounded,
            'Хурдан',
            const Color(0xFFFFF1E7),
            const Color(0xFFEE8A3A),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _feature(
            Icons.favorite_rounded,
            'Хялбар',
            const Color(0xFFE8F8F2),
            const Color(0xFF18A67F),
          ),
        ),
      ],
    );
  }

  Widget _feature(
    IconData icon,
    String label,
    Color background,
    Color foreground,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: foreground, size: 22),
          ),
          const SizedBox(height: 9),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.navy,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(19),
        boxShadow: const [
          BoxShadow(
            color: Color(0x35078BD3),
            blurRadius: 20,
            offset: Offset(0, 9),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(19),
          onTap: () => _getStarted(context),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Эхлэх',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(width: 12),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
