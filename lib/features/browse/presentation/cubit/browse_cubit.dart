import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movies_app/core/utils/app_result.dart';
import 'package:movies_app/features/home/domain/entities/movie_entity.dart';
import 'package:movies_app/features/home/domain/usecases/get_movies_usecase.dart';
import 'package:movies_app/features/browse/presentation/cubit/browse_state.dart';

class BrowseCubit extends Cubit<BrowseState> {
  BrowseCubit(this._getMoviesUseCase) : super(const BrowseLoading());

  final GetMoviesUseCase _getMoviesUseCase;

  List<MovieEntity> _allMovies = [];

  Future<void> loadMovies() async {
    emit(const BrowseLoading());

    final result = await _getMoviesUseCase();

    switch (result) {
      case Success<List<MovieEntity>>(:final data):
        _allMovies = data;

        final genres = data.expand((movie) => movie.genres).toSet();

        if (genres.isEmpty) {
          emit(BrowseEmpty(genres: genres, selectedGenre: null));
          return;
        }

        final firstGenre = genres.first;
        _emitFiltered(genres, firstGenre);

      case Failure<List<MovieEntity>>(:final error):
        emit(BrowseError(genres: const {}, selectedGenre: null, error: error));
    }
  }

  void selectGenre(String genre) {
    final genres = state.genres;
    _emitFiltered(genres, genre);
  }

  void _emitFiltered(Set<String> genres, String genre) {
    final filtered = _allMovies
        .where((movie) => movie.genres.contains(genre))
        .toList();

    emit(
      filtered.isEmpty
          ? BrowseEmpty(genres: genres, selectedGenre: genre)
          : BrowseSuccess(
        genres: genres,
        selectedGenre: genre,
        movies: filtered,
      ),
    );
  }

  void retry() => loadMovies();
}