import 'package:flutter/material.dart';
import 'package:provision/core/resources/app_colors.dart';
import 'package:provision/core/resources/app_strings.dart';

class ConnectButton extends StatelessWidget {
  const ConnectButton({
    Key? key,
    required this.acceptButton,
  }) : super(key: key);
  final void Function() acceptButton;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(
            top: 10,
          ),
          height: 50,
          color: AppColors.grey,
          width: 1,
        ),
        Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20, left: 10, bottom: 10),
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.orange,
                border: Border.all(
                  width: 1,
                  color: AppColors.orange,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextButton(
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  onPressed: acceptButton,
                  child: const Text(
                    AppStrings.message,
                    style: TextStyle(color: AppColors.white, fontSize: 6),
                  )),
            ),
          ],
        )
      ],
    );
  }
}
