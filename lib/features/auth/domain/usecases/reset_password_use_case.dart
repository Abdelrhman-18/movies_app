import 'package:movies_app/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository _authRepository;

  ResetPasswordUseCase(this._authRepository);

  Future<void> call(String email) {
    return _authRepository.resetPassword(email);
  }
}