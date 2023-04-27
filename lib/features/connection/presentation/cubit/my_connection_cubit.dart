import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'my_connection_state.dart';

class MyConnectionCubit extends Cubit<MyConnectionState> {
  MyConnectionCubit() : super(MyConnectionInitial());
  bool haveSuffix = false;

  bool get getHaveSuffix => haveSuffix;

  set setHaveSuffix(bool value) {
    emit(MyConnectionLoading());
    haveSuffix = value;
    emit(MyConnectionLoaded());
  }
  bool hideTitle = false;

  bool get getHideTitle => hideTitle;

  set setHideTitle(bool value) {
    emit(MyConnectionLoading());
    hideTitle = value;
    emit(MyConnectionLoaded());
  }
  bool _showClearSearch = false;

  bool get getShowClearSearch => _showClearSearch;

  set setShowClearSearch(bool value) {
    emit(MyConnectionLoading());
    _showClearSearch = value;
    emit(MyConnectionLoaded());
  }
}
