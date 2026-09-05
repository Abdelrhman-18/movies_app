import 'package:flutter/material.dart';

import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/utils/validators.dart';
import 'package:movies_app/core/widgets/app_button.dart';
import 'package:movies_app/core/widgets/app_text_field.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _controllers = List.generate(5, (_) => TextEditingController());

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    // TODO(phase-2): Dispatch registration with the selected avatar to auth Bloc.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.registrationUnavailable)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final labels = [context.l10n.name, context.l10n.email, context.l10n.password,
      context.l10n.confirmPassword, context.l10n.phoneNumber];
    const icons = [Icons.badge_outlined, Icons.email_rounded, Icons.lock_rounded,
      Icons.lock_rounded, Icons.phone_rounded];
    return Form(
      key: _formKey,
      child: Column(
        children: [
          for (var index = 0; index < labels.length; index++) ...[
            AppTextField(
              hint: labels[index],
              controller: _controllers[index],
              prefixIcon: icons[index],
              isPassword: index == 2 || index == 3,
              keyboardType: switch (index) {
                1 => TextInputType.emailAddress,
                4 => TextInputType.phone,
                _ => TextInputType.text,
              },
              textInputAction: index == 4 ? TextInputAction.done : TextInputAction.next,
              onFieldSubmitted: index == 4 ? (_) => _submit() : null,
              validator: (value) => switch (index) {
                1 => Validators.email(context, value),
                2 => Validators.password(context, value),
                3 => Validators.confirmPassword(context, value, _controllers[2].text),
                4 => Validators.phone(context, value),
                _ => Validators.required(context, value),
              },
            ),
            SizedBox(height: AppSpacing.xl),
          ],
          AppButton(label: context.l10n.register, onPressed: _submit),
        ],
      ),
    );
  }
}
