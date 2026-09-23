import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:movies_app/core/error/app_error_model.dart';
import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/profile/domain/entities/wishlist_item.dart';
import 'package:movies_app/features/profile/domain/repos/profile_lists_repository.dart';
import 'package:movies_app/features/profile/domain/usecases/get_history_usecase.dart';
import 'package:movies_app/features/profile/presentation/cubit/history/history_cubit.dart';
import 'package:movies_app/features/profile/presentation/cubit/history/history_state.dart';

class _MockProfileListsRepository extends Mock
    implements ProfileListsRepository {}

void main() {
  late _MockProfileListsRepository repository;
  late HistoryCubit cubit;

  setUp(() {
    repository = _MockProfileListsRepository();
    cubit = HistoryCubit(GetHistoryUseCase(repository));
  });

  tearDown(() => cubit.close());

  test('initial state is HistoryLoading', () {
    expect(cubit.state, const HistoryLoading());
  });

  test('load emits HistorySuccess with the fetched movies', () async {
    const movies = [
      WishlistItem(movieId: 1, title: 'Movie', posterUrl: '', rating: 7),
    ];
    when(
      () => repository.getHistory(),
    ).thenAnswer((_) async => const Success(movies));

    await cubit.load();

    expect(cubit.state, const HistorySuccess(movies));
  });

  test('load emits HistoryEmpty when there are no movies', () async {
    when(
      () => repository.getHistory(),
    ).thenAnswer((_) async => const Success([]));

    await cubit.load();

    expect(cubit.state, const HistoryEmpty());
  });

  test('load emits HistoryError on failure', () async {
    const error = AppErrorModel(code: 'no-connection', message: 'offline');
    when(
      () => repository.getHistory(),
    ).thenAnswer((_) async => const Failure(error));

    await cubit.load();

    expect(cubit.state, const HistoryError(error));
  });
}
