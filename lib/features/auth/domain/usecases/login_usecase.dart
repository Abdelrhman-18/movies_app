import 'package:movies_app/core/utils/app_result.dart';
import 'package:movies_app/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<AppResult<void>> call({
    required String email,
    required String password,
  }) {
    return _repository.login(email: email, password: password);
  }
}
