import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInInitial());

  bool _showPassword = false;

  bool get getShowPassword => _showPassword;

  set setShowPassword(bool value) {
    emit(SignInLoading());
    _showPassword = value;
    emit(SignInLoaded());
  }
}
