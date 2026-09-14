import 'package:firebase_auth/firebase_auth.dart';

import 'package:movies_app/core/services/firebase/firebase_execute.dart';
import 'package:movies_app/core/utils/app_result.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<AppResult<void>> resetPassword(String email) {
    return FirebaseExecute.call(() {
      return _auth.sendPasswordResetEmail(email: email.trim());
    });
  }
}
