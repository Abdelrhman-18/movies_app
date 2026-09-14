import 'package:flutter/widgets.dart';

import 'package:movies_app/core/localization/gen/app_localizations.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

abstract final class AppL10n {
  static const delegates = AppLocalizations.localizationsDelegates;
  static const supportedLocales = AppLocalizations.supportedLocales;
}
