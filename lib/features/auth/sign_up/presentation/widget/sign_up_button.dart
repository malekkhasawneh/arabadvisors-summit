import 'package:flutter/material.dart';
import 'package:provision/core/resources/app_colors.dart';
import 'package:provision/core/resources/app_strings.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({Key? key, required this.signUp}) : super(key: key);
  final void Function() signUp;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Padding(
        padding: EdgeInsets.only(
          right: screenWidth * 0.075,
        ),
        child: SizedBox(
          width: screenWidth * 0.4,
          child: ElevatedButton(
            onPressed: signUp,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: const Text(
              AppStrings.signUp,
              style: TextStyle(
                  color: AppColors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
