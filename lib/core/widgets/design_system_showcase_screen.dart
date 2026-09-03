import 'package:flutter/material.dart';

import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_radius.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/theme/app_theme.dart';
import 'package:movies_app/core/widgets/app_app_bar.dart';
import 'package:movies_app/core/widgets/app_button.dart';
import 'package:movies_app/core/widgets/app_text_field.dart';

/// A dev-only gallery of the shared design-system tokens and widgets.
/// Wired as the app's initial route while Phase 1 is UI-only, so every
/// member can eyeball `core/` on a device without building a feature first.
class DesignSystemShowcaseScreen extends StatefulWidget {
  const DesignSystemShowcaseScreen({super.key});

  @override
  State<DesignSystemShowcaseScreen> createState() =>
      _DesignSystemShowcaseScreenState();
}

class _DesignSystemShowcaseScreenState
    extends State<DesignSystemShowcaseScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: _Copy.title),
      body: ListView(
        padding: EdgeInsetsDirectional.all(AppSpacing.screenPadding),
        children: [
          const _Section(title: _Copy.colors, child: _ColorsGallery()),
          _gap,
          const _Section(title: _Copy.typography, child: _TypographyGallery()),
          _gap,
          const _Section(title: _Copy.buttons, child: _ButtonsGallery()),
          _gap,
          _Section(
            title: _Copy.textFields,
            child: _FieldsGallery(
              searchController: _searchController,
              emailController: _emailController,
              passwordController: _passwordController,
            ),
          ),
        ],
      ),
    );
  }

  Widget get _gap => SizedBox(height: AppSpacing.xl);
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.titleLarge,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: AppSpacing.md),
        child,
      ],
    );
  }
}

class _ColorsGallery extends StatelessWidget {
  const _ColorsGallery();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.md,
      children: [
        for (final (name, color) in _Data.swatches)
          _Swatch(name: name, color: color),
      ],
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({required this.name, required this.color});

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.castImage,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: AppSizes.castImage,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: color,
                borderRadius: AppRadius.small,
                border: Border.all(
                  color: AppColors.textSecondary,
                  width: AppSizes.categoryBorderWidth,
                ),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            name,
            style: context.textTheme.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _TypographyGallery extends StatelessWidget {
  const _TypographyGallery();

  @override
  Widget build(BuildContext context) {
    final t = context.textTheme;
    final samples = <(String, TextStyle?)>[
      ('displayLarge', t.displayLarge),
      ('displayMedium', t.displayMedium),
      ('headlineSmall', t.headlineSmall),
      ('titleLarge', t.titleLarge),
      ('titleMedium', t.titleMedium),
      ('titleSmall', t.titleSmall),
      ('labelLarge', t.labelLarge),
      ('bodyLarge', t.bodyLarge),
      ('bodyMedium', t.bodyMedium),
      ('bodySmall', t.bodySmall),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (name, style) in samples)
          Padding(
            padding: EdgeInsetsDirectional.only(bottom: AppSpacing.sm),
            child: Text(
              name,
              style: style,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }
}

class _ButtonsGallery extends StatelessWidget {
  const _ButtonsGallery();

  static void _noop() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppButton(label: _Copy.primary, onPressed: _noop),
        SizedBox(height: AppSpacing.md),
        AppButton(label: _Copy.loading, onPressed: _noop, isLoading: true),
        SizedBox(height: AppSpacing.md),
        AppButton(label: _Copy.disabled, onPressed: _noop, isEnabled: false),
        SizedBox(height: AppSpacing.md),
        AppButton(
          label: _Copy.danger,
          onPressed: _noop,
          variant: AppButtonVariant.danger,
        ),
      ],
    );
  }
}

class _FieldsGallery extends StatelessWidget {
  const _FieldsGallery({
    required this.searchController,
    required this.emailController,
    required this.passwordController,
  });

  final TextEditingController searchController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          hint: _Copy.searchHint,
          controller: searchController,
          prefixIcon: Icons.search,
        ),
        SizedBox(height: AppSpacing.md),
        AppTextField(
          hint: _Copy.emailHint,
          controller: emailController,
          prefixIcon: Icons.mail_outline,
        ),
        SizedBox(height: AppSpacing.md),
        AppTextField(
          hint: _Copy.passwordHint,
          controller: passwordController,
          prefixIcon: Icons.lock_outline,
          isPassword: true,
        ),
      ],
    );
  }
}

/// Showcase-only copy. Real screens pull strings from localization; this
/// dev gallery never ships, so plain constants are fine here.
abstract final class _Copy {
  static const String title = 'Design System';
  static const String colors = 'Colors';
  static const String typography = 'Typography';
  static const String buttons = 'Buttons';
  static const String textFields = 'Text Fields';

  static const String primary = 'Primary';
  static const String loading = 'Loading';
  static const String disabled = 'Disabled';
  static const String danger = 'Delete Account';

  static const String searchHint = 'Search movies';
  static const String emailHint = 'Email';
  static const String passwordHint = 'Password';
}

abstract final class _Data {
  static const List<(String, Color)> swatches = [
    ('primary', AppColors.primary),
    ('primaryText', AppColors.primaryText),
    ('background', AppColors.background),
    ('surface', AppColors.surface),
    ('textPrimary', AppColors.textPrimary),
    ('textSecondary', AppColors.textSecondary),
    ('error', AppColors.error),
    ('success', AppColors.success),
    ('posterOverlay', AppColors.posterOverlay),
  ];
}
