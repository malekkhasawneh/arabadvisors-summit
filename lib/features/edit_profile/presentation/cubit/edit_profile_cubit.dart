import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(EditProfileInitial());

  bool _showPassword = false;

  bool get getShowPassword => _showPassword;

  set setShowPassword(bool value) {
    emit(EditProfileLoading());
    _showPassword = value;
    emit(EditProfileLoaded());
  }

  bool _showConfirmPassword = false;

  bool get getShowConfirmPassword => _showConfirmPassword;

  set setShowConfirmPassword(bool value) {
    emit(EditProfileLoading());
    _showConfirmPassword = value;
    emit(EditProfileLoaded());
  }
}
