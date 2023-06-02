import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provision/core/resources/dimentions.dart';
import 'package:provision/features/voting/data/repository/voting_repository.dart';
import 'package:provision/features/voting/presentation/cubit/voting_cubit.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_strings.dart';

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

  bool _isLoading = false;
  bool checkUnAnsweredQuestions = false;

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
                        BlocProvider.of<VotingCubit>(context)
                            .votingModel!
                            .title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 15),
                      height: ((screenHeight * 0.97 - safePadding) -
                              defaultAppBarHeight) -
                          (55),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ...BlocProvider.of<VotingCubit>(context)
                                .votingModel!
                                .questions
                                .map((question) {
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                width: screenWidth,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                  border: Border.all(
                                    color: checkUnAnsweredQuestions &&
                                            question.selectedAnswer == -1
                                        ? AppColors.red
                                        : AppColors.white,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      question.question,
                                    ),
                                    ...question.answers.map(
                                      (answer) {
                                        return Transform.translate(
                                          offset: const Offset(-15, 0),
                                          child: Row(
                                            children: [
                                              Radio(
                                                value:
                                                    question.selectedAnswer ==
                                                        answer.id,
                                                groupValue: true,
                                                onChanged: (_) {
                                                  setState(() {
                                                    question.selectedAnswer =
                                                        answer.id;
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
                            }).toList(),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.orange,
                              ),
                              onPressed: () {
                                List<int> answersList = [];
                                for (var question
                                    in BlocProvider.of<VotingCubit>(context)
                                        .votingModel!
                                        .questions) {
                                  answersList.add(question.selectedAnswer);
                                }
                                if (!answersList.contains(-1)) {
                                  setState(() {
                                    _isLoading = true;
                                    checkUnAnsweredQuestions = false;
                                  });
                                  VotingRepository.submitVote(
                                          context, answersList)
                                      .then((value) {
                                    if (value) {
                                      answersList.clear();
                                      for (var question
                                          in BlocProvider.of<VotingCubit>(
                                                  context)
                                              .votingModel!
                                              .questions) {
                                        question.selectedAnswer = -1;
                                      }
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Thank you for voting',
                                          ),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Something wrong',
                                          ),
                                        ),
                                      );
                                    }
                                    setState(() {
                                      _isLoading = false;
                                      checkUnAnsweredQuestions = false;
                                    });
                                  });
                                } else {
                                  setState(() {
                                    checkUnAnsweredQuestions = true;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please make sure that all questions are answered',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 15,
                                      width: 15,
                                      child: CircularProgressIndicator(
                                        color: AppColors.white,
                                      ),
                                    )
                                  : const Text(
                                      AppStrings.submit,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ],
                        ),
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
