import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provision/core/resources/app_colors.dart';
import 'package:provision/core/resources/app_strings.dart';
import 'package:provision/features/event/data/repository/events_repository.dart';
import 'package:provision/features/event/presentation/cubit/event_cubit.dart';
import 'package:provision/features/event/presentation/page/user_profile_page.dart';

import '../../data/model/get_all_participants_model.dart';
import '../widget/user_info_widget.dart';

class ParticipantInEventPage extends StatefulWidget {
  const ParticipantInEventPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ParticipantInEventPage> createState() => _ParticipantInEventPageState();
}

class _ParticipantInEventPageState extends State<ParticipantInEventPage> {
  List<AllParticipantsModel> allParticipant = [];
  bool loading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<EventCubit>(context).setShowDeleteButton = false;
    EventsRepository.getAllParticipant().then(
      (value) => setState(
        () {
          allParticipant = value;
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
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<EventCubit, EventState>(
        builder: (context, state) {
          return SingleChildScrollView(
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
              child: Container(
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
                        AppStrings.eventPageTitle,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 35,
                      child: TextFormField(
                        controller: searchController,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            BlocProvider.of<EventCubit>(context)
                                .setShowDeleteButton = false;
                          } else {
                            BlocProvider.of<EventCubit>(context)
                                .setShowDeleteButton = true;
                          }
                          EventsRepository.searchParticipant(searchText: value)
                              .then((value) => setState(() {
                                    allParticipant = value;
                                  }));
                        },
                        decoration: InputDecoration(
                          suffixIcon: BlocProvider.of<EventCubit>(context)
                                  .getShowDeleteButton
                              ? IconButton(
                                  onPressed: () {
                                    BlocProvider.of<EventCubit>(context)
                                        .setShowDeleteButton = false;
                                    setState(() {
                                      searchController.clear();
                                    });
                                    EventsRepository.getAllParticipant().then(
                                      (value) => setState(
                                        () {
                                          allParticipant = value;
                                          loading = false;
                                        },
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.clear,
                                    color: AppColors.orange,
                                    size: 15,
                                  ),
                                )
                              : const SizedBox(),
                          prefixIcon: const Icon(
                            Icons.search,
                            size: 15,
                          ),
                          prefixIconColor: MaterialStateColor.resolveWith(
                              (states) => states.contains(MaterialState.focused)
                                  ? AppColors.orange
                                  : AppColors.grey),
                          prefixIconConstraints:
                              const BoxConstraints(minWidth: 20, maxHeight: 20),
                          contentPadding: const EdgeInsets.only(left: 5),
                          hintText: 'Search',
                          hintStyle: const TextStyle(
                              color: AppColors.grey, fontSize: 10),
                          filled: true,
                          fillColor: AppColors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: AppColors.grey, width: 0.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: AppColors.grey, width: 0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: AppColors.grey, width: 0.5),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: AppColors.grey, width: 0.5),
                          ),
                        ),
                      ),
                    ),
                    loading
                        ? Container(
                            margin: EdgeInsets.only(
                                top: screenHeight / 3, left: screenWidth / 3),
                            child: const CircularProgressIndicator(
                              color: AppColors.orange,
                            ),
                          )
                        : allParticipant.isEmpty
                            ? Container(
                                margin: EdgeInsets.only(
                                    top: screenHeight / 3,
                                    left: screenWidth / 3.5),
                                child: const Text(
                                  AppStrings.noData,
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : Container(
                                margin:
                                    EdgeInsets.only(top: screenHeight * 0.035),
                                height: screenHeight * 0.62,
                                child: ListView.builder(
                                    itemCount: allParticipant.length,
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      return UserInfoWidget(
                                        userName: allParticipant[index].name,
                                        companyName:
                                            allParticipant[index].company,
                                        imagePath: allParticipant[index].image,
                                        isStatusRecived: allParticipant[index]
                                                .connectionStatus ==
                                            'RECEIVED',
                                        acceptButton:
                                            allParticipant[index]
                                                        .connectionStatus ==
                                                    'sent'
                                                ? () {
                                                    EventsRepository
                                                            .removeFriendRequest(
                                                                friendId:
                                                                    allParticipant[
                                                                            index]
                                                                        .id)
                                                        .then(
                                                      (value) => EventsRepository
                                                              .getAllParticipant()
                                                          .then(
                                                        (value) => setState(
                                                          () {
                                                            allParticipant =
                                                                value;
                                                          },
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                : () async {
                                                    if (allParticipant[index]
                                                            .connectionStatus ==
                                                        'SENT') {
                                                      EventsRepository.removeFriendRequest(
                                                              friendId:
                                                                  allParticipant[
                                                                          index]
                                                                      .id)
                                                          .then(
                                                        (value) => EventsRepository
                                                                .getAllParticipant()
                                                            .then(
                                                          (value) => setState(
                                                            () {
                                                              allParticipant =
                                                                  value;
                                                            },
                                                          ),
                                                        ),
                                                      );
                                                    } else if (allParticipant[
                                                                index]
                                                            .connectionStatus ==
                                                        'NOT_CONNECTED') {
                                                      EventsRepository.sendFriendRequest(
                                                              friendId:
                                                                  allParticipant[
                                                                          index]
                                                                      .id)
                                                          .then(
                                                        (value) => EventsRepository
                                                                .getAllParticipant()
                                                            .then(
                                                          (value) => setState(
                                                            () {
                                                              allParticipant =
                                                                  value;
                                                            },
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                        acceptFriend: () async {
                                          await EventsRepository
                                                  .acceptFriendRequest(
                                                      friendId:
                                                          allParticipant[index]
                                                              .id)
                                              .then(
                                            (value) => EventsRepository
                                                    .getAllParticipant()
                                                .then(
                                              (value) => setState(
                                                () {
                                                  allParticipant = value;
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                        declineFriend: () async {
                                          await EventsRepository
                                                  .rejectFriendRequest(
                                                      friendId:
                                                          allParticipant[index]
                                                              .id)
                                              .then((value) => EventsRepository
                                                          .getAllParticipant()
                                                      .then(
                                                    (value) => setState(
                                                      () {
                                                        allParticipant = value;
                                                      },
                                                    ),
                                                  ));
                                        },
                                        buttonText:
                                            // ignore: unrelated_type_equality_checks
                                            allParticipant[index]
                                                        .connectionStatus ==
                                                    'NOT_CONNECTED'
                                                ? '+connect'
                                                // ignore: unrelated_type_equality_checks
                                                : allParticipant[index]
                                                            .connectionStatus ==
                                                        'CONNECTED'
                                                    ? 'connected'
                                                    : 'sent',
                                        tapOnListTile: () async {
                                          bool response = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => ProfilePage(
                                                        profileId:
                                                            allParticipant[
                                                                    index]
                                                                .id,
                                                        isSameUser: false,
                                                      )));
                                          if (response) {
                                            setState(() {
                                              loading = true;
                                            });
                                            EventsRepository.getAllParticipant()
                                                .then(
                                              (value) => setState(
                                                () {
                                                  allParticipant = value;
                                                  loading = false;
                                                },
                                              ),
                                            );
                                          }
                                        },
                                      );
                                    }),
                              ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
