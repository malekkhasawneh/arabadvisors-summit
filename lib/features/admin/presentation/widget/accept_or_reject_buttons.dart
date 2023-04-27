import 'package:flutter/material.dart';
import 'package:provision/core/resources/app_colors.dart';
import 'package:provision/core/resources/app_strings.dart';

class AcceptOrRejectButton extends StatelessWidget {
  const AcceptOrRejectButton({
    Key? key,
    required this.rejectButton,
    required this.acceptButton,
  }) : super(key: key);
  final void Function() acceptButton;
  final void Function() rejectButton;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 80,
          color: AppColors.white,
          width: 1,
        ),
        Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10, bottom: 10),
              height: 30,
              decoration: BoxDecoration(
                  color: AppColors.orange,
                  border: Border.all(
                    width: 1,
                    color: AppColors.orange,
                  ),
                  borderRadius: BorderRadius.circular(5)),
              child: TextButton(
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  onPressed: acceptButton,
                  child: const Text(
                    AppStrings.accept,
                    style: TextStyle(
                      color: AppColors.white,
                    ),
                  )),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10),
              height: 30,
              decoration: BoxDecoration(
                  color: AppColors.red,
                  border: Border.all(
                    width: 1,
                    color: AppColors.red,
                  ),
                  borderRadius: BorderRadius.circular(5)),
              child: TextButton(
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  onPressed: rejectButton,
                  child: const Text(
                    AppStrings.reject,
                    style: TextStyle(
                      color: AppColors.white,
                    ),
                  )),
            )
          ],
        )
      ],
    );
  }
}
