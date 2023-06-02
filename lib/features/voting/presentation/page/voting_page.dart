import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provision/features/voting/presentation/cubit/voting_cubit.dart';

import '../../../../core/resources/app_colors.dart';

class VotingPage extends StatefulWidget {
  const VotingPage({Key? key}) : super(key: key);

  @override
  State<VotingPage> createState() => _VotingPageState();
}

class _VotingPageState extends State<VotingPage> {
  @override
  void initState() {
    BlocProvider.of<VotingCubit>(context).getActiveForm(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double safePadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.blue,
              AppColors.skyBlue,
            ],
          ),
        ),
        child: BlocBuilder<VotingCubit, VotingState>(
          builder: (context, state) {
            if (state is VotingLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.orange,
                ),
              );
            } else if (state is VotingLoaded) {
              return Container(
                margin: EdgeInsets.only(
                    top: safePadding + 15,
                    left: screenWidth * 0.05,
                    right: screenWidth * 0.05,
                    bottom: 0),
                width: screenWidth * 0.9,
                height: screenHeight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.05,
                      child: Text(
                        state.votingModel.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.95 - (safePadding + 15),
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 15),
                        itemCount: state.votingModel.questions.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            width: screenWidth,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.votingModel.questions[index].question,
                                ),
                                ...state.votingModel.questions[index].answers
                                    .map(
                                  (answer) {
                                    return Transform.translate(
                                      offset: const Offset(-15, 0),
                                      child: Row(
                                        children: [
                                          Radio(
                                            value: state
                                                    .votingModel
                                                    .questions[index]
                                                    .selectedAnswer ==
                                                answer.id,
                                            groupValue: true,
                                            onChanged: (_) {
                                              setState(() {
                                                state
                                                    .votingModel
                                                    .questions[index]
                                                    .selectedAnswer = answer.id;
                                              });
                                            },
                                            activeColor: AppColors.orange,
                                          ),
                                          Text(answer.answer),
                                        ],
                                      ),
                                    );
                                  },
                                ).toList(),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.orange,
              ),
            );
          },
        ),
      ),
    );
  }
}
