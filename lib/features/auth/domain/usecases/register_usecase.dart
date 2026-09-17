import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  const RegisterUseCase(this._repository);

  final AuthRepository _repository;

  Future<AppResult<void>> call({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    return _repository.register(
      name: name,
      email: email,
      password: password,
      phone: phone,
    );
  }
}
