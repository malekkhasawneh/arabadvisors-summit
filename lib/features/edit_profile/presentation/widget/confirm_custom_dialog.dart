import 'package:flutter/material.dart';
import 'package:provision/core/resources/utilities.dart';

import '../../../../../core/resources/app_colors.dart';
import '../../../../../core/resources/app_strings.dart';
import '../../../../../core/resources/images.dart';
import 'confirm_dialog_button.dart';

class ConfirmCustomDialog extends StatelessWidget {
  const ConfirmCustomDialog({Key? key, required this.onPressed})
      : super(key: key);
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth,
      height: screenHeight,
      color: const Color(0xff498CCA).withOpacity(0.7),
      child: Center(
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: AppColors.white,
            ),
            height: 300,
            width: screenWidth,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: Utilities.screenWidth!*0.78,
                    child: const Text(
                      AppStrings.updateInformation,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Icon(Icons.check_circle_outline,color: AppColors.orange,size: 100,),
                  const SizedBox(
                    height: 30,
                  ),
                  ConfirmDialogButton(
                    onPressed: onPressed,
                  )
                ],
              ),
            )),
      ),
    );
  }
}
