import 'package:flutter/material.dart';
import 'package:provision/core/resources/app_colors.dart';
import 'package:provision/core/resources/app_strings.dart';

class TitleAndInputForSignUpWidget extends StatelessWidget {
  const TitleAndInputForSignUpWidget({
    Key? key,
    required this.controller,
    required this.labelName,
    this.hiddenText = false,
    this.forgetPassword = false,
    this.description = '',
    this.textInputType = TextInputType.name,
    this.suffix = const SizedBox(),
  }) : super(key: key);
  final TextEditingController controller;
  final String labelName;
  final bool hiddenText;
  final bool forgetPassword;
  final String description;
  final TextInputType textInputType;
  final Widget suffix;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: screenHeight * 0.02,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: RichText(
                text: TextSpan(
                    text: labelName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                    children: [
                      const TextSpan(
                        text: '*',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.red,
                        ),
                      ),
                      TextSpan(
                        text: description,
                        style: const TextStyle(
                            color: AppColors.white, fontSize: 12),
                      ),
                    ]),
              )),
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.white,
              ),
              width: MediaQuery.of(context).size.width * 0.85,
              height: 40,
              child: TextFormField(
                keyboardType: textInputType,
                obscureText: hiddenText,
                controller: controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.only(top: 7, left: 5, right: -5),
                  suffixIcon: suffix,
                ),
              )),
          forgetPassword
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 7, horizontal: 5),
                  child: Text(
                    AppStrings.forgetPassword,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
