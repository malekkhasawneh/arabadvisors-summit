import 'package:flutter/material.dart';
import 'package:provision/core/resources/app_colors.dart';
import 'package:provision/core/resources/app_strings.dart';
import 'package:provision/core/resources/utilities.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({Key? key, required this.signIn}) : super(key: key);
  final void Function() signIn;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Utilities.screenWidth! * 0.4,
      child: ElevatedButton(
        onPressed: signIn,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: const Text(
          AppStrings.signIn,
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
