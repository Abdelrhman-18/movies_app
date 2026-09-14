import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/routing/app_routes.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/utils/validators.dart';
import 'package:movies_app/core/widgets/app_button.dart';
import 'package:movies_app/core/widgets/app_text_field.dart';
import 'package:movies_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:movies_app/features/auth/presentation/cubit/auth_state.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final List<TextEditingController> _controllers =
  List.generate(
    5,
        (_) => TextEditingController(),
  );

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }

    super.dispose();
  }

  String? _validateField(
      int index,
      String? value,
      ) {
    switch (index) {
      case 1:
        return Validators.email(context, value);

      case 2:
        return Validators.password(context, value);

      case 3:
        return Validators.confirmPassword(
          context,
          value,
          _controllers[2].text,
        );

      case 4:
        return Validators.phone(context, value);

      default:
        return Validators.required(
          context,
          value,
        );
    }
  }

  TextInputType _keyboardType(int index) {
    switch (index) {
      case 1:
        return TextInputType.emailAddress;

      case 4:
        return TextInputType.phone;

      default:
        return TextInputType.text;
    }
  }

  void _submit() {
    FocusScope.of(context).unfocus();

    final authCubit = context.read<AuthCubit>();

    if (authCubit.state.status == AuthStatus.loading) {
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    authCubit.register(
      name: _controllers[0].text,
      email: _controllers[1].text,
      password: _controllers[2].text,
      phone: _controllers[4].text,
    );
  }

  Future<void> _showSuccessDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            context.l10n.registrationSuccess,
          ),
          content: Text(
            context.l10n.accountCreatedSuccessfully,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                context.l10n.ok,
              ),
            ),
          ],
        );
      },
    );

    if (!mounted) {
      return;
    }

    context.go(
      AppRoutes.loginPath,
    );
  }

  @override
  Widget build(BuildContext context) {
    final labels = [
      context.l10n.name,
      context.l10n.email,
      context.l10n.password,
      context.l10n.confirmPassword,
      context.l10n.phoneNumber,
    ];

    const icons = [
      Icons.badge_outlined,
      Icons.email_rounded,
      Icons.lock_rounded,
      Icons.lock_rounded,
      Icons.phone_rounded,
    ];

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.success) {
          _showSuccessDialog();
        }

        if (state.status == AuthStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage ??
                    context.l10n.registrationFailed,
              ),
            ),
          );
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final isLoading =
              state.status == AuthStatus.loading;

          return Form(
            key: _formKey,
            child: Column(
              children: [
                for (
                var index = 0;
                index < labels.length;
                index++
                ) ...[
                  AppTextField(
                    hint: labels[index],
                    controller: _controllers[index],
                    prefixIcon: icons[index],
                    isPassword:
                    index == 2 || index == 3,
                    keyboardType:
                    _keyboardType(index),
                    textInputAction: index == 4
                        ? TextInputAction.done
                        : TextInputAction.next,
                    onFieldSubmitted: index == 4
                        ? (_) => _submit()
                        : null,
                    validator: (value) {
                      return _validateField(
                        index,
                        value,
                      );
                    },
                  ),
                  SizedBox(
                    height: AppSpacing.xl,
                  ),
                ],
                AppButton(
                  label: isLoading
                      ? context.l10n.creatingAccount
                      : context.l10n.register,
                  onPressed: isLoading
                      ? () {}
                      : _submit,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}