import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:movies_app/core/theme/app_colors.dart';

abstract final class AppTextStyles {
  static const String _fontFamily = 'Roboto';

  static TextStyle get displayLarge => _style(36, FontWeight.w500);

  static TextStyle get displayMedium => _style(36, FontWeight.w700);

  static TextStyle get headlineSmall =>
      _style(24, FontWeight.w700, height: 1.39);

  static TextStyle get titleLarge => _style(24, FontWeight.w700);

  static TextStyle get titleMedium => _style(20, FontWeight.w700);

  static TextStyle get titleSmall => _style(20, FontWeight.w400);

  static TextStyle get labelLarge => _style(20, FontWeight.w600);

  static TextStyle get bodyLarge => _style(20, FontWeight.w400, height: 1.6);

  static TextStyle get bodyMedium => _style(16, FontWeight.w400);

  static TextStyle get bodySmall => _style(14, FontWeight.w400);

  static TextTheme get textTheme => TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    labelLarge: labelLarge,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
  );

  static TextStyle _style(
    double size,
    FontWeight weight, {
    double height = 1.2,
  }) => TextStyle(
    color: AppColors.textPrimary,
    fontFamily: _fontFamily,
    fontSize: size.sp,
    fontWeight: weight,
    height: height,
  );
}
