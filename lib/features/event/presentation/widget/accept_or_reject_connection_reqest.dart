import 'package:flutter/material.dart';
import 'package:provision/core/resources/images.dart';

import '../../../../core/resources/app_colors.dart';

class AcceptOrRejectConnectionButton extends StatelessWidget {
   AcceptOrRejectConnectionButton({
    Key? key,
    required this.acceptFriend,
    required this.declineFriend,
  }) : super(key: key);
  void Function()? acceptFriend;
  void Function()? declineFriend;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 50,
          color: AppColors.white,
          width: 1,
        ),
        Container(
          margin: const EdgeInsets.only(top: 10, left: 10, bottom: 10),
        ),
        GestureDetector(
          onTap: acceptFriend,
          child: Image.asset(
            Images.acceptAdd,
            width: 25,
            height: 25,
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        GestureDetector(
          onTap: declineFriend,
          child: Image.asset(
            Images.decline,
            width: 25,
            height: 25,
          ),
        ),
      ],
    );
  }
}
