import 'package:flutter/material.dart';

import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_spacing.dart';

enum AppButtonVariant { primary, danger }

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.isEnabled = true,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final AppButtonVariant variant;
  final Widget? icon;
  final bool isLoading;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final isDanger = variant == AppButtonVariant.danger;
    final foreground = isDanger ? AppColors.textPrimary : AppColors.primaryText;

    final labelText = Text(label, maxLines: 1, overflow: TextOverflow.ellipsis);

    return SizedBox(
      width: double.infinity,
      height: AppSizes.buttonHeight,
      child: ElevatedButton(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        style: isDanger
            ? ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: foreground,
              )
            : null,
        child: isLoading
            ? SizedBox.square(
                dimension: AppSizes.icon,
                child: CircularProgressIndicator(
                  color: foreground,
                  strokeWidth: AppSizes.categoryBorderWidth,
                ),
              )
            : icon == null
            ? labelText
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon!,
                  SizedBox(width: AppSpacing.sm),
                  labelText,
                ],
              ),
      ),
    );
  }
}
