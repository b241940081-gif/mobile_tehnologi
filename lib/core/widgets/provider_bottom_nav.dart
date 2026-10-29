import 'package:flutter/material.dart';

class ProviderBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const ProviderBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      backgroundColor: Colors.white,
      indicatorColor: const Color(0xFFEAF2FF),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded, color: Color(0xFF2563EB)),
          label: 'Нүүр',
        ),
        NavigationDestination(
          icon: Icon(Icons.work_outline_rounded),
          selectedIcon: Icon(Icons.work_rounded, color: Color(0xFF2563EB)),
          label: 'Миний ажил',
        ),
        NavigationDestination(
          icon: Icon(Icons.receipt_long_outlined),
          selectedIcon: Icon(
            Icons.receipt_long_rounded,
            color: Color(0xFF2563EB),
          ),
          label: 'Захиалга',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline_rounded),
          selectedIcon: Icon(Icons.person_rounded, color: Color(0xFF2563EB)),
          label: 'Профайл',
        ),
      ],
    );
  }
}
