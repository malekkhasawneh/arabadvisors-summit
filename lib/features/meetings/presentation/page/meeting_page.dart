import 'package:flutter/material.dart';
import 'package:provision/core/resources/dimentions.dart';
import 'package:provision/features/home/data/repository/home_repository.dart';
import 'package:provision/features/meetings/data/repository/meetings_repository.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_strings.dart';
import '../../../home/data/model/all_times.dart';
import '../../data/model/all_meetings_model.dart';
import '../widget/buttons_row.dart';
import '../widget/meeting_request_card.dart';

class MeetingPage extends StatefulWidget {
  const MeetingPage(
      {Key? key,
      required this.userId,
      this.isViewOneMeeting = false,
      required this.meetingId})
      : super(key: key);
  final int userId;
  final bool isViewOneMeeting;
  final int meetingId;

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  List<AllMeetingsModel> meetingsList = [];
  bool loading = true;
  List<GetAllTimes> timesList = [];

  @override
  void initState() {
    HomeRepository.getTimes(
      context,
    ).then((value) => setState(() {
          timesList = value;
        }));
    widget.isViewOneMeeting
        ? MeetingsRepository.getMeetingById(context,meetingId: widget.meetingId)
            .then((value) => setState(() {
                  meetingsList.add(value);
                  loading = false;
                }))
        : MeetingsRepository.getAllMeetings(context,).then(
            (value) => setState(
              () {
                meetingsList = value;
                loading = false;
              },
            ),
          );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double safePadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.transparent,
        automaticallyImplyLeading: widget.isViewOneMeeting,
      ),
      body: SingleChildScrollView(
        child: Container(
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
              : meetingsList.isEmpty
                  ? const Center(
                      child: Text(
                        AppStrings.noData,
                        style: TextStyle(
                          color: AppColors.white,
                        ),
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.only(
                          top: safePadding +
                              (widget.isViewOneMeeting
                                  ? defaultAppBarHeight
                                  : 0),
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
                              AppStrings.meetingRequest,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                                fontSize: 22,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: meetingsList.length,
                              cacheExtent: 999999999999999,
                              padding: const EdgeInsets.only(bottom: 100),
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(
                                    bottom: 10,
                                  ),
                                  width: screenWidth * 0.9,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    border: Border.all(
                                        color: AppColors.black, width: 0.5),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Column(
                                    children: [
                                      MeetingRequestCard(
                                        meetingsModel: meetingsList[index],
                                      ),
                                      ButtonsRow(
                                        meetingsModel: meetingsList[index],
                                        timesList: timesList,
                                        userId: widget.userId,
                                        refreshMeetingsList: () {
                                          MeetingsRepository.getAllMeetings(context,)
                                              .then(
                                            (value) => setState(
                                              () {
                                                meetingsList = value;
                                                loading = false;
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}
