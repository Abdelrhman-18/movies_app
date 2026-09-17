import 'package:flutter_test/flutter_test.dart';

import 'package:movies_app/features/home/data/models/movies_page_model.dart';

void main() {
  group('MoviesPageModel.fromJson', () {
    test('parses movie count, page number, and the movie list', () {
      final page = MoviesPageModel.fromJson({
        'movie_count': 2,
        'page_number': 1,
        'movies': [
          {'id': 1, 'title': 'A'},
          {'id': 2, 'title': 'B'},
        ],
      });

      expect(page.movieCount, 2);
      expect(page.pageNumber, 1);
      expect(page.movies, hasLength(2));
      expect(page.movies.map((m) => m.title), ['A', 'B']);
    });

    test('defaults to an empty movie list and page 1 when absent', () {
      final page = MoviesPageModel.fromJson(const {});

      expect(page.movieCount, 0);
      expect(page.pageNumber, 1);
      expect(page.movies, isEmpty);
    });
  });
}
