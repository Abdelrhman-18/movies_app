import 'package:flutter_test/flutter_test.dart';

import 'package:movies_app/features/browse/presentation/cubit/browse_cubit.dart';
import 'package:movies_app/features/browse/presentation/cubit/browse_state.dart';

void main() {
  group('BrowseCubit', () {
    test('starts in BrowseLoading with the first genre', () {
      final cubit = BrowseCubit();
      addTearDown(cubit.close);

      expect(cubit.state, BrowseLoading(BrowseCubit.genres.first));
    });

    test('selectGenre emits BrowseSuccess with matching movies', () {
      final cubit = BrowseCubit();
      addTearDown(cubit.close);

      cubit.selectGenre('Comedy');

      final state = cubit.state;
      expect(state, isA<BrowseSuccess>());
      expect(state.genre, 'Comedy');
      expect(
        (state as BrowseSuccess).movies.every(
          (m) => m.genres.contains('Comedy'),
        ),
        isTrue,
      );
    });

    test('selectGenre emits BrowseEmpty when no movie matches the genre', () {
      final cubit = BrowseCubit();
      addTearDown(cubit.close);

      cubit.selectGenre('Documentary');

      expect(cubit.state, BrowseEmpty('Documentary'));
    });

    test('selectGenre matches movies tagged with more than one genre', () {
      final cubit = BrowseCubit();
      addTearDown(cubit.close);

      cubit.selectGenre('Action');

      final state = cubit.state as BrowseSuccess;
      expect(state.movies.map((m) => m.title), contains('Second Orbit'));
    });
  });
}
