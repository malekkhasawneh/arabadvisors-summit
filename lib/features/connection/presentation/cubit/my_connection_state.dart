part of 'my_connection_cubit.dart';

abstract class MyConnectionState extends Equatable {
  const MyConnectionState();
}

class MyConnectionInitial extends MyConnectionState {
  @override
  List<Object> get props => [];
}
class MyConnectionLoading extends MyConnectionState {
  @override
  List<Object> get props => [];
}
class MyConnectionLoaded extends MyConnectionState {
  @override
  List<Object> get props => [];
}
