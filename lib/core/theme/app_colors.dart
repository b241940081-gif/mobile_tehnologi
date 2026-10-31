import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand colors
  static const primary = Color(0xFF078BD3);
  static const primaryDark = Color(0xFF056AA8);
  static const primaryLight = Color(0xFFDDF4FF);
  static const accent = Color(0xFF12B9F4);
  static const iceBlue = Color(0xFFBCEEFF);

  // Background and surfaces
  static const navy = Color(0xFF172B4D);
  static const background = Color(0xFFF4FAFF);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceSoft = Color(0xFFEDF8FF);

  // Text colors
  static const textPrimary = Color(0xFF172B4D);
  static const textSecondary = Color(0xFF526B82);
  static const muted = Color(0xFF7890A5);

  // Borders
  static const border = Color(0xFFE4EDF5);
  static const borderStrong = Color(0xFFC9DEEC);

  // Status colors
  static const pending = Color(0xFFF59E0B);
  static const success = Color(0xFF16A34A);
  static const danger = Color(0xFFDC2626);
  static const info = Color(0xFF078BD3);

  // Gradients for premium UI
  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF12B9F4), Color(0xFF078BD3), Color(0xFF056AA8)],
  );

  static const softGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE6F8FF), Color(0xFFF4FAFF), Color(0xFFFFFFFF)],
  );

  // Soft shadows
  static const cardShadow = [
    BoxShadow(color: Color(0x120B5F94), blurRadius: 24, offset: Offset(0, 10)),
  ];
}
