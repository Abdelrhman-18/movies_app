import 'package:flutter/material.dart';

import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/widgets/app_text_field.dart';

class ProfileInfoFields extends StatefulWidget {
  const ProfileInfoFields({super.key});

  @override
  State<ProfileInfoFields> createState() => _ProfileInfoFieldsState();
}

class _ProfileInfoFieldsState extends State<ProfileInfoFields> {
  // TODO(phase-2): Seed these from the signed-in user's profile instead of mock data.
  final _nameController = TextEditingController(text: 'John Safwat');
  final _phoneController = TextEditingController(text: '01200000000');

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          hint: context.l10n.name,
          controller: _nameController,
          prefixIcon: Icons.person_outline,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: AppSpacing.md),
        AppTextField(
          hint: context.l10n.phoneNumber,
          controller: _phoneController,
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }
}
