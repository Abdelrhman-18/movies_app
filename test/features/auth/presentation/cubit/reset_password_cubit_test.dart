import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:movies_app/core/error/app_error_model.dart';
import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:movies_app/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:movies_app/features/auth/presentation/cubit/reset_password/reset_password_cubit.dart';
import 'package:movies_app/features/auth/presentation/cubit/reset_password/reset_password_state.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;
  late ResetPasswordCubit cubit;

  setUp(() {
    repository = _MockAuthRepository();
    cubit = ResetPasswordCubit(ResetPasswordUseCase(repository));
  });

  tearDown(() => cubit.close());

  test('initial state is ResetPasswordInitial', () {
    expect(cubit.state, const ResetPasswordInitial());
  });

  test('resetPassword emits Loading then Success', () async {
    when(
      () => repository.resetPassword(any()),
    ).thenAnswer((_) async => const Success(null));

    final expectation = expectLater(
      cubit.stream,
      emitsInOrder([
        const ResetPasswordLoading(),
        const ResetPasswordSuccess(),
      ]),
    );

    await cubit.resetPassword('a@b.com');
    await expectation;
  });

  test(
    'resetPassword emits ResetPasswordError with the error message on failure',
    () async {
      when(() => repository.resetPassword(any())).thenAnswer(
        (_) async => const Failure(
          AppErrorModel(code: 'user-not-found', message: 'No such user'),
        ),
      );

      await cubit.resetPassword('missing@b.com');

      expect(cubit.state, const ResetPasswordError('No such user'));
    },
  );
}
