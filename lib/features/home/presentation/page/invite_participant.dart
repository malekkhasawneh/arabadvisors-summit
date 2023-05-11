import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provision/core/resources/app_colors.dart';
import 'package:provision/core/resources/app_strings.dart';
import 'package:provision/core/resources/dimentions.dart';
import 'package:provision/features/home/data/repository/home_repository.dart';

import '../../../event/data/model/get_all_participants_model.dart';
import '../widget/user_info_widget.dart';

class InviteParticipant extends StatefulWidget {
  const InviteParticipant({
    Key? key,
  }) : super(key: key);

  @override
  State<InviteParticipant> createState() => _InviteParticipantState();
}

class _InviteParticipantState extends State<InviteParticipant> {
  Map<AllParticipantsModel, bool> allFriends = {};
  bool loading = true;
  int selectedUserId = 0;

  @override
  void initState() {
    HomeRepository.getAllFriends(
      context,
    ).then(
      (value) => setState(
        () {
          allFriends = value;
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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(
                context,
                AllParticipantsModel(
                    id: 0,
                    name: '',
                    email: '',
                    mobileNo: '',
                    company: '',
                    country: '',
                    jobTitle: '',
                    industry: '',
                    connectionStatus: '',
                    image: '',
                    chatId: 0,
                    isModerator: false));
          },
          icon: Icon(
            Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
          ),
        ),
        backgroundColor: AppColors.transparent,
        elevation: 0,
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
          child: Container(
            margin: EdgeInsets.only(
                top: safePadding + defaultAppBarHeight,
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
                    AppStrings.inviteTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: screenWidth,
                  height: 0.8,
                  color: AppColors.white,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 35,
                  child: allFriends.isNotEmpty
                      ? TextFormField(
                          onChanged: (value) {
                            HomeRepository.getAllFriends(context,
                                    searchText: value)
                                .then(
                              (value) => setState(
                                () {
                                  allFriends = value;
                                  loading = false;
                                },
                              ),
                            );
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.search,
                              size: 15,
                            ),
                            prefixIconColor: MaterialStateColor.resolveWith(
                                (states) =>
                                    states.contains(MaterialState.focused)
                                        ? AppColors.orange
                                        : AppColors.grey),
                            prefixIconConstraints: const BoxConstraints(
                                minWidth: 20, maxHeight: 20),
                            contentPadding: const EdgeInsets.only(left: 5),
                            hintText: 'Search',
                            hintStyle: const TextStyle(
                                color: AppColors.grey, fontSize: 10),
                            filled: true,
                            fillColor: AppColors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                  color: AppColors.grey, width: 0.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: AppColors.grey, width: 0.5),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                  color: AppColors.grey, width: 0.5),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                  color: AppColors.grey, width: 0.5),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ),
                loading
                    ? Container(
                        margin: EdgeInsets.only(
                            top: screenHeight / 3, left: screenWidth / 3),
                        child: const CircularProgressIndicator(
                          color: AppColors.orange,
                        ),
                      )
                    : allFriends.isEmpty
                        ? Container(
                            margin: EdgeInsets.only(
                                top: screenHeight / 3, left: screenWidth / 3.5),
                            child: const Text(
                              AppStrings.noData,
                              style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.only(top: screenHeight * 0.035),
                            height: screenHeight * 0.6,
                            child: ListView.builder(
                                itemCount: allFriends.length,
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  return UserInfoWidget(
                                    userName:
                                        allFriends.keys.elementAt(index).name,
                                    companyName: allFriends.keys
                                        .elementAt(index)
                                        .company,
                                    imagePath:
                                        allFriends.keys.elementAt(index).image,
                                    acceptButton: (value) {
                                      setState(() {
                                        if (value!) {
                                          selectedUserId = allFriends.keys
                                              .elementAt(index)
                                              .id;
                                        } else {
                                          selectedUserId = 0;
                                        }
                                        allFriends.forEach((key, value) {
                                          allFriends[key] = false;
                                        });
                                        allFriends[allFriends.keys
                                            .elementAt(index)] = value;
                                      });
                                    },
                                    value: allFriends.values.elementAt(index),
                                  );
                                }),
                          ),
                loading || allFriends.isEmpty
                    ? const SizedBox()
                    : Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(
                                  context,
                                  allFriends.keys.firstWhere((element) =>
                                      element.id == selectedUserId));
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.orange),
                            child: const Text(
                              'Select',
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
      ),
    );
  }
}
