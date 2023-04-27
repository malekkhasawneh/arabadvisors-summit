
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'splash_screen_state.dart';

class SplashScreenCubit extends Cubit<SplashScreenState> {
  static SplashScreenCubit get(BuildContext context)=>BlocProvider.of(context);
  SplashScreenCubit() : super(SplashScreenInitial());

  double _hideWidgetOpacity = 1;
  double get getHideWidgetOpacity => _hideWidgetOpacity;
  set setHideWidgetOpacity(double value) {
    emit(HideWidgetOpacityLoadingState());
    _hideWidgetOpacity = value;
    emit(HideWidgetOpacityLoadedState());
  }
}
