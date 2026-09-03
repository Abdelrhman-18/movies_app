import 'package:flutter/widgets.dart';

import 'package:movies_app/core/localization/gen/app_localizations.dart';

/// The single import boundary for generated localization.
///
/// This is the ONLY file in the app allowed to import
/// `core/localization/gen/app_localizations.dart`. Every screen reads strings
/// through `context.l10n`, so if `flutter gen-l10n` ever changes where it
/// writes its output, exactly one import here needs fixing.
extension L10nContext on BuildContext {
  /// All user-facing strings: `context.l10n.login`, `context.l10n.email`, ...
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// Wiring for `MaterialApp.router`. Nothing else should need these.
abstract final class AppL10n {
  static const delegates = AppLocalizations.localizationsDelegates;
  static const supportedLocales = AppLocalizations.supportedLocales;
}
