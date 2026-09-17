import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/auth/domain/repositories/auth_repository.dart';

class GoogleSignInUseCase {
  const GoogleSignInUseCase(this._repository);

  final AuthRepository _repository;

  Future<AppResult<void>> call() {
    return _repository.signInWithGoogle();
  }
}
