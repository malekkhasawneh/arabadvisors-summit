import 'package:flutter/material.dart';
import 'package:provision/core/resources/images.dart';
import 'package:provision/features/auth/sign_in/data/repository/repository.dart';

import '../../../../../core/resources/app_colors.dart';
import '../../../../../core/resources/app_strings.dart';
import '../../../../../core/resources/utilities.dart';

class ProVisionLogoWidget extends StatelessWidget {
  const ProVisionLogoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: Utilities.screenHeight! * 0.007,
              horizontal: Utilities.screenWidth! * 0.005),
          child: Text(
            AppStrings.poweredBy,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.white,
              fontSize: Utilities.screenWidth! * 0.031,
            ),
          ),
        ),
        GestureDetector(
            onTap: () async {
              await SignInRepository.goToUrl();
            },
            child: Image.asset(Images.provisionLogo,
                width: Utilities.screenWidth! * 0.35)),
      ],
    );
  }
}
