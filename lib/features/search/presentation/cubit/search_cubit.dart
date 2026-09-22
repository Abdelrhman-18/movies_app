import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movies_app/core/utils/app_result.dart';
import 'package:movies_app/features/home/domain/usecases/get_movies_usecase.dart';
import 'package:movies_app/features/search/presentation/cubit/search_state.dart';

import '../../../home/domain/entities/movie_entity.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this._getMoviesUseCase) : super(const SearchInitial());

  final GetMoviesUseCase _getMoviesUseCase;

  static const Duration _debounceDuration = Duration(milliseconds: 400);

  Timer? _debounce;

  void queryChanged(String query) {
    _debounce?.cancel();

    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      emit(const SearchInitial());
      return;
    }

    _debounce = Timer(_debounceDuration, () => _search(trimmed));
  }

  Future<void> _search(String query) async {
    emit(const SearchLoading());

    final result = await _getMoviesUseCase(query: query);

    switch (result) {
      case Success<List<MovieEntity>>(:final data):
        emit(data.isEmpty ? const SearchEmpty() : SearchSuccess(data));
      case Failure<List<MovieEntity>>(:final error):
        emit(SearchError(error));
    }
  }

  void retry(String query) {
    final trimmed = query.trim();
    if (trimmed.isNotEmpty) _search(trimmed);
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}