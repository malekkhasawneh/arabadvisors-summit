import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provision/core/resources/images.dart';
import 'package:provision/core/resources/utilities.dart';

class AppLogoWidget extends StatelessWidget {
  const AppLogoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: SvgPicture.asset(
        Images.appSvgLogo,
        width: Utilities.screenWidth! * 0.7,
        height: Utilities.screenHeight! * 0.17,
        fit: BoxFit.fill,
      ),
    );
  }
}
