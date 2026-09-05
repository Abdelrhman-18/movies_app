import 'package:flutter/widgets.dart';

import 'package:movies_app/core/localization/l10n.dart';

abstract final class Validators {
  static const int minPasswordLength = 6;

  static String? required(BuildContext context, String? value) =>
      value == null || value.trim().isEmpty ? context.l10n.fieldRequired : null;

  static String? email(BuildContext context, String? value) {
    final error = required(context, value);
    if (error != null) return error;
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value!.trim())
        ? null : context.l10n.emailInvalid;
  }

  static String? password(BuildContext context, String? value) {
    final error = required(context, value);
    if (error != null) return error;
    return value!.length < minPasswordLength ? context.l10n.passwordTooShort : null;
  }

  static String? confirmPassword(BuildContext context, String? value, String password) {
    final error = required(context, value);
    if (error != null) return error;
    return value == password ? null : context.l10n.passwordMismatch;
  }

  static String? phone(BuildContext context, String? value) {
    final error = required(context, value);
    if (error != null) return error;
    final normalized = value!.replaceAll(RegExp(r'[\s()\-]'), '');
    return RegExp(r'^\+?[0-9]{7,15}$').hasMatch(normalized)
        ? null : context.l10n.phoneInvalid;
  }
}
