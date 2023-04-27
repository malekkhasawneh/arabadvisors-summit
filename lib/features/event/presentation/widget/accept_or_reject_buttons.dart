import 'package:flutter/material.dart';
import 'package:provision/core/resources/app_colors.dart';

class AcceptOrRejectButton extends StatelessWidget {
  const AcceptOrRejectButton({
    Key? key,
    required this.acceptButton,
    required this.buttonText,
  }) : super(key: key);
  final void Function() acceptButton;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 50,
          color: AppColors.white,
          width: 1,
        ),
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: 10,
                  left: (buttonText == 'connected' ? 10 : 15),
                  bottom: 10),
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
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                      color: AppColors.white,
                    ),
                  )),
            ),
          ],
        )
      ],
    );
  }
}
