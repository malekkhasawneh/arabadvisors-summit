import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provision/core/resources/app_colors.dart';
import 'package:provision/core/resources/app_strings.dart';
import 'package:provision/core/widgets/no_internet_widget.dart';
import 'package:provision/features/admin/data/model/pending_users.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/resources/images.dart';
import '../../../auth/sign_in/presentation/page/sign_in_page.dart';
import '../widget/user_info_widget.dart';

class AdminHomePage extends StatefulWidget {
  AdminHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  void initState() {
    getAllIndustry().then((value) => setState(() {
          allUsersList = value;
          loading = false;
        }));
    super.initState();
  }

  AppBar appBar = AppBar(
    backgroundColor: AppColors.transparent,
    elevation: 0,
    actions: [
      TextButton(
        onPressed: () {},
        child: Image.asset(
          Images.signOut,
          height: 30,
          width: 30,
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double appBarHeight = appBar.preferredSize.height;
    double safePadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () async {
              SharedPreferences pref = await SharedPreferences.getInstance();
              pref.remove('id');
              pref.remove('token');
              // ignore: use_build_context_synchronously
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => SignInPage()));
              // SharedPreferences pref = await SharedPreferences.getInstance();
              // await logOut(userId: widget.id).then((_) {
              //
              // });
            },
            child: Image.asset(
              Images.signOut,
              height: 30,
              width: 30,
            ),
          ),
        ],
      ),
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
        child: Container(
          margin: EdgeInsets.only(
              top: appBarHeight + safePadding,
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
              bottom: 0),
          width: screenWidth * 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: screenWidth * 0.6,
                child: const Text(
                  AppStrings.adminHomeHint,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                    fontSize: 22,
                  ),
                ),
              ),
              loading
                  ? Padding(
                      padding: EdgeInsets.only(
                          top: screenHeight / 5 + (appBarHeight + safePadding)),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.orange,
                        ),
                      ),
                    )
                  : allUsersList.isEmpty
                      ? Padding(
                          padding: EdgeInsets.only(
                              top: screenHeight / 5 +
                                  (appBarHeight + safePadding)),
                          child: const Center(
                            child: Text(
                              'There Are No Data',
                              style: TextStyle(color: AppColors.white),
                            ),
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.only(top: screenHeight * 0.03),
                          height: screenHeight * 0.75,
                          child: ListView.builder(
                              itemCount: allUsersList.length,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                return UserInfoWidget(
                                  userName: allUsersList[index].name,
                                  companyName: allUsersList[index].company,
                                  acceptButton: () async {
                                    if (await checkInternetConnection()) {
                                      acceptUser(
                                          userId: allUsersList[index].id);
                                    } else {
                                      // ignore: use_build_context_synchronously
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  NoInternetConnectionWidget()));
                                    }
                                  },
                                  rejectButton: () async {
                                    if (await checkInternetConnection()) {
                                      rejectUser(
                                          userId: allUsersList[index].id);
                                    } else {
                                      // ignore: use_build_context_synchronously
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  NoInternetConnectionWidget()));
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
  }

  List<GetAllPendingUsers> allUsersList = [];
  bool loading = true;

  Map<String, String> requestHeaders({required String token}) {
    return {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
  }

  Future<List<GetAllPendingUsers>> getAllIndustry() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var post = await http.get(
      Uri.parse(
          'https://vmi1258605.contaboserver.net/agg/api/v1/managers/getAllPendingUsers'),
      headers: requestHeaders(token: preferences.getString('token') ?? ''),
    );
    if (post.statusCode == 200) {
      log('================================ post.statusCode ${post.body}');

      List<GetAllPendingUsers> pendingUsers = json
          .decode(post.body)
          .map<GetAllPendingUsers>((e) => GetAllPendingUsers.fromJson(e))
          .toList();
      return pendingUsers;
    } else {
      log('========================= Failed');
      throw Exception();
    }
  }

  Future<void> acceptUser({
    required int userId,
  }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final sendFriendRequest = await http.patch(
        Uri.parse(
            'https://vmi1258605.contaboserver.net/agg/api/v1/managers/approveUser?userId=$userId'),
        headers: requestHeaders(token: preferences.getString('token') ?? ''),
        body: json.encode({"userId": userId}));
    if (sendFriendRequest.statusCode == 200) {
      getAllIndustry().then((value) => setState(() {
            allUsersList = value;
            loading = false;
          }));
      log('Ok');
    } else {
      throw Exception();
    }
  }

  Future<void> rejectUser({required int userId}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var post = await http.patch(
        Uri.parse(
            'https://vmi1258605.contaboserver.net/agg/api/v1/managers/declineUser?userId=$userId'),
        headers: requestHeaders(token: preferences.getString('token') ?? ''),
        body: jsonEncode({"userId": userId}));
    if (post.statusCode == 200) {
      getAllIndustry().then((value) => setState(() {
            allUsersList = value;
            loading = false;
          }));
    } else {
      log('========================= Failed');
    }
  }

  bool signOut = false;

  Future<void> logOut({required int userId}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var request = await http.post(
        Uri.parse(
          'https://vmi1258605.contaboserver.net/agg/api/v1/auth/logout/352',
        ),
        headers: requestHeaders(token: preferences.getString('token') ?? ''),
        body: jsonEncode({"id": userId}));
    if (request.statusCode == 200) {
      Map<String, dynamic> response = json.decode(request.body);
      if (response['statusCode'] == 2) {
        setState(() {
          signOut = true;
        });
      }
    }
  }

  Future<bool> checkInternetConnection() async {
    InternetConnectionChecker internetConnectionChecker =
        InternetConnectionChecker();
    return await internetConnectionChecker.hasConnection;
  }
}
