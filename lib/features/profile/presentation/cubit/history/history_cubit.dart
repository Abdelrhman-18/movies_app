import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movies_app/core/utils/app_result.dart';

import 'package:movies_app/features/profile/domain/usecases/get_history_usecase.dart';
import 'package:movies_app/features/profile/presentation/cubit/history/history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit(this._getHistory) : super(const HistoryLoading());

  final GetHistoryUseCase _getHistory;

  Future<void> load() async {
    emit(const HistoryLoading());

    final result = await _getHistory();

    emit(switch (result) {
      Success(:final data) when data.isEmpty => const HistoryEmpty(),
      Success(:final data) => HistorySuccess(data),
      Failure(:final error) => HistoryError(error),
    });
  }
}
