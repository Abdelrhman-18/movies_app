import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/profile/presentation/cubit/reset_password/reset_password_state.dart';

import '../../../../auth/domain/usecases/reset_password_use_case.dart';


class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit(this._resetPasswordUseCase)
      : super(ResetPasswordInitial());

  final ResetPasswordUseCase _resetPasswordUseCase;

  Future<void> resetPassword(String email) async {
    emit(ResetPasswordLoading());

    try {
      await _resetPasswordUseCase(email);

      emit(ResetPasswordSuccess());
    } catch (e) {
      emit(ResetPasswordError(e.toString()));
    }
  }
}