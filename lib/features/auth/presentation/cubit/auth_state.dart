import 'package:equatable/equatable.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

enum AuthOperation { emailSignIn, emailRegistration, googleSignIn, signOut }

final class AuthLoading extends AuthState {
  const AuthLoading(this.operation);

  final AuthOperation operation;

  @override
  List<Object?> get props => [operation];
}

final class AuthSuccess extends AuthState {
  const AuthSuccess();
}

final class AuthFailure extends AuthState {
  const AuthFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
