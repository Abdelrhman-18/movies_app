import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:movies_app/core/error/app_error_model.dart';
import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:movies_app/features/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:movies_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:movies_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:movies_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:movies_app/features/auth/presentation/cubit/auth_state.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;
  late AuthCubit cubit;

  setUp(() {
    repository = _MockAuthRepository();
    cubit = AuthCubit(
      LoginUseCase(repository),
      RegisterUseCase(repository),
      GoogleSignInUseCase(repository),
    );
  });

  tearDown(() => cubit.close());

  group('AuthCubit.login', () {
    test('emits AuthLoading then AuthSuccess on success', () async {
      when(
        () => repository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Success(null));

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          const AuthLoading(AuthOperation.emailSignIn),
          const AuthSuccess(),
        ]),
      );

      await cubit.login(email: 'a@b.com', password: 'secret1');
      await expectation;
    });

    test('emits AuthFailure with the error message on failure', () async {
      when(
        () => repository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) async => const Failure(
          AppErrorModel(code: 'wrong-password', message: 'Wrong password'),
        ),
      );

      await cubit.login(email: 'a@b.com', password: 'bad');

      expect(cubit.state, const AuthFailure('Wrong password'));
    });

    test('falls back to the error code when message is null', () async {
      when(
        () => repository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) async => const Failure(AppErrorModel(code: 'wrong-password')),
      );

      await cubit.login(email: 'a@b.com', password: 'bad');

      expect(cubit.state, const AuthFailure('wrong-password'));
    });
  });

  group('AuthCubit.register', () {
    test('emits AuthLoading then AuthSuccess on success', () async {
      when(
        () => repository.register(
          name: any(named: 'name'),
          email: any(named: 'email'),
          password: any(named: 'password'),
          phone: any(named: 'phone'),
        ),
      ).thenAnswer((_) async => const Success(null));

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          const AuthLoading(AuthOperation.emailRegistration),
          const AuthSuccess(),
        ]),
      );

      await cubit.register(
        name: 'Jane',
        email: 'jane@b.com',
        password: 'secret1',
        phone: '0100000000',
      );
      await expectation;
    });
  });

  group('AuthCubit.signInWithGoogle', () {
    test('emits AuthSuccess on success', () async {
      when(
        () => repository.signInWithGoogle(),
      ).thenAnswer((_) async => const Success(null));

      await cubit.signInWithGoogle();

      expect(cubit.state, const AuthSuccess());
    });

    test(
      'a cancelled Google sign-in resets to AuthInitial, not AuthFailure',
      () async {
        when(() => repository.signInWithGoogle()).thenAnswer(
          (_) async => const Failure(AppErrorModel(code: 'cancelled')),
        );

        await cubit.signInWithGoogle();

        expect(cubit.state, const AuthInitial());
      },
    );

    test('a real failure emits AuthFailure', () async {
      when(() => repository.signInWithGoogle()).thenAnswer(
        (_) async => const Failure(
          AppErrorModel(
            code: 'google-sign-in-failed',
            message: 'Could not sign in',
          ),
        ),
      );

      await cubit.signInWithGoogle();

      expect(cubit.state, const AuthFailure('Could not sign in'));
    });
  });
}
