import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movies_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:movies_app/services/auth_service.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authService) : super(const AuthState());

  final AuthService _authService;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(
      const AuthState(
        status: AuthStatus.loading,
      ),
    );

    try {
      await _authService.login(
        email: email,
        password: password,
      );

      emit(
        const AuthState(
          status: AuthStatus.success,
        ),
      );
    } on FirebaseAuthException catch (e) {
      emit(
        AuthState(
          status: AuthStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        AuthState(
          status: AuthStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    emit(
      const AuthState(
        status: AuthStatus.loading,
      ),
    );

    try {
      await _authService.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );

      emit(
        const AuthState(
          status: AuthStatus.success,
        ),
      );
    } on FirebaseAuthException catch (e) {
      emit(
        AuthState(
          status: AuthStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        AuthState(
          status: AuthStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}