import 'package:flutter/material.dart';

import 'package:movies_app/core/constants/app_assets.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/theme/app_theme.dart';
import 'package:movies_app/core/widgets/app_button.dart';
import 'package:movies_app/core/widgets/app_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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

  void _verifyEmail() {
    if (_formKey.currentState!.validate()) {
      // Add verification logic later.
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

                Image.asset(
                  AppAssets.forgotPassword,
                ),

                SizedBox(
                  height: AppSpacing.xl,
                ),

                Text(
                  'Reset Password',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                SizedBox(
                  height: AppSpacing.md,
                ),

                AppTextField(
                  hint: 'Email',
                  controller: _emailController,
                  validator: _validateEmail,
                ),

                SizedBox(
                  height: AppSpacing.lg,
                ),

                AppButton(
                  label: 'Verify Email',
                  onPressed: _verifyEmail,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}