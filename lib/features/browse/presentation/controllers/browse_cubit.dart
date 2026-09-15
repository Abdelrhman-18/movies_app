import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/core/movies/domain/entities/movie_genres.dart';
import 'package:movies_app/core/movies/domain/usecases/get_movies_usecase.dart';
import 'package:movies_app/features/browse/presentation/controllers/browse_state.dart';

class BrowseCubit extends Cubit<BrowseState> {
  BrowseCubit(this._getMovies) : super(BrowseLoading(MovieGenres.all.first));

  final GetMoviesUseCase _getMovies;

  Future<void> selectGenre(String genre) async {
    emit(BrowseLoading(genre));

    final result = await _getMovies(genre: genre, limit: 20);
    emit(switch (result) {
      Success(:final data) when data.isEmpty => BrowseEmpty(genre),
      Success(:final data) => BrowseSuccess(genre, data),
      Failure(:final error) => BrowseError(genre, error),
    });
  }
}
