# Register UI integration

The registration screen is available at `/register` and opens on app launch on
this feature branch. It uses the existing core theme and shared form widgets.
No files under `lib/core/` were edited, following `CLAUDE.md` ownership rules.

Team Lead integration tasks:

- Move the register route from the application composition in `main.dart` into
  `AppRouter`, and its identifiers into `AppRoutes`.
- Merge the feature ARB entries into the shared ARB files, then replace the
  temporary feature localization delegate and remove its asset registration.
- Connect the Login footer to the login route after `feature/login-safaa` merges.
- Add shared flag asset constants and update the shared language switch. The
  feature currently uses Unicode flags, whose appearance depends on the platform.
- Consider adding keyboard type, autofill hints and text input action parameters
  to `AppTextField` for email and phone input.

Phase 1 behavior: avatar selection, independent password visibility, English/Arabic
switching, required fields, email, password length, confirmation and phone
validation. A valid submission displays a localized availability notice; it does
not create an account. Phase 2 must connect the form and selected avatar to the
authentication Bloc.

Verification: `flutter analyze` and `flutter test`. Tests cover compact English/RTL
layout, validation, visibility toggles and avatar selection.
