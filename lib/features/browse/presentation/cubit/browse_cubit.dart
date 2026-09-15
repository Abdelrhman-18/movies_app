import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movies_app/features/browse/presentation/cubit/browse_state.dart';

class BrowseCubit extends Cubit<BrowseState> {
  BrowseCubit() : super(BrowseLoading(genres.first));

  static const List<String> genres = [
    'Action',
    'Drama',
    'Comedy',
    'Horror',
    'Sci-Fi',
    'Romance',
  ];

  // TODO: replace with a real Browse-scoped movies repository once one
  // exists; Movies data currently only lives in the Home feature.
  static const List<DummyMovie> _dummyMovies = [
    (
      id: 1,
      title: 'Neon Horizon',
      rating: 7.8,
      posterUrl: '',
      genres: ['Action', 'Sci-Fi'],
    ),
    (
      id: 2,
      title: 'Quiet Streets',
      rating: 6.5,
      posterUrl: '',
      genres: ['Drama'],
    ),
    (
      id: 3,
      title: 'Laugh Track',
      rating: 7.1,
      posterUrl: '',
      genres: ['Comedy'],
    ),
    (
      id: 4,
      title: 'The Basement',
      rating: 6.9,
      posterUrl: '',
      genres: ['Horror'],
    ),
    (
      id: 5,
      title: 'Second Orbit',
      rating: 8.2,
      posterUrl: '',
      genres: ['Sci-Fi', 'Action'],
    ),
    (
      id: 6,
      title: 'Letters Home',
      rating: 7.4,
      posterUrl: '',
      genres: ['Romance', 'Drama'],
    ),
  ];

  void selectGenre(String genre) {
    emit(BrowseLoading(genre));

    final movies = _dummyMovies
        .where((movie) => movie.genres.contains(genre))
        .toList();

    emit(movies.isEmpty ? BrowseEmpty(genre) : BrowseSuccess(genre, movies));
  }
}
