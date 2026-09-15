import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/core/movies/domain/usecases/get_movies_usecase.dart';
import 'package:movies_app/features/search/presentation/controllers/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this._getMovies) : super(const SearchInitial());

  final GetMoviesUseCase _getMovies;

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

    final result = await _getMovies(query: query, limit: 20);
    emit(switch (result) {
      Success(:final data) when data.isEmpty => const SearchEmpty(),
      Success(:final data) => SearchSuccess(data),
      Failure(:final error) => SearchError(error),
    });
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
