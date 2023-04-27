part of 'event_cubit.dart';

abstract class EventState extends Equatable {
  const EventState();
}

class EventInitial extends EventState {
  @override
  List<Object> get props => [];
}
class EventLoading extends EventState {
  @override
  List<Object> get props => [];
}
class EventLoaded extends EventState {
  @override
  List<Object> get props => [];
}
