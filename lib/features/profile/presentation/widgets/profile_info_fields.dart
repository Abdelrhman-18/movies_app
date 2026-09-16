import 'package:flutter/material.dart';

import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/widgets/app_text_field.dart';

class ProfileInfoFields extends StatelessWidget {
  const ProfileInfoFields({
    super.key,
    required this.nameController,
    required this.phoneController,
  });

  final TextEditingController nameController;
  final TextEditingController phoneController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          hint: context.l10n.name,
          controller: nameController,
          prefixIcon: Icons.person_outline,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: AppSpacing.md),
        AppTextField(
          hint: context.l10n.phoneNumber,
          controller: phoneController,
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }
}