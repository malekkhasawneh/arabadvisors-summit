import 'package:flutter/material.dart';
import 'package:provision/core/resources/app_colors.dart';

import '../../../../core/resources/images.dart';
import 'accept_or_reject_buttons.dart';

class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({
    Key? key,
    required this.companyName,
    required this.userName,
    required this.acceptButton,
    required this.rejectButton,
  }) : super(key: key);
  final String userName;
  final String companyName;
  final void Function() acceptButton;
  final void Function() rejectButton;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.white),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(Images.defaultUserImage),
                ),
              ),
              title: Text(
                userName,
                style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              subtitle: Text(
                'Work @$companyName',
                style: const TextStyle(
                  color: AppColors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          AcceptOrRejectButton(
            acceptButton: acceptButton,
            rejectButton: rejectButton,
          ),
        ],
      ),
    );
  }
}
