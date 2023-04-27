import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  EventCubit() : super(EventInitial());
  bool _showDeleteButton = false;

  bool get getShowDeleteButton => _showDeleteButton;

  set setShowDeleteButton(bool value) {
    emit(EventLoading());
    _showDeleteButton = value;
    emit(EventLoaded());
  }
}
