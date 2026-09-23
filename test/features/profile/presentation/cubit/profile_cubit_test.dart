import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:movies_app/core/error/app_error_model.dart';
import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/profile/domain/entities/user.dart';
import 'package:movies_app/features/profile/domain/repos/profile_repository.dart';
import 'package:movies_app/features/profile/presentation/cubit/profile/profile_cubit.dart';
import 'package:movies_app/features/profile/presentation/cubit/profile/profile_state.dart';

class _MockProfileRepository extends Mock implements ProfileRepository {}

const _user = User(id: 'u1', name: 'Jane', email: 'jane@b.com', phone: '0100');

void main() {
  late _MockProfileRepository repository;
  late ProfileCubit cubit;

  setUp(() {
    repository = _MockProfileRepository();
    cubit = ProfileCubit(repository);
  });

  tearDown(() => cubit.close());

  group('getCurrentUser', () {
    test('emits Loading then UserLoaded on success', () async {
      when(
        () => repository.getCurrentUser(),
      ).thenAnswer((_) async => const Success(_user));

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([const ProfileLoading(), const ProfileUserLoaded(_user)]),
      );

      await cubit.getCurrentUser();
      await expectation;
    });

    test('emits ProfileError on failure', () async {
      when(() => repository.getCurrentUser()).thenAnswer(
        (_) async =>
            const Failure(AppErrorModel(code: 'not-found', message: 'No user')),
      );

      await cubit.getCurrentUser();

      expect(cubit.state, const ProfileError('No user'));
    });
  });

  group('updateProfile', () {
    test('emits Loading then ProfileSuccess on success', () async {
      when(
        () => repository.updateProfile(
          name: any(named: 'name'),
          phone: any(named: 'phone'),
          avatarIndex: any(named: 'avatarIndex'),
          profileImage: any(named: 'profileImage'),
        ),
      ).thenAnswer((_) async => const Success(null));

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([const ProfileLoading(), const ProfileSuccess()]),
      );

      await cubit.updateProfile(name: 'Jane', phone: '0100', avatarIndex: 2);
      await expectation;
    });

    test('passes the picked gallery image through to the repository', () async {
      final image = File('avatar.png');
      when(
        () => repository.updateProfile(
          name: any(named: 'name'),
          phone: any(named: 'phone'),
          avatarIndex: any(named: 'avatarIndex'),
          profileImage: any(named: 'profileImage'),
        ),
      ).thenAnswer((_) async => const Success(null));

      await cubit.updateProfile(
        name: 'Jane',
        phone: '0100',
        profileImage: image,
      );

      verify(
        () => repository.updateProfile(
          name: 'Jane',
          phone: '0100',
          avatarIndex: null,
          profileImage: image,
        ),
      ).called(1);
    });

    test('emits ProfileError on failure', () async {
      when(
        () => repository.updateProfile(
          name: any(named: 'name'),
          phone: any(named: 'phone'),
          avatarIndex: any(named: 'avatarIndex'),
          profileImage: any(named: 'profileImage'),
        ),
      ).thenAnswer(
        (_) async => const Failure(
          AppErrorModel(code: 'network-error', message: 'Failed'),
        ),
      );

      await cubit.updateProfile(name: 'Jane', phone: '0100');

      expect(cubit.state, const ProfileError('Failed'));
    });
  });

  group('deleteAccount', () {
    test('emits Loading then AccountDeleted on success', () async {
      when(
        () => repository.deleteAccount(),
      ).thenAnswer((_) async => const Success(null));

      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([const ProfileLoading(), const ProfileAccountDeleted()]),
      );

      await cubit.deleteAccount();
      await expectation;
    });

    test('emits ReauthRequired when a recent login is required', () async {
      when(() => repository.deleteAccount()).thenAnswer(
        (_) async =>
            const Failure(AppErrorModel(code: 'requires-recent-login')),
      );

      await cubit.deleteAccount();

      expect(cubit.state, const ProfileReauthRequired());
    });

    test('emits ProfileError on other failures', () async {
      when(() => repository.deleteAccount()).thenAnswer(
        (_) async => const Failure(
          AppErrorModel(code: 'network-error', message: 'Failed'),
        ),
      );

      await cubit.deleteAccount();

      expect(cubit.state, const ProfileError('Failed'));
    });
  });
}
