import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provision/core/resources/app_colors.dart';
import 'package:provision/core/resources/images.dart';
import 'package:provision/features/auth/sign_in/presentation/page/sign_in_page.dart';
import 'package:provision/features/connection/presentation/page/my_connection_page.dart';
import 'package:provision/features/edit_profile/presentation/page/edit_user_info.dart';
import 'package:provision/features/event/presentation/page/user_profile_page.dart';
import 'package:provision/features/home/data/repository/home_repository.dart';
import 'package:provision/features/home/presentation/page/agenda_page.dart';
import 'package:provision/features/meetings/presentation/page/meeting_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/resources/app_strings.dart';
import '../../alert/presentation/page/alert_page.dart';
import '../../contact_us/presentation/contact_us.dart';
import '../../event/presentation/page/participant_in_event_page.dart';
import '../../home/presentation/page/home_page.dart';
import '../../voting/presentation/page/voting_page.dart';

class MainBottomSheet extends StatefulWidget {
  const MainBottomSheet({Key? key}) : super(key: key);

  @override
  State<MainBottomSheet> createState() => _MainBottomSheetState();
}

class _MainBottomSheetState extends State<MainBottomSheet> {
  int currentIndex = 0;
  bool editProfilePage = false;
  bool connectionPage = false;
  bool meetingsPage = false;
  bool contactUs = false;
  bool agenda = false;
  bool vote = false;
  int userID = 0;

