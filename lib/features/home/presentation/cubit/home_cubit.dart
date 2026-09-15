import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movies_app/core/movies/domain/entities/movie_entity.dart';
import 'package:movies_app/core/movies/domain/entities/movie_genres.dart';
import 'package:movies_app/core/movies/domain/usecases/get_movies_usecase.dart';
import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/home/presentation/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._getMovies) : super(const HomeLoading());

  final GetMoviesUseCase _getMovies;

  static final List<String> categoryGenres = MovieGenres.all.take(3).toList();

  Future<void> load() async {
    emit(const HomeLoading());

    final results = await Future.wait([
      _getMovies(sortBy: 'date_added', orderBy: 'desc', limit: 5),
      for (final genre in categoryGenres)
        _getMovies(genre: genre, sortBy: 'rating', orderBy: 'desc', limit: 10),
    ]);

    for (final result in results) {
      if (result case Failure(:final error)) {
        emit(HomeError(error));
        return;
      }
    }

    final hero = (results[0] as Success<List<MovieEntity>>).data;
    final categories = [
      for (var i = 0; i < categoryGenres.length; i++)
        HomeCategory(
          title: categoryGenres[i],
          movies: (results[i + 1] as Success<List<MovieEntity>>).data,
        ),
    ];

    if (hero.isEmpty &&
        categories.every((category) => category.movies.isEmpty)) {
      emit(const HomeEmpty());
      return;
    }

    emit(HomeSuccess(hero: hero, categories: categories));
  }
}
