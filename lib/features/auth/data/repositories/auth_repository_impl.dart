import 'package:movies_app/core/utils/app_result.dart';
import 'package:movies_app/features/auth/data/datasources/auth_service.dart';
import 'package:movies_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._authService);

  final AuthService _authService;

  @override
  Future<AppResult<void>> login({
    required String email,
    required String password,
  }) {
    return _authService.login(email: email, password: password);
  }

  @override
  Future<AppResult<void>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    return _authService.register(
      name: name,
      email: email,
      password: password,
      phone: phone,
    );
  }

  @override
  Future<AppResult<void>> resetPassword(String email) {
    return _authService.resetPassword(email);
  }

  @override
  Future<AppResult<void>> signInWithGoogle() {
    return _authService.signInWithGoogle();
  }
}
