import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordUseCase {
  const ResetPasswordUseCase(this._repository);

  final AuthRepository _repository;

  Future<AppResult<void>> call(String email) {
    return _repository.resetPassword(email);
  }
}
