import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provision/core/resources/dimentions.dart';
import 'package:provision/core/resources/images.dart';
import 'package:provision/features/event/presentation/page/user_profile_page.dart';
import 'package:provision/features/home/data/model/all_events.dart';
import 'package:provision/features/home/data/repository/home_repository.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../event/data/model/get_all_participants_model.dart';
import '../../../event/data/repository/events_repository.dart';

class SessionDescription extends StatefulWidget {
  SessionDescription({Key? key, required this.eventDetails}) : super(key: key);

  GetAllEvents eventDetails;

  @override
  State<SessionDescription> createState() => _SessionDescriptionState();
}

class _SessionDescriptionState extends State<SessionDescription> {
  late AllParticipantsModel speakerInfo;
  bool loading = true;
  Uint8List? _imageData;

  @override
  void initState() {
    HomeRepository.showParticipantProfile(
        context,     profileId: widget.eventDetails.speakerId)
        .then((value) => setState(() {
              speakerInfo = value;
              loading = false;
            if(value.image.isNotEmpty){
              EventsRepository.getImageDetails(
                  context,  imageUrl: value.image.split('/').last)
                  .then((value) => setState(() {
                _imageData = value;
              }));
            }
            }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.transparent,
          automaticallyImplyLeading: true,
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
                : Container(
                    margin: EdgeInsets.only(
                        top: defaultAppBarHeight,
                        right: screenWidth * 0.05,
                        bottom: 0),
                    width: screenWidth * 0.9,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: screenWidth * 0.85,
                          child: Text(
                            widget.eventDetails.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                              fontSize: 22,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: screenWidth * 0.85,
                          child: Text(
                            widget.eventDetails.time,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: screenWidth * 0.05),
                          color: AppColors.white,
                          height: 1,
                          width: screenWidth,
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ProfilePage(
                                          profileId: speakerInfo.id,
                                          isSameUser: false,
                                        )));
                          },
                          child: SizedBox(
                            width: screenWidth * 0.85,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    SizedBox(
                                      width: screenWidth * 0.65,
                                      child: const Text(
                                        'By',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    SizedBox(
                                      width: screenWidth * 0.65,
                                      child: Text(
                                        speakerInfo.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.orange,
                                          fontSize: 22,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: _imageData != null
                                      ? Image.memory(
                                          _imageData!,
                                          width: 55,
                                          height: 55,
                                        )
                                      : Image.asset(
                                          Images.defaultUserImage,
                                          width: 55,
                                          height: 55,
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          width: screenWidth * 0.85,
                          child: Text(
                            widget.eventDetails.desc,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
