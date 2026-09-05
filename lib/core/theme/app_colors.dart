import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color primary = Color(0xFFF6BD00);
  static const Color primaryText = Color(0xFF121312);

  static const Color background = Color(0xFF121312);
  static const Color surface = Color(0xFF282A28);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xB3FFFFFF);

  static const Color error = Color(0xFFE82626);
  static const Color success = Color(0xFF57AA53);

  static const Color posterOverlay = Color(0x99121312);

  static const List<Color> onboardingShadows = [
    background,
    Color(0xFF084250),
    Color(0xFF85210D),
    Color(0xFF4C1B63),
    Color(0xFF561625),
    Color(0xFF525A5D),
  ];
}
