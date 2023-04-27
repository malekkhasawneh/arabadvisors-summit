import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:provision/core/resources/app_strings.dart';

part 'alert_state.dart';

class AlertCubit extends Cubit<AlertState> {
  AlertCubit() : super(AlertInitial());

  String selectedTabName = AppStrings.notification;

  String get getSelectedTabName => selectedTabName;

  set setSelectedTabName(String value) {
    emit(AlertLoading());
    selectedTabName = value;
    emit(AlertLoaded());
  }
}
