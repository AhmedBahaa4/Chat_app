import 'package:flutter/material.dart';

class AppPalette {
  const AppPalette._();

  static const Color primary = Color(0xFF0F766E);
  static const Color primaryDeep = Color(0xFF115E59);
  static const Color secondary = Color(0xFFFB923C);
  static const Color background = Color(0xFFF2F7F8);
  static const Color surface = Colors.white;
  static const Color surfaceSoft = Color(0xFFEAF1F3);
  static const Color textStrong = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF475569);
  static const Color success = Color(0xFF16A34A);

  static const LinearGradient homeBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFEFF7F8),
      Color(0xFFF7FAFC),
      Color(0xFFE9F3F6),
    ],
  );

  static const LinearGradient userBubbleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0F766E),
      Color(0xFF155E75),
    ],
  );
}
