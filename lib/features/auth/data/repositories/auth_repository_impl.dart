import 'package:movies_app/core/utils/app_result.dart';
import 'package:movies_app/features/auth/data/datasources/auth_service.dart';
import 'package:movies_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._authService);

  final AuthService _authService;

  @override
  Future<AppResult<void>> resetPassword(String email) {
    return _authService.resetPassword(email);
  }
}
