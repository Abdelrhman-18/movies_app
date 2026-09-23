import 'package:flutter_test/flutter_test.dart';

import 'package:movies_app/features/movie_details/data/models/movie_details_model.dart';

void main() {
  group('MovieDetailsModel.fromJson', () {
    test('parses a well-formed movie with images and cast', () {
      final model = MovieDetailsModel.fromJson({
        'id': 42,
        'title_long': 'Some Movie (2020)',
        'year': 2020,
        'rating': 7.6,
        'runtime': 90,
        'like_count': 15,
        'description_full': 'Full description.',
        'genres': ['Action', 'Drama'],
        'background_image': 'https://example.com/backdrop.jpg',
        'large_cover_image': 'https://example.com/poster.jpg',
        'large_screenshot_image1': 'https://example.com/shot1.jpg',
        'large_screenshot_image2': 'https://example.com/shot2.jpg',
        'large_screenshot_image3': '',
        'cast': [
          {
            'name': 'Jane Doe',
            'character_name': 'Hero',
            'url_small_image': 'https://example.com/jane.jpg',
          },
        ],
      });

      expect(model.id, 42);
      expect(model.title, 'Some Movie (2020)');
      expect(model.year, 2020);
      expect(model.rating, 7.6);
      expect(model.runtimeMinutes, 90);
      expect(model.likeCount, 15);
      expect(model.summary, 'Full description.');
      expect(model.genres, ['Action', 'Drama']);
      expect(model.backdropUrl, 'https://example.com/backdrop.jpg');
      expect(model.posterUrl, 'https://example.com/poster.jpg');
      expect(model.screenshotUrls, [
        'https://example.com/shot1.jpg',
        'https://example.com/shot2.jpg',
      ]);
      expect(model.cast, hasLength(1));
      expect(model.cast.single.name, 'Jane Doe');
      expect(model.cast.single.character, 'Hero');
      expect(model.cast.single.avatarUrl, 'https://example.com/jane.jpg');
      expect(model.isMissing, isFalse);
    });

    test(
      'falls back to synopsis then summary when description_full is absent',
      () {
        final withSynopsis = MovieDetailsModel.fromJson({
          'synopsis': 'Synopsis text',
        });
        expect(withSynopsis.summary, 'Synopsis text');

        final withSummary = MovieDetailsModel.fromJson({
          'summary': 'Summary text',
        });
        expect(withSummary.summary, 'Summary text');
      },
    );

    test('defaults missing fields safely', () {
      final model = MovieDetailsModel.fromJson(const {});

      expect(model.id, 0);
      expect(model.title, '');
      expect(model.year, 0);
      expect(model.rating, 0);
      expect(model.runtimeMinutes, 0);
      expect(model.likeCount, 0);
      expect(model.summary, '');
      expect(model.genres, isEmpty);
      expect(model.backdropUrl, '');
      expect(model.posterUrl, '');
      expect(model.screenshotUrls, isEmpty);
      expect(model.cast, isEmpty);
    });

    test('isMissing is true when id is 0 (movie not found)', () {
      final model = MovieDetailsModel.fromJson({'id': 0, 'title': 'ok'});

      expect(model.isMissing, isTrue);
    });
  });
}
