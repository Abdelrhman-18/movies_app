import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movies_app/features/search/presentation/cubit/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(const SearchInitial());

  // TODO: replace with a real Search-scoped movies repository once one
  // exists; Movies data currently only lives in the Home feature.
  static const List<DummyMovie> _dummyMovies = [
    (id: 1, title: 'Neon Horizon', rating: 7.8, posterUrl: ''),
    (id: 2, title: 'Quiet Streets', rating: 6.5, posterUrl: ''),
    (id: 3, title: 'Laugh Track', rating: 7.1, posterUrl: ''),
    (id: 4, title: 'The Basement', rating: 6.9, posterUrl: ''),
    (id: 5, title: 'Second Orbit', rating: 8.2, posterUrl: ''),
    (id: 6, title: 'Letters Home', rating: 7.4, posterUrl: ''),
  ];

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

  void _search(String query) {
    emit(const SearchLoading());

    final lowerQuery = query.toLowerCase();
    final movies = _dummyMovies
        .where((movie) => movie.title.toLowerCase().contains(lowerQuery))
        .toList();

    emit(movies.isEmpty ? const SearchEmpty() : SearchSuccess(movies));
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
