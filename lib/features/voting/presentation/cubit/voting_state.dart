part of 'voting_cubit.dart';

abstract class VotingState extends Equatable {
  const VotingState();
}

class VotingInitial extends VotingState {
  @override
  List<Object> get props => [];
}

class VotingLoading extends VotingState {
  @override
  List<Object> get props => [];
}

class VotingLoaded extends VotingState {
  VotingModel votingModel;

  VotingLoaded({required this.votingModel});

  @override
  List<Object> get props => [votingModel];
}

class VotingAddInProgress extends VotingState {
  @override
  List<Object> get props => [];
}

class VotingAddDone extends VotingState {
  @override
  List<Object> get props => [];
}
