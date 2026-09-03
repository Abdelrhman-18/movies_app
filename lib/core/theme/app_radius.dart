import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract final class AppRadius {
  static BorderRadius get small => BorderRadius.circular(12.r);
  static BorderRadius get medium => BorderRadius.circular(16.r);
  static BorderRadius get large => BorderRadius.circular(20.r);

  static BorderRadiusDirectional get topMedium =>
      BorderRadiusDirectional.only(
        topStart: Radius.circular(16.r),
        topEnd: Radius.circular(16.r),
      );
}