import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:movies_app/core/routing/app_routes.dart';
import 'package:movies_app/core/theme/app_spacing.dart';

import 'package:movies_app/features/auth/presentation/widgets/login_content.dart';

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

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO(phase-2): authenticate with Firebase.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.screenPadding,
          ),
          child: LoginContent(
            formKey: _formKey,
            emailController: _emailController,
            passwordController: _passwordController,
            onLogin: _login,
            onForgotPassword: () =>
                context.pushNamed(AppRoutes.forgotPasswordName),
            onCreateAccount: () => context.pushNamed(AppRoutes.registerName),
            onGoogleLogin: () {
              // TODO(phase-2): authenticate with Google.
            },
          ),
        ),
      ),
    );
  }
}
