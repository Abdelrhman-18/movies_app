import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:movies_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:movies_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:movies_app/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:movies_app/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(
    this._loginUseCase,
    this._registerUseCase,
    this._googleSignInUseCase,
    this._signOutUseCase,
  ) : super(const AuthInitial());

  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final GoogleSignInUseCase _googleSignInUseCase;
  final SignOutUseCase _signOutUseCase;

  Future<void> login({required String email, required String password}) async {
    emit(const AuthLoading(AuthOperation.emailSignIn));

    final result = await _loginUseCase(email: email, password: password);

    emit(_stateFor(result));
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    emit(const AuthLoading(AuthOperation.emailRegistration));

    final result = await _registerUseCase(
      name: name,
      email: email,
      password: password,
      phone: phone,
    );

    emit(_stateFor(result));
  }

  Future<void> signInWithGoogle() async {
    emit(const AuthLoading(AuthOperation.googleSignIn));

    final result = await _googleSignInUseCase();

    emit(switch (result) {
      Success() => const AuthSuccess(),
      Failure(error: final error) when error.code == 'cancelled' =>
        const AuthInitial(),
      Failure(error: final error) => AuthFailure(error.message ?? error.code),
    });
  }

  Future<void> signOut() async {
    emit(const AuthLoading(AuthOperation.signOut));

    final result = await _signOutUseCase();

    emit(_stateFor(result));
  }

  AuthState _stateFor(AppResult<void> result) {
    return switch (result) {
      Success() => const AuthSuccess(),
      Failure(error: final error) => AuthFailure(error.message ?? error.code),
    };
  }
}
