import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  bool _showPassword = false;

  bool get getShowPassword => _showPassword;

  set setShowPassword(bool value) {
    emit(SignUpLoading());
    _showPassword = value;
    emit(SignUpLoaded());
  }

  bool _showConfirmPassword = false;

  bool get getShowConfirmPassword => _showConfirmPassword;

  set setShowConfirmPassword(bool value) {
    emit(SignUpLoading());
    _showConfirmPassword = value;
    emit(SignUpLoaded());
  }

  String _countryCode = '';

  String get getCountryCode => _countryCode;

  set setCountryCode(String value) {
    emit(SignUpLoading());
    _countryCode = value;
    emit(SignUpLoaded());
  }
}
