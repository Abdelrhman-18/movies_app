import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movies_app/core/utils/app_result.dart';
import 'package:movies_app/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:movies_app/features/auth/presentation/cubit/reset_password/reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit(this._resetPasswordUseCase)
    : super(const ResetPasswordInitial());

  final ResetPasswordUseCase _resetPasswordUseCase;

  Future<void> resetPassword(String email) async {
    emit(const ResetPasswordLoading());

    final result = await _resetPasswordUseCase(email);

    emit(switch (result) {
      Success() => const ResetPasswordSuccess(),
      Failure(error: final error) => ResetPasswordError(
        error.message ?? error.code,
      ),
    });
  }
}
