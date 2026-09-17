import 'package:flutter_test/flutter_test.dart';

import 'package:movies_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:movies_app/features/search/presentation/cubit/search_state.dart';

void main() {
  group('SearchCubit', () {
    test('starts in SearchInitial', () {
      final cubit = SearchCubit();
      addTearDown(cubit.close);

      expect(cubit.state, const SearchInitial());
    });

    test('queryChanged with an empty/blank query resets to SearchInitial', () {
      final cubit = SearchCubit();
      addTearDown(cubit.close);

      cubit.queryChanged('   ');

      expect(cubit.state, const SearchInitial());
    });

    test(
      'queryChanged debounces and emits SearchSuccess for a match',
      () async {
        final cubit = SearchCubit();
        addTearDown(cubit.close);

        cubit.queryChanged('orbit');
        expect(cubit.state, const SearchInitial());

        await Future<void>.delayed(const Duration(milliseconds: 500));

        final state = cubit.state;
        expect(state, isA<SearchSuccess>());
        expect((state as SearchSuccess).movies.single.title, 'Second Orbit');
      },
    );

    test('queryChanged emits SearchEmpty when nothing matches', () async {
      final cubit = SearchCubit();
      addTearDown(cubit.close);

      cubit.queryChanged('nonexistent movie');

      await Future<void>.delayed(const Duration(milliseconds: 500));

      expect(cubit.state, const SearchEmpty());
    });

    test(
      'rapid queryChanged calls cancel the previous debounce timer',
      () async {
        final cubit = SearchCubit();
        addTearDown(cubit.close);

        cubit.queryChanged('quiet');
        await Future<void>.delayed(const Duration(milliseconds: 200));
        cubit.queryChanged('orbit');

        await Future<void>.delayed(const Duration(milliseconds: 500));

        final state = cubit.state as SearchSuccess;
        expect(state.movies.single.title, 'Second Orbit');
      },
    );
  });
}
