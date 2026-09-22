import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LogoAnimation extends StatelessWidget {
  const LogoAnimation({
    super.key,
    this.width = 200,
    this.height = 200,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/app_logo.png',
      width: width,
      height: height,
      fit: BoxFit.contain,
    )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .fadeIn(
          duration: 1400.ms,
          curve: Curves.easeOut,
        )
        .scale(
          begin: const Offset(0.6, 0.6),
          end: const Offset(1.0, 1.0),
          duration: 1400.ms,
          curve: Curves.easeOutBack,
        )
        .shake(
          duration: 1400.ms,
          hz: 3,
          offset: const Offset(6, 0),
        );
  }
}
