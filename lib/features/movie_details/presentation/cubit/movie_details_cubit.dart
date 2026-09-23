import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/movie_details/domain/entities/related_movie_entity.dart';
import 'package:movies_app/features/movie_details/domain/usecases/get_movie_details_usecase.dart';
import 'package:movies_app/features/movie_details/domain/usecases/get_movie_suggestions_usecase.dart';
import 'package:movies_app/features/movie_details/presentation/cubit/movie_details_state.dart';

class MovieDetailsCubit extends Cubit<MovieDetailsState> {
  MovieDetailsCubit(this._getMovieDetails, this._getMovieSuggestions)
    : super(const MovieDetailsLoading());

  final GetMovieDetailsUseCase _getMovieDetails;
  final GetMovieSuggestionsUseCase _getMovieSuggestions;

  Future<void> load(int movieId) async {
    emit(const MovieDetailsLoading());

    final detailsFuture = _getMovieDetails(movieId);
    final suggestionsFuture = _getMovieSuggestions(movieId);
    final detailsResult = await detailsFuture;
    final suggestionsResult = await suggestionsFuture;

    if (detailsResult case Failure(:final error)) {
      emit(MovieDetailsError(error));
      return;
    }

    emit(
      MovieDetailsSuccess(
        details: (detailsResult as Success).data,
        suggestions: switch (suggestionsResult) {
          Success(:final data) => data,
          Failure() => const <RelatedMovieEntity>[],
        },
      ),
    );
  }
}