  @override
  void initState() {
    getUserId().then((value) => setState(() {
          userID = value;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      bottom: false,
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: editProfilePage ||
                    connectionPage ||
                    meetingsPage ||
                    contactUs ||
                    agenda ||
                    vote
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        currentIndex = 0;
                        editProfilePage = false;
                        connectionPage = false;
                        meetingsPage = false;
                        contactUs = false;
                        agenda = false;
                        vote = false;
                      });
                    },
                    icon: Icon(Platform.isAndroid
                        ? Icons.arrow_back
                        : Icons.arrow_back_ios),
                  )
                : IconButton(
                    onPressed: () {
                      HomeRepository.goToUrl(
                        context,
                        url: AppStrings.eventUrl,
                      );
                    },
                    icon: Image.asset(
                      Images.homeLeadingLogo,
                    ),
                  ),
            backgroundColor: AppColors.transparent,
            elevation: 0,
            actions: [
              Builder(builder: (context) {
                return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: Image.asset(
                    Images.menu,
                    height: 30,
                    width: 30,
                    fit: BoxFit.fill,
                  ),
                );
              })
            ],
          ),
          endDrawer: Container(
            color: AppColors.blue,
            width: screenWidth * 0.8,
            height: screenHeight,
            child: Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.01,
                        horizontal: screenWidth * 0.03),
                    child: Container(
                      height: screenHeight * 0.075,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        //color: select?WHITE_V1:MAIN_COLOR,
                      ),
                      padding: EdgeInsets.all(screenWidth * 0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            Images.userInfo,
                            width: screenWidth * 0.1,
                            height: screenWidth * 0.1,
                            fit: BoxFit.fill,
                          ),
                          SizedBox(width: screenWidth * 0.05),
                          Builder(builder: (context) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  editProfilePage = true;
                                  meetingsPage = false;
                                  connectionPage = false;
                                  contactUs = false;
                                  agenda = false;
                                  vote = false;
                                });
                                Scaffold.of(context).closeEndDrawer();
                              },
                              child: Text(
                                'User Informations',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.033,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.01,
                        horizontal: screenWidth * 0.03),
                    child: Container(
                      height: screenHeight * 0.075,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        //color: select?WHITE_V1:MAIN_COLOR,
                      ),
                      padding: EdgeInsets.all(screenWidth * 0.01),
                      child: Builder(builder: (context) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              editProfilePage = false;
                              connectionPage = true;
                              meetingsPage = false;
                              contactUs = false;
                              agenda = false;
                              vote = false;
                            });
                            Scaffold.of(context).closeEndDrawer();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                Images.connections,
                                width: screenWidth * 0.1,
                                height: screenWidth * 0.1,
                                fit: BoxFit.fill,
                              ),
                              SizedBox(width: screenWidth * 0.05),
                              Text(
                                'Connections',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.033,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.01,
                        horizontal: screenWidth * 0.03),
                    child: Container(
                      height: screenHeight * 0.075,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        //color: select?WHITE_V1:MAIN_COLOR,
                      ),
                      padding: EdgeInsets.all(screenWidth * 0.01),
                      child: Builder(builder: (context) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              editProfilePage = false;
                              connectionPage = false;
                              meetingsPage = false;
                              contactUs = false;
                              agenda = true;
                              vote = false;
                            });
                            Scaffold.of(context).closeEndDrawer();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.calendar_month_outlined,
                                size: screenWidth * 0.1,
                                color: AppColors.white,
                              ),
                              SizedBox(width: screenWidth * 0.05),
                              Text(
                                'Agenda',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.033,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.01,
                        horizontal: screenWidth * 0.03),
                    child: Builder(builder: (context) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            editProfilePage = false;
                            connectionPage = false;
                            meetingsPage = true;
                            contactUs = false;
                            agenda = false;
                            vote = false;
                          });
                          Scaffold.of(context).closeEndDrawer();
                        },
                        child: Container(
                          height: screenHeight * 0.075,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            //color: select?WHITE_V1:MAIN_COLOR,
                          ),
                          padding: EdgeInsets.all(screenWidth * 0.01),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                Images.meetings,
                                width: screenWidth * 0.1,
                                height: screenWidth * 0.1,
                                fit: BoxFit.fill,
                              ),
                              SizedBox(width: screenWidth * 0.05),
                              Text(
                                'Meetings',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.033,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.01,
                        horizontal: screenWidth * 0.03),
                    child: Builder(builder: (context) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            editProfilePage = false;
                            connectionPage = false;
                            meetingsPage = false;
                            contactUs = true;
                            agenda = false;
                            vote = false;
                          });
                          Scaffold.of(context).closeEndDrawer();
                        },
                        child: Container(
                          height: screenHeight * 0.075,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            //color: select?WHITE_V1:MAIN_COLOR,
                          ),
                          padding: EdgeInsets.all(screenWidth * 0.01),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.messenger,
                                size: screenWidth * 0.09,
                                color: AppColors.white,
                              ),
                              SizedBox(width: screenWidth * 0.05),
                              Text(
                                'Contact Us',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.033,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.01,
                        horizontal: screenWidth * 0.03),
                    child: GestureDetector(
                      onTap: () async {
                        await HomeRepository.goToFeedBack(
                          context,
                        );
                      },
                      child: Container(
                        height: screenHeight * 0.075,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          //color: select?WHITE_V1:MAIN_COLOR,
                        ),
                        padding: EdgeInsets.all(screenWidth * 0.01),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.content_paste,
                              size: screenWidth * 0.09,
                              color: AppColors.white,
                            ),
                            SizedBox(width: screenWidth * 0.05),
                            Text(
                              'FeedBack',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.033,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.01,
                        horizontal: screenWidth * 0.03),
                    child: Builder(builder: (context) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            editProfilePage = false;
                            connectionPage = false;
                            meetingsPage = false;
                            contactUs = false;
                            agenda = false;
                            vote = true;
                          });
                          Scaffold.of(context).closeEndDrawer();
                        },
                        child: Container(
                          height: screenHeight * 0.075,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            //color: select?WHITE_V1:MAIN_COLOR,
                          ),
                          padding: EdgeInsets.all(screenWidth * 0.01),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.how_to_vote_outlined,
                                size: screenWidth * 0.09,
                                color: AppColors.white,
                              ),
                              SizedBox(width: screenWidth * 0.05),
                              Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Text(
                                  'Vote',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: screenWidth * 0.033,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                  GestureDetector(
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.remove('id');
                      prefs.remove('token');
                      prefs.remove('userLogin');
                      prefs.remove('loginDate');

                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => SignInPage()));
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.01,
                          horizontal: screenWidth * 0.03),
                      child: Container(
                        height: screenHeight * 0.075,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          //color: select?WHITE_V1:MAIN_COLOR,
                        ),
                        padding: EdgeInsets.all(screenWidth * 0.01),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              Images.logout,
                              width: screenWidth * 0.1,
                              height: screenWidth * 0.1,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(width: screenWidth * 0.05),
                            Text(
                              'Logout',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.033,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: pages(
            getToEdit: editProfilePage,
            goToConnection: connectionPage,
            goToMeetingsPage: meetingsPage,
            goToContactUs: contactUs,
            goToAgenda: agenda,
            goToVote: vote
          )[currentIndex],
          bottomNavigationBar: SizedBox(
            height: 55 + MediaQuery.of(context).padding.bottom,
            child: BottomNavigationBar(
              backgroundColor: AppColors.skyBlue.withOpacity(0.6),
              iconSize: screenWidth * 0.007,
              type: BottomNavigationBarType.fixed,
              currentIndex: currentIndex,
              selectedItemColor: AppColors.orange,
              elevation: 0,
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                  editProfilePage = false;
                  connectionPage = false;
                  meetingsPage = false;
                  contactUs = false;
                  agenda = false;
                  vote = false;
                });
              },
              unselectedLabelStyle: const TextStyle(
                fontSize: 0,
                height: 0.0,
              ),
              selectedLabelStyle: const TextStyle(
                fontSize: 0,
                height: 0.0,
              ),
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                      size: 25,
                    ),
                    label: ''),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.explore,
                      size: 25,
                    ),
                    label: ''),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.public,
                      size: 25,
                    ),
                    label: ''),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person,
                      size: 25,
                    ),
                    label: ''),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool signOut = false;

  Future<void> logOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var request = await http.post(
        Uri.parse(
          'https://vmi1258605.contaboserver.net/agg/api/v1/auth/logout/${preferences.getInt('id')}',
        ),
        headers: requestHeaders,
        body: jsonEncode({"id": preferences.getInt('id')}));
    log('======================== Here ${request.statusCode}');
    if (request.statusCode == 200) {
      Map<String, dynamic> response = json.decode(request.body);
      if (response['statusCode'] == 2) {
        setState(() {
          signOut = true;
        });
      }
    }
  }

  Future<int> getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt('id') ?? 0;
  }

  List<Widget> pages({
    required bool getToEdit,
    required bool goToConnection,
    required bool goToMeetingsPage,
    required bool goToContactUs,
    required bool goToAgenda,
    required bool goToVote,
  }) {
    return [
      getToEdit
          ? EditUserInfo()
          : goToConnection
              ? const MyConnectionPage()
              : goToMeetingsPage
                  ? MeetingPage(
                      userId: userID,
                      meetingId: 0,
                    )
                  : goToContactUs
                      ? const ContactUs()
                      : goToAgenda
                          ? const AgendaPage()
                          : goToVote
                              ? const VotingPage()
                              : const HomePage(),
      getToEdit
          ? EditUserInfo()
          : goToConnection
              ? const MyConnectionPage()
              : goToMeetingsPage
                  ? MeetingPage(
                      meetingId: 0,
                      userId: userID,
                    )
                  : goToContactUs
                      ? const ContactUs()
                      : goToAgenda
                          ? const AgendaPage()
                          : goToVote
                              ? const VotingPage()
                              : const ParticipantInEventPage(),
      getToEdit
          ? EditUserInfo()
          : goToConnection
              ? const MyConnectionPage()
              : goToMeetingsPage
                  ? MeetingPage(
                      meetingId: 0,
                      userId: userID,
                    )
                  : goToContactUs
                      ? const ContactUs()
                      : goToAgenda
                          ? const AgendaPage()
                          : goToVote
                              ? const VotingPage()
                              : AlertPage(
                                  userId: userID,
                                ),
      getToEdit
          ? EditUserInfo()
          : goToConnection
              ? const MyConnectionPage()
              : goToMeetingsPage
                  ? MeetingPage(
                      meetingId: 0,
                      userId: userID,
                    )
                  : goToContactUs
                      ? const ContactUs()
                      : goToAgenda
                          ? const AgendaPage()
                          : goToVote
                              ? const VotingPage()
                              : ProfilePage(
                                  profileId: 0,
                                  isSameUser: true,
                                )
    ];
  }
}
