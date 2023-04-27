import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(ResetPasswordInitial());
  bool _isInvalid = false;

  bool get getIsInvalid => _isInvalid;

  set setInvalid(bool value) {
    emit(ResetPasswordSetValueLoading());
    _isInvalid = value;
    emit(ResetPasswordSetValueLoaded());
  }

  bool _canEdit = false;

  bool get getCanEdit => _isInvalid;

  set setCanEdit(bool value) {
    emit(ResetPasswordSetValueLoading());
    _canEdit = value;
    emit(ResetPasswordSetValueLoaded());
  }

  bool _showOtp = false;

  bool get getShowOtp => _isInvalid;

  set setShowOtp(bool value) {
    emit(ResetPasswordSetValueLoading());
    _showOtp = value;
    emit(ResetPasswordSetValueLoaded());
  }

  bool _showPassword = false;

  bool get getShowPassword => _isInvalid;

  set setShowPassword(bool value) {
    emit(ResetPasswordSetValueLoading());
    _showPassword = value;
    emit(ResetPasswordSetValueLoaded());
  }
}
