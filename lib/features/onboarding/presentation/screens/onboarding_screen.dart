import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:movies_app/core/constants/app_assets.dart';
import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/theme/app_text_styles.dart';
import 'package:movies_app/core/widgets/app_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({required this.onFinished, super.key});

  final VoidCallback onFinished;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _shadowColors = [
    Color(0xFF121312),
    Color(0xFF084250),
    Color(0xFF85210D),
    Color(0xFF4C1B63),
    Color(0xFF561625),
    Color(0xFF525A5D),
  ];

  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage == AppAssets.onboardingCollages.length - 1) {
      widget.onFinished();
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = _localizedPages(context);
    final page = pages[_currentPage];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: pages.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (_, index) {
                final image = Image.asset(
                  pages[index].image,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                );

                if (index == 0) return image;

                return Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: double.infinity,
                    height: 710.h,
                    child: DecoratedBox(
                      position: DecorationPosition.foreground,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            _shadowColors[index].withValues(alpha: 0),
                            _shadowColors[index],
                          ],
                        ),
                      ),
                      child: image,
                    ),
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  width: double.infinity,
                  padding: EdgeInsetsDirectional.fromSTEB(
                    _currentPage == 0
                        ? AppSpacing.screenPadding
                        : AppSpacing.xl,
                    AppSpacing.xl,
                    _currentPage == 0
                        ? AppSpacing.screenPadding
                        : AppSpacing.xl,
                    AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: _currentPage == 0
                        ? Colors.transparent
                        : AppColors.background,
                    borderRadius: _currentPage == 0
                        ? BorderRadius.zero
                        : BorderRadius.vertical(top: Radius.circular(32.r)),
                  ),
                  child: SafeArea(
                    top: false,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: _OnboardingContent(
                        key: ValueKey(_currentPage),
                        page: page,
                        primaryLabel: _primaryLabel(context),
                        isWelcomePage: _currentPage == 0,
                        showBack: _currentPage >= 2,
                        onPrimaryPressed: _nextPage,
                        onBackPressed: _previousPage,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _primaryLabel(BuildContext context) {
    if (_currentPage == 0) return context.l10n.exploreNow;
    if (_currentPage == AppAssets.onboardingCollages.length - 1) {
      return context.l10n.finish;
    }
    return context.l10n.next;
  }

  List<_OnboardingPageData> _localizedPages(BuildContext context) => [
    _OnboardingPageData(
      image: AppAssets.onboardingCollages[0],
      title: context.l10n.onboardingWelcomeTitle,
      description: context.l10n.onboardingWelcomeDescription,
    ),
    _OnboardingPageData(
      image: AppAssets.onboardingCollages[1],
      title: context.l10n.onboardingDiscoverTitle,
      description: context.l10n.onboardingDiscoverDescription,
    ),
    _OnboardingPageData(
      image: AppAssets.onboardingCollages[2],
      title: context.l10n.onboardingGenresTitle,
      description: context.l10n.onboardingGenresDescription,
    ),
    _OnboardingPageData(
      image: AppAssets.onboardingCollages[3],
      title: context.l10n.onboardingWatchlistsTitle,
      description: context.l10n.onboardingWatchlistsDescription,
    ),
    _OnboardingPageData(
      image: AppAssets.onboardingCollages[4],
      title: context.l10n.onboardingReviewsTitle,
      description: context.l10n.onboardingReviewsDescription,
    ),
    _OnboardingPageData(
      image: AppAssets.onboardingCollages[5],
      title: context.l10n.onboardingStartTitle,
    ),
  ];
}

class _OnboardingContent extends StatelessWidget {
  const _OnboardingContent({
    required this.page,
    required this.primaryLabel,
    required this.isWelcomePage,
    required this.showBack,
    required this.onPrimaryPressed,
    required this.onBackPressed,
    super.key,
  });

  final _OnboardingPageData page;
  final String primaryLabel;
  final bool isWelcomePage;
  final bool showBack;
  final VoidCallback onPrimaryPressed;
  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          page.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: isWelcomePage
              ? AppTextStyles.onboardingWelcomeTitle
              : AppTextStyles.onboardingTitle,
        ),
        if (page.description case final description?) ...[
          SizedBox(height: AppSpacing.sm),
          Text(
            description,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.onboardingBody,
          ),
        ],
        SizedBox(height: AppSpacing.lg),
        AppButton(label: primaryLabel, onPressed: onPrimaryPressed),
        if (showBack) ...[
          SizedBox(height: AppSpacing.sm),
          AppButton(
            label: context.l10n.back,
            onPressed: onBackPressed,
            variant: AppButtonVariant.outlined,
          ),
        ],
      ],
    );
  }
}

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.image,
    required this.title,
    this.description,
  });

  final String image;
  final String title;
  final String? description;
}
