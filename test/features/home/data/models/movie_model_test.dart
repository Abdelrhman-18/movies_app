import 'package:flutter_test/flutter_test.dart';

import 'package:movies_app/features/home/data/models/movie_model.dart';

void main() {
  group('MovieModel.fromJson', () {
    test('parses a well-formed movie', () {
      final model = MovieModel.fromJson({
        'id': 42,
        'title_long': 'Some Movie (2020)',
        'year': 2020,
        'rating': 7.5,
        'medium_cover_image': 'https://example.com/poster.jpg',
        'genres': ['Action', 'Drama'],
      });

      expect(model.id, 42);
      expect(model.title, 'Some Movie (2020)');
      expect(model.year, 2020);
      expect(model.rating, 7.5);
      expect(model.posterUrl, 'https://example.com/poster.jpg');
      expect(model.genres, ['Action', 'Drama']);
      expect(model.isMissing, isFalse);
    });

    test('falls back to "title" when "title_long" is absent', () {
      final model = MovieModel.fromJson({'title': 'Short Title'});

      expect(model.title, 'Short Title');
    });

    test('defaults missing fields safely', () {
      final model = MovieModel.fromJson(const {});

      expect(model.id, 0);
      expect(model.title, '');
      expect(model.year, 0);
      expect(model.rating, 0);
      expect(model.posterUrl, '');
      expect(model.genres, isEmpty);
    });

    test('isMissing is true when id is 0 (movie not found)', () {
      final model = MovieModel.fromJson({'id': 0, 'title': 'ok'});

      expect(model.isMissing, isTrue);
    });

    test('accepts an integer rating as a double', () {
      final model = MovieModel.fromJson({'rating': 8});

      expect(model.rating, 8.0);
    });
  });
}
