import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provision/core/resources/app_colors.dart';
import 'package:provision/core/resources/app_strings.dart';
import 'package:provision/core/resources/images.dart';
import 'package:provision/features/meetings/data/model/all_meetings_model.dart';

import '../../../event/data/repository/events_repository.dart';

class MeetingRequestCard extends StatefulWidget {
  const MeetingRequestCard({Key? key, required this.meetingsModel})
      : super(key: key);
  final AllMeetingsModel meetingsModel;

  @override
  State<MeetingRequestCard> createState() => _MeetingRequestCardState();
}

class _MeetingRequestCardState extends State<MeetingRequestCard> {
  Uint8List? _inviterImageData;
  Uint8List? _invitedImageData;
  bool loading = true;

  @override
  void initState() {
    EventsRepository.getImageDetails(
            imageUrl: widget.meetingsModel.inviterImage.split('/').last)
        .then((value) => setState(() {
              _inviterImageData = value;
              loading = false;
            }));
    EventsRepository.getImageDetails(
            imageUrl: widget.meetingsModel.invitedImage.split('/').last)
        .then((value) => setState(() {
              _invitedImageData = value;
              loading = false;
            }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                AppStrings.organizer,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.grey.withOpacity(0.7),
                    fontSize: 16),
              ),
              Expanded(
                  child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: _inviterImageData != null
                      ? Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(100),
                              ),
                              image: DecorationImage(
                                  image: MemoryImage(_inviterImageData!),
                                  fit: BoxFit.fill)),
                        )
                      : Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(100),
                              ),
                              image: DecorationImage(
                                  image: AssetImage(Images.defaultUserImage),
                                  fit: BoxFit.fill)),
                        ),
                ),
                title: Text(
                  widget.meetingsModel.inviterName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text('Work @${widget.meetingsModel.inviterCompany}'),
              )),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            color: AppColors.grey,
            height: 0.5,
            width: double.infinity,
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.grey,
                width: 0.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Text(
                        AppStrings.date,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.grey.withOpacity(0.7),
                            fontSize: 16),
                      ),
                      Text(
                        widget.meetingsModel.meetingDate,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.orange,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Text(
                        AppStrings.time,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.grey.withOpacity(0.7),
                            fontSize: 16),
                      ),
                      Text(
                        widget.meetingsModel.meetingTime,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.orange,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(15),
                  child: Text(
                    AppStrings.participant,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.grey.withOpacity(0.7),
                        fontSize: 16),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                        child: ListTile(
                      leading: _inviterImageData != null
                          ? Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(100),
                                  ),
                                  image: DecorationImage(
                                      image: MemoryImage(_inviterImageData!),
                                      fit: BoxFit.fill)),
                            )
                          : Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(100),
                                  ),
                                  image: DecorationImage(
                                      image:
                                          AssetImage(Images.defaultUserImage),
                                      fit: BoxFit.fill)),
                            ),
                      title: Text(
                        widget.meetingsModel.inviterName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle:
                          Text('Work @${widget.meetingsModel.inviterCompany}'),
                    )),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      color: AppColors.grey,
                      width: 0.5,
                      height: 50,
                    ),
                    Expanded(
                        child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: _invitedImageData != null
                            ? Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(100),
                                    ),
                                    image: DecorationImage(
                                        image: MemoryImage(_inviterImageData!),
                                        fit: BoxFit.fill)),
                              )
                            : Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(100),
                                    ),
                                    image: DecorationImage(
                                        image:
                                            AssetImage(Images.defaultUserImage),
                                        fit: BoxFit.fill)),
                              ),
                      ),
                      title: Text(
                        widget.meetingsModel.invitedName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle:
                          Text('Work @${widget.meetingsModel.invitedCompany}'),
                    )),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Text(
                        AppStrings.location,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.grey.withOpacity(0.7),
                            fontSize: 16),
                      ),
                      SizedBox(
                        width: 150,
                        child: Text(
                          widget.meetingsModel.meetingRoom,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.orange,
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
