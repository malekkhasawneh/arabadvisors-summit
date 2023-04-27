import 'package:flutter/material.dart';
import 'package:provision/core/resources/app_colors.dart';
import 'package:provision/core/resources/app_strings.dart';

class ConfirmDialogButton extends StatelessWidget {
  const ConfirmDialogButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth * 0.6,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Text(
          AppStrings.ok,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
