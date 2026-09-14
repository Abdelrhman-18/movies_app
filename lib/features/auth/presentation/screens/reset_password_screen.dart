import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/constants/app_assets.dart';
import 'package:movies_app/core/di/service_locator.dart';
import 'package:movies_app/core/localization/l10n.dart';
import 'package:movies_app/core/theme/app_spacing.dart';
import 'package:movies_app/core/utils/validators.dart';
import 'package:movies_app/core/widgets/app_app_bar.dart';
import 'package:movies_app/core/widgets/app_button.dart';
import 'package:movies_app/core/widgets/app_text_field.dart';
import 'package:movies_app/features/profile/presentation/cubit/reset_password/reset_password_cubit.dart';
import 'package:movies_app/features/profile/presentation/cubit/reset_password/reset_password_state.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _verifyEmail() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    context.read<ResetPasswordCubit>().resetPassword(
      _emailController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ResetPasswordCubit>(),
      child: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Password reset email sent successfully.'),
              ),
            );
          }
          if (state is ResetPasswordError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final isLoading = state is ResetPasswordLoading;
          return Scaffold(
            appBar: AppAppBar(title: context.l10n.resetPassword),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: AppSpacing.screenPadding,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: AppSpacing.xl),
                      SizedBox.square(
                        dimension: AppSizes.forgotPasswordIllustration,
                        child: Image.asset(
                          AppAssets.forgotPassword,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xl * 3 + AppSpacing.md),
                      AppTextField(
                        hint: context.l10n.email,
                        controller: _emailController,
                        prefixIcon: Icons.email_rounded,
                        validator: (value) => Validators.email(context, value),
                      ),
                      SizedBox(height: AppSpacing.xl),
                      AppButton(
                        label: context.l10n.verifyEmail,
                        onPressed: _verifyEmail,
                        isLoading: isLoading,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
