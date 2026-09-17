import 'package:flutter/material.dart';

import 'package:movies_app/core/widgets/app_button.dart';

class PrimaryWatchButton extends StatelessWidget {
  const PrimaryWatchButton({required this.label, this.onPressed, super.key});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: label,
      onPressed: onPressed ?? () {},
      variant: AppButtonVariant.danger,
    );
  }
}
