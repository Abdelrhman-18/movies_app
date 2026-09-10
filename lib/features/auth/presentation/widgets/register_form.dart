import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/routing/app_routes.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/utils/validators.dart';
import 'package:movies_app/core/widgets/app_button.dart';
import 'package:movies_app/core/widgets/app_text_field.dart';
import 'package:movies_app/services/auth_service.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final _controllers = List.generate(
    5,
        (_) => TextEditingController(),
  );

  final _authService = AuthService();

  bool _isLoading = false;

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  String? _validateField(int index, String? value) {
    if (index == 1) {
      return Validators.email(context, value);
    }

    if (index == 2) {
      return Validators.password(context, value);
    }

    if (index == 3) {
      return Validators.confirmPassword(
        context,
        value,
        _controllers[2].text,
      );
    }

    if (index == 4) {
      return Validators.phone(context, value);
    }

    return Validators.required(context, value);
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.register(
        name: _controllers[0].text,
        email: _controllers[1].text,
        password: _controllers[2].text,
        phone: _controllers[4].text,
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      await showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Account created successfully'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      if (!mounted) return;

      context.go(AppRoutes.loginPath);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      String message = 'Registration failed';

      if (e.code == 'email-already-in-use') {
        message = 'This email is already registered';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email address';
      } else if (e.code == 'weak-password') {
        message = 'Password is too weak';
      } else if (e.code == 'network-request-failed') {
        message = 'Check your internet connection';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong: $e'),
        ),
      );
    }
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
              keyboardType: index == 1
                  ? TextInputType.emailAddress
                  : index == 4
                  ? TextInputType.phone
                  : TextInputType.text,
              textInputAction: index == 4
                  ? TextInputAction.done
                  : TextInputAction.next,
              onFieldSubmitted: index == 4
                  ? (_) {
                _submit();
              }
                  : null,
              validator: (value) {
                return _validateField(index, value);
              },
            ),
            SizedBox(height: AppSpacing.xl),
          ],
          AppButton(
            label: _isLoading
                ? 'Creating account...'
                : context.l10n.register,
            onPressed: () {
              if (!_isLoading) {
                _submit();
              }
            },
          ),
        ],
      ),
    );
  }
}