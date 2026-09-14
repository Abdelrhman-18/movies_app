import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:movies_app/core/error/app_error_model.dart';
import 'package:movies_app/core/utils/app_result.dart';

abstract final class FirebaseExecute {
  static Future<AppResult<T>> call<T>(Future<T> Function() action) async {
    try {
      return Success<T>(await action());
    } on FirebaseAuthException catch (e) {
      return Failure<T>(AppErrorModel.fromFirebaseAuthException(e));
    } on GoogleSignInException catch (e) {
      return Failure<T>(AppErrorModel.fromGoogleSignInException(e));
    } on FirebaseException catch (e) {
      return Failure<T>(AppErrorModel.fromFirebaseException(e));
    } catch (e) {
      return Failure<T>(AppErrorModel.unexpected(e.toString()));
    }
  }
}
