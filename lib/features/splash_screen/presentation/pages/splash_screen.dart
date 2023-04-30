import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provision/core/resources/app_colors.dart';
import 'package:provision/core/resources/images.dart';
import 'package:provision/features/auth/sign_in/presentation/page/sign_in_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../bottom_navigation/presentation/page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3)).then(
      (value) async {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        bool isLogin = preferences.getBool('userLogin') ?? false;
        int id = preferences.getInt('id') ?? 0;
        String token = preferences.getString('token') ?? '';
        DateTime loginDate = DateTime.parse(
            preferences.getString('loginDate') ?? DateTime.now().toString());
        bool isSessionEnd =
            loginDate.difference(DateTime.now()).inDays.abs() >= 60;
        if (id == 0 || id == null || isSessionEnd) {
          preferences.remove('id');
          preferences.remove('token');
          preferences.remove('userLogin');
          // ignore: use_build_context_synchronously
          return Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SignInPage(),
            ),
          );
        } else {
          // ignore: use_build_context_synchronously
          return Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const MainBottomSheet(),
            ),
          );
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return  SafeArea(bottom: false,
      child: Scaffold(
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
          child: Center(
            child: SvgPicture.asset(
              Images.splashSvgLogo,
              width: screenWidth * 0.8,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
