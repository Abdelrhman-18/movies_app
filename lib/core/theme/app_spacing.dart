import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract final class AppSpacing {
  static double get xs => 8.w;
  static double get sm => 12.w;
  static double get md => 16.w;
  static double get lg => 20.w;
  static double get xl => 24.w;

  static double get screenPadding => 16.w;
  static double get gridSpacing => 20.w;
}

abstract final class AppSizes {
  static double get buttonHeight => 56.h;
  static double get fieldHeight => 56.h;

  static double get between => 19.h;
  static double get space => 30.h;
  static double get gridWidth => 18.w;
  static double get gridRaduis => 30.r;
  static double get height => 25.h;
  static double get avatarGrid => 109.r;


  static double get navBarHeight => 61.h;
  static double get navBarMargin => 9.w;

  static double get chipHeight => 48.h;
  static double get genreChipHeight => 33.h;

  static double get avatar => 118.r;

  static double get appBarHeight => 48.h;
  static double get appBarLeadingWidth => 25.w;

  static double get categoryBorderWidth => 2.w;
  static double get tabIndicatorThickness => 2.h;

  static double get icon => 24.r;
  static double get iconSmall => 16.r;

  static double get castImage => 56.r;

  static double get badgeHorizontalPadding => 8.w;
  static double get badgeVerticalPadding => 8.h;

  static double get languageOptionWidth => 48.w;

  static double get emptyIllustration => avatar;
}