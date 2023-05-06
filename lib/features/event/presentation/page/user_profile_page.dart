import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provision/core/resources/app_colors.dart';
import 'package:provision/core/resources/dimentions.dart';
import 'package:provision/core/resources/images.dart';
import 'package:provision/features/event/data/repository/events_repository.dart';

import '../../../home/data/repository/home_repository.dart';
import '../../data/model/get_all_participants_model.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key, this.isSameUser = true, required this.profileId})
      : super(key: key);
  bool isSameUser;
  final int profileId;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late AllParticipantsModel myProfile;
  bool loading = true;
  Uint8List? _imageData;

  @override
  void initState() {
    widget.isSameUser
        ? EventsRepository.showMyProfile(context).then(
            (value) {
              setState(() {
                myProfile = value;
                loading = false;
              });
              if (value.image.isNotEmpty) {
                EventsRepository.getImageDetails(context,
                        imageUrl: value.image.split('/').last)
                    .then((value) => setState(() {
                          _imageData = value;
                        }));
              }
            },
          )
        : EventsRepository.showParticipantProfile(context,
                profileId: widget.profileId)
            .then(
            (value) {
              setState(() {
                myProfile = value;
                loading = false;
                log('================================== value ${value.id}');
              });
            },
          );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double safeAreaPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: !widget.isSameUser
            ? IconButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                icon: Icon(Platform.isAndroid
                    ? Icons.arrow_back
                    : Icons.arrow_back_ios),
              )
            : const SizedBox(),
        backgroundColor: AppColors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [
                AppColors.blue,
                AppColors.skyBlue,
              ]),
        ),
        child: loading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.orange,
                ),
              )
            : Container(
                margin: EdgeInsets.only(
                    top: safeAreaPadding +
                        (!widget.isSameUser
                            ? defaultAppBarHeight + safeAreaPadding
                            : 25)),
                child: Column(
                  children: [
                    SizedBox(
                      width: screenWidth * 0.9,
                      height: 55,
                      child: Row(
                        children: [
                          _imageData != null
                              ? Container(
                                  width: 55,
                                  height: 55,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(100),
                                      ),
                                      image: DecorationImage(
                                          image: MemoryImage(_imageData!),
                                          fit: BoxFit.fill)),
                                )
                              : Container(
                                  width: 55,
                                  height: 55,
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(100),
                                      ),
                                      image: DecorationImage(
                                          image: AssetImage(
                                              Images.defaultUserImage),
                                          fit: BoxFit.fill)),
                                ),
                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: !widget.isSameUser ? 15 : 15,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      myProfile.name,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left,
                                    ),
                                    widget.isSameUser
                                        ? GestureDetector(
                                            onTap: () async {
                                              showDialog(
                                                  context: context,
                                                  builder: (_) => AlertDialog(
                                                        title: const Center(
                                                          child: Text(
                                                            'Change profile image',
                                                            style: TextStyle(
                                                                fontSize: 10),
                                                          ),
                                                        ),
                                                        content: SizedBox(
                                                          height: 50,
                                                          width: 50,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  Navigator.pop(
                                                                      context);
                                                                  XFile? xFile =
                                                                      await ImagePicker().pickImage(
                                                                          source:
                                                                              ImageSource.camera);
                                                                  File file =
                                                                      File(xFile!
                                                                          .path);
                                                                  // ignore: use_build_context_synchronously
                                                                  await EventsRepository.uploadImage(
                                                                          file,
                                                                          context)
                                                                      .then(
                                                                          (value) {
                                                                    if (value) {
                                                                      EventsRepository.showMyProfile(
                                                                              context)
                                                                          .then(
                                                                        (value) {
                                                                          setState(
                                                                              () {
                                                                            myProfile =
                                                                                value;
                                                                            loading =
                                                                                false;
                                                                          });
                                                                          if (value
                                                                              .image
                                                                              .isNotEmpty) {
                                                                            EventsRepository.getImageDetails(context, imageUrl: value.image.split('/').last).then((value) =>
                                                                                setState(() {
                                                                                  _imageData = value;
                                                                                }));
                                                                          }
                                                                        },
                                                                      );
                                                                    }
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(10),
                                                                  decoration: BoxDecoration(
                                                                      border: Border.all(
                                                                          color: AppColors
                                                                              .orange),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              100)),
                                                                  child:
                                                                      const Icon(
                                                                    Icons
                                                                        .camera_alt_outlined,
                                                                    color: AppColors
                                                                        .orange,
                                                                  ),
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  Navigator.pop(
                                                                      context);
                                                                  XFile? xFile =
                                                                      await ImagePicker().pickImage(
                                                                          source:
                                                                              ImageSource.gallery);
                                                                  File file =
                                                                      File(xFile!
                                                                          .path);
                                                                  // ignore: use_build_context_synchronously
                                                                  await EventsRepository.uploadImage(
                                                                          file,
                                                                          context)
                                                                      .then(
                                                                          (value) {
                                                                    if (value) {
                                                                      EventsRepository.showMyProfile(
                                                                              context)
                                                                          .then(
                                                                        (value) {
                                                                          setState(
                                                                              () {
                                                                            myProfile =
                                                                                value;
                                                                            loading =
                                                                                false;
                                                                          });
                                                                          if (value
                                                                              .image
                                                                              .isNotEmpty) {
                                                                            EventsRepository.getImageDetails(context, imageUrl: value.image.split('/').last).then((value) =>
                                                                                setState(() {
                                                                                  _imageData = value;
                                                                                }));
                                                                          }
                                                                        },
                                                                      );
                                                                    }
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(10),
                                                                  decoration: BoxDecoration(
                                                                      border: Border.all(
                                                                          color: AppColors
                                                                              .orange),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              100)),
                                                                  child:
                                                                      const Icon(
                                                                    Icons.image,
                                                                    color: AppColors
                                                                        .orange,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ));
                                            },
                                            child: const Text(
                                              'change profile picture',
                                              style: TextStyle(
                                                fontSize: 8,
                                                color: AppColors.orange,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          )
                                        : const SizedBox()
                                  ],
                                ),
                              ),
                              !widget.isSameUser
                                  ? myProfile.connectionStatus ==
                                          'NOT_CONNECTED'
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, top: 5),
                                          child: SizedBox(
                                              height: 20,
                                              width: 85,
                                              child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              AppColors.orange,
                                                          padding:
                                                              EdgeInsets.zero),
                                                  onPressed: () async {
                                                    await EventsRepository
                                                            .sendFriendRequest(
                                                                context:
                                                                    context,
                                                                friendId:
                                                                    myProfile
                                                                        .id)
                                                        .then((value) {
                                                      EventsRepository
                                                              .showMyProfile(
                                                                  context)
                                                          .then((userInfo) {
                                                        HomeRepository.getToken(
                                                                context,
                                                                userId:
                                                                    myProfile
                                                                        .id)
                                                            .then((value) {
                                                          HomeRepository
                                                              .sendNotifications(
                                                                  context,
                                                                  title:
                                                                      'Connection Request',
                                                                  body:
                                                                      '${userInfo.name} send you connection request',
                                                                  token: value);
                                                        });
                                                      });
                                                      return EventsRepository
                                                              .showParticipantProfile(
                                                                  context,
                                                                  profileId: widget
                                                                      .profileId)
                                                          .then((value) {
                                                        setState(() {
                                                          myProfile = value;
                                                        });
                                                      });
                                                    });
                                                  },
                                                  child:
                                                      const Text('+connect'))),
                                        )
                                      : myProfile.connectionStatus == 'SENT'
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, top: 5),
                                              child: SizedBox(
                                                  height: 20,
                                                  child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  AppColors
                                                                      .orange,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                horizontal: 5,
                                                              )),
                                                      onPressed: () async {
                                                        await EventsRepository
                                                                .removeFriendRequest(
                                                                    context,
                                                                    friendId:
                                                                        myProfile
                                                                            .id)
                                                            .then((value) =>
                                                                EventsRepository.showParticipantProfile(
                                                                        context,
                                                                        profileId:
                                                                            widget
                                                                                .profileId)
                                                                    .then(
                                                                        (value) {
                                                                  setState(() {
                                                                    myProfile =
                                                                        value;
                                                                  });
                                                                }));
                                                      },
                                                      child: const Text(
                                                          'Request Sent'))),
                                            )
                                          : myProfile.connectionStatus ==
                                                  'CONNECTED'
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10, top: 5),
                                                  child: SizedBox(
                                                      height: 20,
                                                      child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      AppColors
                                                                          .orange,
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .symmetric(
                                                                    horizontal:
                                                                        5,
                                                                  )),
                                                          onPressed: () async {
                                                            await EventsRepository
                                                                    .removeFriend(
                                                                        context,
                                                                        friendId:
                                                                            myProfile
                                                                                .id)
                                                                .then((value) =>
                                                                    EventsRepository.showParticipantProfile(
                                                                            context,
                                                                            profileId: widget
                                                                                .profileId)
                                                                        .then(
                                                                            (value) {
                                                                      setState(
                                                                          () {
                                                                        myProfile =
                                                                            value;
                                                                      });
                                                                    }));
                                                          },
                                                          child: const Text(
                                                              'Disconnect'))),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 4),
                                                  child: Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () async {
                                                          await EventsRepository
                                                                  .acceptFriendRequest(
                                                                      context,
                                                                      friendId:
                                                                          myProfile
                                                                              .id)
                                                              .then((value) {
                                                            EventsRepository
                                                                    .showMyProfile(
                                                                        context)
                                                                .then(
                                                                    (userInfo) {
                                                              HomeRepository.getToken(
                                                                      context,
                                                                      userId:
                                                                          myProfile
                                                                              .id)
                                                                  .then(
                                                                      (value) {
                                                                HomeRepository.sendNotifications(
                                                                    context,
                                                                    title:
                                                                        'Connection Request',
                                                                    body:
                                                                        '${userInfo.name} accept your connection request',
                                                                    token:
                                                                        value);
                                                              });
                                                            });
                                                            return EventsRepository
                                                                    .showParticipantProfile(
                                                                        context,
                                                                        profileId:
                                                                            widget.profileId)
                                                                .then((value) {
                                                              setState(() {
                                                                myProfile =
                                                                    value;
                                                              });
                                                            });
                                                          });
                                                        },
                                                        child: Image.asset(
                                                          Images.acceptAdd,
                                                          height: 25,
                                                          width: 25,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      GestureDetector(
                                                          onTap: () async {
                                                            await EventsRepository
                                                                    .rejectFriendRequest(
                                                                        context,
                                                                        friendId:
                                                                            myProfile
                                                                                .id)
                                                                .then((value) =>
                                                                    EventsRepository.showParticipantProfile(
                                                                            context,
                                                                            profileId: widget
                                                                                .profileId)
                                                                        .then(
                                                                            (value) {
                                                                      setState(
                                                                          () {
                                                                        myProfile =
                                                                            value;
                                                                      });
                                                                    }));
                                                          },
                                                          child: Image.asset(
                                                            Images.decline,
                                                            width: 25,
                                                            height: 25,
                                                          )),
                                                    ],
                                                  ),
                                                )
                                  : const SizedBox(),
                            ],
                          )
                        ],
                      ),
                    ),
                    myProfile.email.isEmpty && myProfile.mobileNo.isEmpty
                        ? const SizedBox()
                        : Container(
                            margin: EdgeInsets.only(
                              left: screenWidth * 0.025,
                              top: 25,
                            ),
                            width: screenWidth * 0.9,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Personal Info',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  width: screenWidth * 0.9,
                                  height: 5,
                                  color: AppColors.white,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.white,
                                  ),
                                  width: screenWidth * 0.9,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            'Email     ',
                                            style: TextStyle(
                                                color: AppColors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: screenWidth * 0.6,
                                            child: Text(
                                              myProfile.email,
                                              style: const TextStyle(
                                                  color: AppColors.orange,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            'phone   ',
                                            style: TextStyle(
                                                color: AppColors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            myProfile.mobileNo,
                                            style: const TextStyle(
                                                color: AppColors.orange,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                    Container(
                      margin: EdgeInsets.only(
                        top: safeAreaPadding,
                        left: screenWidth * 0.025,
                      ),
                      width: screenWidth * 0.9,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Professional Info',
                            style: TextStyle(
                                fontSize: 18,
                                color: AppColors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: screenWidth * 0.9,
                            height: 5,
                            color: AppColors.white,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.white,
                            ),
                            width: screenWidth * 0.9,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Company   ',
                                      style: TextStyle(
                                          color: AppColors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: screenWidth * 0.5,
                                      child: Text(
                                        myProfile.company,
                                        style: const TextStyle(
                                            color: AppColors.orange,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Job title        ',
                                      style: TextStyle(
                                          color: AppColors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: screenWidth * 0.5,
                                      child: Text(
                                        myProfile.jobTitle,
                                        style: const TextStyle(
                                            color: AppColors.orange,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Country        ',
                                      style: TextStyle(
                                          color: AppColors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: screenWidth * 0.5,
                                      child: Text(
                                        myProfile.country,
                                        style: const TextStyle(
                                            color: AppColors.orange,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Industry        ',
                                      style: TextStyle(
                                          color: AppColors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: screenWidth * 0.5,
                                      child: Text(
                                        myProfile.industry,
                                        style: const TextStyle(
                                            color: AppColors.orange,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
