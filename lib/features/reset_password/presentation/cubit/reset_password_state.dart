part of 'reset_password_cubit.dart';

@immutable
abstract class ResetPasswordState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordLoaded extends ResetPasswordState {}

class ResetPasswordError extends ResetPasswordState {
  final String error;

  ResetPasswordError({required this.error});
}

class ResetPasswordSetValueLoading extends ResetPasswordState {}

class ResetPasswordSetValueLoaded extends ResetPasswordState {}
