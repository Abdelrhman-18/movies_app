import 'package:movies_app/core/utils/app_result.dart';

abstract interface class AuthRepository {
  Future<AppResult<void>> login({
    required String email,
    required String password,
  });

  Future<AppResult<void>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  });

  Future<AppResult<void>> resetPassword(String email);

  Future<AppResult<void>> signInWithGoogle();

  Future<AppResult<void>> signOut();
}
