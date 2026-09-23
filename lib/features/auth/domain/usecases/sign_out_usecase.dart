import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/auth/domain/repositories/auth_repository.dart';

class SignOutUseCase {
  const SignOutUseCase(this._repository);

  final AuthRepository _repository;

  Future<AppResult<void>> call() {
    return _repository.signOut();
  }
}
