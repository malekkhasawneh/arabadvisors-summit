import 'package:flutter/material.dart';
import 'package:provision/core/resources/app_colors.dart';

class TitleAndInputForSignUpWidget extends StatelessWidget {
  const TitleAndInputForSignUpWidget({
    Key? key,
    required this.controller,
    required this.labelName,
    required this.onTap,
    this.textInputType = TextInputType.name,
    this.suffix = const SizedBox(),
  }) : super(key: key);
  final TextEditingController controller;
  final String labelName;
  final void Function()? onTap;
  final TextInputType textInputType;
  final Widget suffix;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                  ),
                )),
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.white,
                ),
                width: MediaQuery.of(context).size.width * 0.9,
                height: 40,
                child: TextFormField(
                  enabled: false,
                  keyboardType: textInputType,
                  controller: controller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(top: 7, left: 5),
                    suffixIcon: suffix,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
