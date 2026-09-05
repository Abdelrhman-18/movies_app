import 'package:flutter/material.dart';

import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_radius.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/theme/app_theme.dart';
import 'package:movies_app/core/widgets/app_app_bar.dart';
import 'package:movies_app/core/widgets/app_button.dart';
import 'package:movies_app/core/widgets/app_text_field.dart';
import 'package:movies_app/core/widgets/language_switch.dart';

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
      appBar: AppAppBar(title: context.l10n.designSystem),
      body: ListView(
        padding: EdgeInsetsDirectional.all(AppSpacing.screenPadding),
        children: [
          _Section(
            title: context.l10n.language,
            child: const _LanguageGallery(),
          ),
          _gap,
          _Section(title: context.l10n.colors, child: const _ColorsGallery()),
          _gap,
          _Section(
            title: context.l10n.typography,
            child: const _TypographyGallery(),
          ),
          _gap,
          _Section(title: context.l10n.buttons, child: const _ButtonsGallery()),
          _gap,
          _Section(
            title: context.l10n.textFields,
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
        AppButton(label: context.l10n.login, onPressed: _noop),
        SizedBox(height: AppSpacing.md),
        AppButton(
          label: context.l10n.loading,
          onPressed: _noop,
          isLoading: true,
        ),
        SizedBox(height: AppSpacing.md),
        AppButton(
          label: context.l10n.disabled,
          onPressed: _noop,
          isEnabled: false,
        ),
        SizedBox(height: AppSpacing.md),
        AppButton(
          label: context.l10n.deleteAccount,
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
          hint: context.l10n.searchMovies,
          controller: searchController,
          prefixIcon: Icons.search,
        ),
        SizedBox(height: AppSpacing.md),
        AppTextField(
          hint: context.l10n.email,
          controller: emailController,
          prefixIcon: Icons.mail_outline,
        ),
        SizedBox(height: AppSpacing.md),
        AppTextField(
          hint: context.l10n.password,
          controller: passwordController,
          prefixIcon: Icons.lock_outline,
          isPassword: true,
        ),
      ],
    );
  }
}

/// Flips the app locale live so the team can eyeball every widget in RTL
/// without restarting. Real screens read the locale the same way.
class _LanguageGallery extends StatelessWidget {
  const _LanguageGallery();

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: AlignmentDirectional.centerStart,
      child: LanguageSwitch(),
    );
  }
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
