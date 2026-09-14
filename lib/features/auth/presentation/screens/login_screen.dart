import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/routing/app_routes.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/utils/validators.dart';
import 'package:movies_app/core/widgets/app_app_bar.dart';
import 'package:movies_app/core/widgets/app_button.dart';
import 'package:movies_app/core/widgets/app_text_field.dart';
import 'package:movies_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:movies_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:movies_app/services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(AuthService()),
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

    if (authCubit.state.status == AuthStatus.loading) {
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
            if (state.status == AuthStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.l10n.login),
                ),
              );

              // TODO: Change this to Home route when Home is ready.
            }

            if (state.status == AuthStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.errorMessage ??
                        context.l10n.somethingWentWrong,
                  ),
                ),
              );
            }
          },
          child: SingleChildScrollView(
            keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior.onDrag,
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

                  AppTextField(
                    hint: context.l10n.email,
                    controller: _emailController,
                    prefixIcon: Icons.email_rounded,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      return Validators.email(
                        context,
                        value,
                      );
                    },
                  ),

                  SizedBox(
                    height: AppSpacing.xl,
                  ),

                  AppTextField(
                    hint: context.l10n.password,
                    controller: _passwordController,
                    prefixIcon: Icons.lock_rounded,
                    isPassword: true,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _login(),
                    validator: (value) {
                      return Validators.password(
                        context,
                        value,
                      );
                    },
                  ),

                  SizedBox(
                    height: AppSpacing.sm,
                  ),

                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton(
                      onPressed: () {
                        context.push(
                          AppRoutes.forgotPasswordPath,
                        );
                      },
                      child: Text(
                        context.l10n.forgetPassword,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: AppSpacing.lg,
                  ),

                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      final isLoading =
                          state.status == AuthStatus.loading;

                      return AppButton(
                        label: isLoading
                            ? context.l10n.loading
                            : context.l10n.login,
                        onPressed: isLoading
                            ? () {}
                            : _login,
                      );
                    },
                  ),

                  SizedBox(
                    height: AppSpacing.lg,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        context.l10n.dontHaveAccount,
                      ),
                      TextButton(
                        onPressed: () {
                          context.push(
                            AppRoutes.registerPath,
                          );
                        },
                        child: Text(
                          context.l10n.createOne,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}