import 'package:flutter/widgets.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

/// Holds the app locale. Simple UI state with no events, so a Cubit — see the
/// state-management rules in `CLAUDE.md`.
///
/// The choice is in-memory only for now.
/// TODO(phase-2): persist the last locale (shared_preferences) and restore it
/// on startup, alongside the auth session.
class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(english);

  static const Locale english = Locale('en');
  static const Locale arabic = Locale('ar');

  bool get isArabic => state.languageCode == arabic.languageCode;

  void setArabic({required bool isArabic}) =>
      emit(isArabic ? arabic : english);

  void toggle() => emit(isArabic ? english : arabic);
}
