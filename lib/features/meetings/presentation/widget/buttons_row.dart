import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provision/core/resources/app_colors.dart';
import 'package:provision/core/resources/app_strings.dart';
import 'package:provision/features/meetings/data/repository/meetings_repository.dart';
import 'package:provision/features/meetings/presentation/widget/reschedule_test_field.dart';

import '../../../home/data/model/all_times.dart';
import '../../data/model/all_meetings_model.dart';

class ButtonsRow extends StatefulWidget {
  ButtonsRow({
    Key? key,
    required this.meetingsModel,
    required this.timesList,
    required this.userId,
    required this.refreshMeetingsList,
  }) : super(key: key);
  final AllMeetingsModel meetingsModel;
  final List<GetAllTimes> timesList;
  final int userId;
  final Function refreshMeetingsList;

  @override
  State<ButtonsRow> createState() => _ButtonsRowState();
}

class _ButtonsRowState extends State<ButtonsRow> {
  bool isRescheduleClicked = false;
  TextEditingController timesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
      height: 70,
      width: double.infinity,
      decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(
            color: AppColors.grey,
            width: 0.3,
          ),
          borderRadius: BorderRadius.circular(10)),
      child: footerWidget(widget.meetingsModel.meetingStatus),
    );
  }

  Widget footerWidget(String status) {
    if ((widget.meetingsModel.inviterId == widget.userId &&
            widget.meetingsModel.meetingStatus == 'PENDING') ||
        isRescheduleClicked) {
      log('======================================= PENDING ');
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RescheduleTextField(
            controller: timesController,
            timesList: widget.timesList,
          ),
          submitButton(),
        ],
      );
    } else if (widget.meetingsModel.meetingStatus == 'ACCEPTED') {
      log('======================================= ACCEPTED ');

      return acceptText();
    } else if (widget.meetingsModel.meetingStatus == 'REJECTED') {
      log('======================================= REJECTED ');

      return rejectText();
    } else if (widget.meetingsModel.meetingStatus == 'RESCHEDULED' &&
        widget.userId == widget.meetingsModel.rescheduledById) {
      log('======================================= RESCHEDULED ');

      return rescheduleText();
    } else if (widget.userId == widget.meetingsModel.inviterId &&
        widget.meetingsModel.meetingStatus == 'RESCHEDULED' &&
        widget.meetingsModel.invitedId ==
            widget.meetingsModel.rescheduledById) {
      log('======================================= RESCHEDULED1 ');

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          acceptButton(),
          rejectButton(),
          reButton(),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          acceptButton(),
          rejectButton(),
          reButton(),
        ],
      );
    }
  }

  Widget acceptText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          AppStrings.accepted,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.orange,
              fontSize: 18),
        ),
        SizedBox(
          height: 7,
        ),
        Text(
          AppStrings.checkMeetings,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.pink, fontSize: 12),
        ),
      ],
    );
  }

  Widget rescheduleText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.reMessage,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.grey.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget rejectText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          AppStrings.rejected,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.red, fontSize: 18),
        ),
      ],
    );
  }

  Widget acceptButton() {
    return ElevatedButton(
      onPressed: () {
        MeetingsRepository.acceptMeeting(meetingId: widget.meetingsModel.id)
            .then((value) {
          if (value) {
            widget.refreshMeetingsList();
          }
        });
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.orange,
          side: BorderSide(color: AppColors.grey.withOpacity(0.7))),
      child: const Text(AppStrings.accept),
    );
  }

  Widget rejectButton() {
    return ElevatedButton(
      onPressed: () {
        MeetingsRepository.rejectMeeting(meetingId: widget.meetingsModel.id)
            .then((value) {
          if (value) {
            widget.refreshMeetingsList();
          }
        });
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.red,
          side: BorderSide(color: AppColors.grey.withOpacity(0.7))),
      child: const Text(AppStrings.reject),
    );
  }

  Widget reButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          isRescheduleClicked = true;
        });
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.grey.withOpacity(0.7),
          side: BorderSide(color: AppColors.grey.withOpacity(0.7))),
      child: const Text(AppStrings.reSchedule),
    );
  }

  Widget submitButton() {
    return ElevatedButton(
      onPressed: () async {
        MeetingsRepository.rescheduleMeeting(
                meetingId: widget.meetingsModel.id,
                meetingTimeId: widget.timesList
                    .firstWhere(
                        (element) => element.roomTime == timesController.text)
                    .id)
            .then((value) {
          setState(() {
            isRescheduleClicked = false;
          });
          return widget.refreshMeetingsList();
        });
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(AppColors.orange),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: Colors.grey.withOpacity(0.7),
            ),
          ),
        ),
      ),
      child: const Text(AppStrings.submit),
    );
  }
}
