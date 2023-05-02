import 'package:flutter/material.dart';
import 'package:provision/core/widgets/no_internet_widget.dart';
import 'package:provision/features/event/data/model/get_all_participants_model.dart';
import 'package:provision/features/event/data/repository/events_repository.dart';
import 'package:provision/features/home/data/repository/home_repository.dart';
import 'package:provision/features/home/presentation/widget/times_drop_down.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_strings.dart';
import '../../data/model/all_events.dart';
import '../../data/model/all_times.dart';
import '../widget/input_widget.dart';
import 'invite_participant.dart';
import 'session_description.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<GetAllEvents> eventList = [];
  List<GetAllTimes> timeList = [];
  bool loading = true;
  int participantId = 0;
  TextEditingController participantNameController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  @override
  void initState() {
    HomeRepository.getTimes(context,).then(
          (value) =>
          setState(
                () {
              timeList = value;loading = false;
            },
          ),
    );
    HomeRepository.getEventsDetails(context,).then(
          (value) =>
          setState(
                () {
              eventList = value;
              loading = false;
            },
          ),
    );
    HomeRepository.saveToken(context).then((value) => setState((){
      loading = false;
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double safePadding = MediaQuery
        .of(context)
        .padding
        .top;
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
        child: loading
            ? const Center(
          child: CircularProgressIndicator(
            color: AppColors.orange,
          ),
        )
            : eventList.isEmpty
            ? const Center(
          child: Text(AppStrings.noData),
        )
            : Container(
          margin: EdgeInsets.only(
              top: safePadding,
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
              bottom: 0),
          width: screenWidth * 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: screenWidth * 0.8,
                child: const Text(
                  AppStrings.homeTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.grey, width: 1),
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      width: screenWidth * 0.9,
                      child: const Text(
                        AppStrings.eventsTitle,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.blue,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      child: Column(
                        children: [
                          ...eventList.map((event) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            SessionDescription(
                                              eventDetails: event,
                                            )));
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                    top: 3,
                                    left: 5,
                                    right: 5,
                                    bottom: 3),
                                width: screenWidth * 0.9,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(7),
                                  color: AppColors.homeCardColor,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      event.time,
                                      style: const TextStyle(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      child: Text(
                                        event.title,
                                        style: const TextStyle(
                                            color: AppColors.white,
                                            fontSize: 10),
                                        overflow:
                                        TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 15),
                  width: screenWidth * 0.9,
                  child: const Text(
                    AppStrings.reserve,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              TimesDropDown(
                controller: timeController,
                labelName: AppStrings.homeTime,
                timesList: timeList,
              ),
              TitleAndInputForSignUpWidget(
                controller: participantNameController,
                labelName: AppStrings.invite,
                suffix: const Icon(
                  Icons.add,
                  size: 15,
                  color: AppColors.orange,
                ),
                onTap: () async {
                  AllParticipantsModel participant =
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const InviteParticipant(),
                    ),
                  );
                  if (participant != null) {
                    setState(() {
                      participantId = participant.id;
                      participantNameController.text =
                          participant.name;
                    });
                  } else {
                    setState(() {
                      participantId = 0;
                      participantNameController.text = '';
                    });
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 9),
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                    ),
                    onPressed: () {
                      if (timeController.text.isEmpty ||
                          participantId == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Please make sure to fill out the fields'),
                          ),
                        );
                      } else {
                        HomeRepository.checkIsConnected()
                            .then((value) {
                          if (value) {
                            HomeRepository.scheduleMeeting(
                                context, timeId: timeList
                                .firstWhere((element) =>
                            element.roomTime ==
                                timeController.text)
                                .id,
                                friendId: participantId)
                                .then((value) {
                              if (value) {
                                EventsRepository.showMyProfile(context)
                                    .then((userInfo) {
                                  HomeRepository.getToken(
                                      context, userId: participantId)
                                      .then((value) {
                                    HomeRepository.sendNotifications(
                                        context, title: 'Meeting Request',
                                        body:
                                        '${userInfo
                                            .name} send you meeting request',
                                        token: value);
                                  });
                                });
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      AppStrings.reservedSuccess,
                                    ),
                                  ),
                                );
                              }
                            });
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    NoInternetConnectionWidget(),
                              ),
                            );
                          }
                        });
                      }
                    },
                    child: const Text(
                      AppStrings.reserved,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
