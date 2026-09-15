import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:movies_app/core/services/firebase/firebase_execute.dart';
import 'package:movies_app/core/services/firebase/firestore_collections.dart';
import 'package:movies_app/core/services/firebase/firestore_service.dart';
import 'package:movies_app/core/utils/app_result.dart';
import 'package:movies_app/features/auth/data/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void>? _googleSignInInitialization;

  Future<void> _ensureGoogleSignInInitialized() {
    return _googleSignInInitialization ??= GoogleSignIn.instance.initialize();
  }

  Future<AppResult<void>> login({
    required String email,
    required String password,
  }) {
    return FirebaseExecute.call(() async {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    });
  }

  Future<AppResult<void>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    return FirebaseExecute.call(() async {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;

      if (user != null) {
        await user.updateDisplayName(name.trim());

        final userModel = UserModel(
          uid: user.uid,
          name: name.trim(),
          email: email.trim(),
          phone: phone.trim(),
        );

        await FirestoreService.instance.setData(
          path: '${FirestoreCollections.users}/${user.uid}',
          data: {
            ...userModel.toMap(),
            'createdAt': FieldValue.serverTimestamp(),
          },
        );
      }
    });
  }

  Future<AppResult<void>> signInWithGoogle() {
    return FirebaseExecute.call(() async {
      await _ensureGoogleSignInInitialized();

      final account = await GoogleSignIn.instance.authenticate();
      final credential = GoogleAuthProvider.credential(
        idToken: account.authentication.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        final userModel = UserModel(
          uid: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
          phone: user.phoneNumber ?? '',
        );

        await FirestoreService.instance.setData(
          path: '${FirestoreCollections.users}/${user.uid}',
          data: userModel.toMap(),
          merge: true,
        );
      }
    });
  }

  Future<AppResult<void>> resetPassword(String email) {
    return FirebaseExecute.call(() {
      return _auth.sendPasswordResetEmail(email: email.trim());
    });
  }
}
