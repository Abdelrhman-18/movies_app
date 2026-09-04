import 'package:flutter/material.dart';

import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/widgets/app_button.dart';
import 'package:movies_app/core/widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    if (!value.contains('@')) {
      return 'Enter a valid email';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      // Login logic will be added later.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsetsDirectional.all(
            AppSpacing.screenPadding,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: AppSpacing.xl,
                ),

                Text(
                  'Login',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall,
                ),

                SizedBox(
                  height: AppSpacing.xl,
                ),

                AppTextField(
                  hint: 'Email',
                  controller: _emailController,
                  validator: _validateEmail,
                ),

                SizedBox(
                  height: AppSpacing.md,
                ),

                AppTextField(
                  hint: 'Password',
                  controller: _passwordController,
                  isPassword: true,
                  validator: _validatePassword,
                ),

                SizedBox(
                  height: AppSpacing.sm,
                ),

                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Forgot Password?',
                    ),
                  ),
                ),

                SizedBox(
                  height: AppSpacing.md,
                ),

                AppButton(
                  label: 'Login',
                  onPressed: _login,
                ),

                SizedBox(
                  height: AppSpacing.md,
                ),

                AppButton(
                  label: 'Login with Google',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}