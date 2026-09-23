import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:movies_app/core/error/app_error_model.dart';
import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/profile/domain/entities/wishlist_item.dart';
import 'package:movies_app/features/profile/domain/repos/profile_lists_repository.dart';
import 'package:movies_app/features/profile/domain/usecases/get_wishlist_usecase.dart';
import 'package:movies_app/features/profile/presentation/cubit/wishlist/wishlist_cubit.dart';
import 'package:movies_app/features/profile/presentation/cubit/wishlist/wishlist_state.dart';

class _MockProfileListsRepository extends Mock
    implements ProfileListsRepository {}

void main() {
  late _MockProfileListsRepository repository;
  late WishlistCubit cubit;

  setUp(() {
    repository = _MockProfileListsRepository();
    cubit = WishlistCubit(GetWishlistUseCase(repository));
  });

  tearDown(() => cubit.close());

  test('initial state is WishlistLoading', () {
    expect(cubit.state, const WishlistLoading());
  });

  test('load emits WishlistSuccess with the fetched movies', () async {
    const movies = [
      WishlistItem(movieId: 1, title: 'Movie', posterUrl: '', rating: 7),
    ];
    when(
      () => repository.getWishlist(),
    ).thenAnswer((_) async => const Success(movies));

    await cubit.load();

    expect(cubit.state, const WishlistSuccess(movies));
  });

  test('load emits WishlistEmpty when there are no movies', () async {
    when(
      () => repository.getWishlist(),
    ).thenAnswer((_) async => const Success([]));

    await cubit.load();

    expect(cubit.state, const WishlistEmpty());
  });

  test('load emits WishlistError on failure', () async {
    const error = AppErrorModel(code: 'no-connection', message: 'offline');
    when(
      () => repository.getWishlist(),
    ).thenAnswer((_) async => const Failure(error));

    await cubit.load();

    expect(cubit.state, const WishlistError(error));
  });
}
