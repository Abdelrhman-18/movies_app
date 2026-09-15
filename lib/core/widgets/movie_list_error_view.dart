import 'package:flutter/material.dart';

import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/widgets/app_button.dart';

import 'package:movies_app/core/widgets/empty_state.dart';

class MovieListErrorView extends StatelessWidget {
  const MovieListErrorView({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        EmptyState(
          message: context.l10n.somethingWentWrong,
          icon: Icons.wifi_off_rounded,
        ),
        SizedBox(height: AppSpacing.lg),
        Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.xl),
          child: AppButton(label: context.l10n.retry, onPressed: onRetry),
        ),
      ],
    );
  }
}
