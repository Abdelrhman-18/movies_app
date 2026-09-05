import 'package:flutter/widgets.dart';

import 'package:movies_app/core/localization/l10n.dart';

abstract final class Validators {
  static const int minPasswordLength = 6;

  static String? email(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.l10n.emailRequired;
    }

    if (!value.contains('@')) {
      return context.l10n.emailInvalid;
    }

    return null;
  }

  static String? password(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.l10n.passwordRequired;
    }

    if (value.length < minPasswordLength) {
      return context.l10n.passwordTooShort;
    }

    return null;
  }
}
