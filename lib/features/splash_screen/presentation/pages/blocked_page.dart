import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provision/core/resources/images.dart';

import '../../../../core/resources/app_colors.dart';

class BlockedPage extends StatelessWidget {
  const BlockedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
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
          child: Lottie.asset(
            Images.serviceUnAvailable,
          ),
        ),
      ),
    );
  }
}
