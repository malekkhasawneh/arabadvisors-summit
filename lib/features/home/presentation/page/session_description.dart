import 'package:flutter/material.dart';
import 'package:provision/core/helpers/shared_preferences_helper.dart';
import 'package:provision/core/resources/dimentions.dart';
import 'package:provision/core/resources/images.dart';
import 'package:provision/features/event/presentation/page/user_profile_page.dart';
import 'package:provision/features/home/data/model/all_events.dart';
import 'package:provision/features/home/data/repository/home_repository.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../event/data/model/get_all_participants_model.dart';

class SessionDescription extends StatefulWidget {
  SessionDescription({Key? key, required this.eventDetails}) : super(key: key);

  GetAllEvents eventDetails;

  @override
  State<SessionDescription> createState() => _SessionDescriptionState();
}

class _SessionDescriptionState extends State<SessionDescription> {
  List<AllParticipantsModel> moderatorsInfo = [];
  List<AllParticipantsModel> panelistsInfo = [];
  bool loading = true;
  String image = '';
  List<String> titles = [];

  @override
  void initState() {
    setState(() {
      titles = widget.eventDetails.titles.split(',');
    });
    Future.wait([
      getModeratorsInfo(),
      getPanelistsInfo(),
    ]).then((_) async {
      await Future.delayed(const Duration(seconds: 1)).then(
        (_) => setState(
          () {
            loading = false;
          },
        ),
      );
    });
    super.initState();
  }

  Future<void> getModeratorsInfo() async {
    for (var speaker in (widget.eventDetails.moderatorIds.split(','))) {
      HomeRepository.showParticipantProfile(context,
              profileId: int.tryParse(speaker)!)
          .then(
        (value) {
          setState(() {
            value.name = titles.first + value.name;
            moderatorsInfo.add(value);
            moderatorsInfo.first.isModerator = true;
            titles.removeAt(0);
          });
        },
      );
    }
  }

  Future<void> getPanelistsInfo() async {
    if (widget.eventDetails.panelistsIds.isNotEmpty) {
      for (var speaker in (widget.eventDetails.panelistsIds.split(','))) {
        HomeRepository.showParticipantProfile(context,
                profileId: int.tryParse(speaker)!)
            .then(
          (value) {
            setState(() {
              value.name = titles.first + value.name;
              panelistsInfo.add(value);
              titles.removeAt(0);
            });
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      bottom: false,
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
                        left: screenWidth * 0.05,
                        bottom: 0),
                    width: screenWidth * 0.9,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        SizedBox(
                          width: screenWidth * 0.85,
                          child: Text(
                            widget.eventDetails.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                              fontSize: 18,
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
                          color: AppColors.white,
                          height: 1,
                          width: screenWidth,
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        widget.eventDetails.moderatorIds.isNotEmpty &&
                                moderatorsInfo.isNotEmpty
                            ? Column(
                                children: [
                                  ...moderatorsInfo.map(
                                    (speaker) => GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => ProfilePage(
                                                      showLeading: speaker.id ==
                                                          SharedPreferencesHelper()
                                                              .getValueForInt(
                                                                  key: 'id'),
                                                      profileId: speaker.id,
                                                      isSameUser: speaker.id ==
                                                          SharedPreferencesHelper()
                                                              .getValueForInt(
                                                                  key: 'id'),
                                                    )));
                                      },
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 15),
                                        width: screenWidth * 0.85,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                SizedBox(
                                                  width: screenWidth * 0.65,
                                                  child: Text(
                                                    speaker.isModerator
                                                        ? 'Moderator'
                                                        : 'Speaker',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                    speaker.name,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppColors.orange,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            speaker.image != null &&
                                                    speaker.image.isNotEmpty
                                                ? Container(
                                                    width: 45,
                                                    height: 45,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          Radius.circular(100),
                                                        ),
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                speaker.image),
                                                            fit: BoxFit.fill)),
                                                  )
                                                : Container(
                                                    width: 45,
                                                    height: 45,
                                                    decoration:
                                                        const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  100),
                                                            ),
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    Images
                                                                        .defaultUserImage),
                                                                fit: BoxFit
                                                                    .fill)),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        const SizedBox(
                          height: 10,
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
                        const SizedBox(
                          height: 7,
                        ),
                        widget.eventDetails.panelistsIds.isNotEmpty &&
                                panelistsInfo.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 30),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    SizedBox(
                                      width: screenWidth * 0.85,
                                      child: const Text(
                                        'Panelist :',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    ...panelistsInfo.map((user) =>
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) => ProfilePage(
                                                          profileId: user.id,
                                                          isSameUser: false,
                                                        )));
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 15),
                                            width: screenWidth * 0.85,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: screenWidth * 0.65,
                                                  child: Text(
                                                    user.name,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppColors.orange,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                                user.image != null &&
                                                        user.image.isNotEmpty
                                                    ? Container(
                                                        width: 45,
                                                        height: 45,
                                                        decoration:
                                                            BoxDecoration(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          100),
                                                                ),
                                                                image: DecorationImage(
                                                                    image: NetworkImage(user
                                                                        .image),
                                                                    fit: BoxFit
                                                                        .fill)),
                                                      )
                                                    : Container(
                                                        width: 45,
                                                        height: 45,
                                                        decoration:
                                                            const BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          100),
                                                                ),
                                                                image: DecorationImage(
                                                                    image: AssetImage(
                                                                        Images
                                                                            .defaultUserImage),
                                                                    fit: BoxFit
                                                                        .fill)),
                                                      ),
                                              ],
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
