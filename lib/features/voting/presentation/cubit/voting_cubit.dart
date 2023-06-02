import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:provision/features/voting/data/model/voting_model.dart';
import 'package:provision/features/voting/data/repository/voting_repository.dart';

part 'voting_state.dart';

class VotingCubit extends Cubit<VotingState> {
  VotingCubit() : super(VotingInitial());

  VotingModel? votingModel;

  Future<void> getActiveForm(BuildContext context) async {
    emit(VotingLoading());
    votingModel = await VotingRepository.getActiveForm(context);
    emit(VotingLoaded());
  }
}
