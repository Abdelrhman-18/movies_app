import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:movies_app/core/di/service_locator.dart';
import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/routing/app_routes.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/widgets/app_app_bar.dart';
import 'package:movies_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:movies_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:movies_app/features/auth/presentation/widgets/login_content.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
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
    FocusScope.of(context).unfocus();

    final authCubit = context.read<AuthCubit>();

    if (authCubit.state is AuthLoading) {
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    authCubit.login(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  void _goToForgotPassword() {
    context.push(AppRoutes.forgotPasswordPath);
  }

  void _goToRegister() {
    context.push(AppRoutes.registerPath);
  }

  void _loginWithGoogle() {
    final authCubit = context.read<AuthCubit>();

    if (authCubit.state is AuthLoading) {
      return;
    }

    authCubit.signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: context.l10n.login,
        onBack: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(AppRoutes.onboardingPath);
          }
        },
      ),
      body: SafeArea(
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            switch (state) {
              case AuthSuccess():
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.success,
                    content: Text(context.l10n.login),
                  ),
                );

              // TODO(phase-2): change this to the Home route when Home is ready.
              case AuthFailure(message: final message):
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.error,
                    content: Text(message),
                  ),
                );
              case AuthInitial():
              case AuthLoading():
                break;
            }
          },
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsetsDirectional.all(AppSpacing.screenPadding),
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                final loadingOperation = state is AuthLoading
                    ? state.operation
                    : null;

                return LoginContent(
                  formKey: _formKey,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  isEmailLoading: loadingOperation == AuthOperation.emailSignIn,
                  isGoogleLoading:
                      loadingOperation == AuthOperation.googleSignIn,
                  onLogin: _login,
                  onForgotPassword: _goToForgotPassword,
                  onCreateAccount: _goToRegister,
                  onGoogleLogin: _loginWithGoogle,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
