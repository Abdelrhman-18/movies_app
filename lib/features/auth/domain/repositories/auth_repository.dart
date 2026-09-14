import 'package:movies_app/core/utils/app_result.dart';

abstract interface class AuthRepository {
  Future<AppResult<void>> resetPassword(String email);
}
