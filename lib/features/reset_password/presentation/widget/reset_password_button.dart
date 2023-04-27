import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provision/core/resources/app_colors.dart';
import 'package:provision/core/resources/app_strings.dart';
import 'package:provision/core/resources/images.dart';

import '../../../../core/resources/utilities.dart';

class ResetPasswordButton extends StatelessWidget {
  const ResetPasswordButton(
      {Key? key,
      required this.resetPassword,
      required this.isLoading,
      required this.isSuccess})
      : super(key: key);
  final void Function() resetPassword;
  final bool isLoading;
  final bool isSuccess;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Utilities.screenWidth! * 0.4,
      child: ElevatedButton(
        onPressed: resetPassword,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 15,
                width: 15,
                child: CircularProgressIndicator(
                  color: AppColors.white,
                ),
              )
            : isLoading && isSuccess
                ? SizedBox(
                    height: 15,
                    width: 15,
                    child: Lottie.asset(Images.doneSuccessfully),
                  )
                : const Text(
                    AppStrings.next,
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
      ),
    );
  }
}
