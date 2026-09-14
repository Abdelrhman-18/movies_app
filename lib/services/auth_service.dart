import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static const String _usersCollection = 'users';

  Future<UserCredential> login({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    final credential =
    await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = credential.user;

    if (user != null) {
      await user.updateDisplayName(
        name.trim(),
      );

      await _firestore
          .collection(_usersCollection)
          .doc(user.uid)
          .set({
        'name': name.trim(),
        'email': email.trim(),
        'phone': phone.trim(),
        'createdAt':
        FieldValue.serverTimestamp(),
      });
    }

    return credential;
  }

  Future<void> resetPassword(
      String email,
      ) {
    return _auth.sendPasswordResetEmail(
      email: email.trim(),
    );
  }
}