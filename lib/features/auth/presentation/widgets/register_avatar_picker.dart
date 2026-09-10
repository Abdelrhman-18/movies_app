import 'package:flutter/material.dart';

import 'package:movies_app/core/localization/l10n.dart';

import 'package:movies_app/core/constants/app_assets.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/theme/app_text_styles.dart';



class RegisterAvatarPicker extends StatefulWidget {
  const RegisterAvatarPicker({super.key});

  @override
  State<RegisterAvatarPicker> createState() => _RegisterAvatarPickerState();
}

class _RegisterAvatarPickerState extends State<RegisterAvatarPicker> {
  late final PageController _controller;
  int _selected = 7;
  static const _avatarOrder = [0, 1, 2, 3, 4, 6, 7, 5, 8];

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: _selected, viewportFraction: 0.4);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final label = context.l10n.avatar;
    return Column(
      children: [
        SizedBox(
          height: AppSizes.avatar * 1.4,
          child: PageView.builder(
            controller: _controller,
            itemCount: AppAssets.avatars.length,
            onPageChanged: (index) => setState(() => _selected = index),
            itemBuilder: (context, index) => Semantics(
              label: '$label ${index + 1}',
              button: true,
              selected: index == _selected,
              child: GestureDetector(
                onTap: () => _controller.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                ),
                child: Center(
                  child: AnimatedScale(
                    scale: index == _selected ? 1 : 0.6,
                    duration: const Duration(milliseconds: 250),
                    child: Image.asset(
                      AppAssets.avatars[_avatarOrder[index]],
                      width: AppSizes.avatar * 1.4,
                      height: AppSizes.avatar * 1.4,
                      fit: BoxFit.contain,
                      excludeFromSemantics: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        Text(label, style: AppTextStyles.bodyMedium),
      ],
    );
  }
}
