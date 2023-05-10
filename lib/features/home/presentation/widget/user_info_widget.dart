import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provision/core/resources/app_colors.dart';

import '../../../../core/resources/images.dart';
import '../../../event/data/repository/events_repository.dart';
import '../widget/select_user_check_box.dart';

class UserInfoWidget extends StatefulWidget {
  UserInfoWidget({
    Key? key,
    required this.companyName,
    required this.userName,
    required this.acceptButton,
    required this.imagePath,
    required this.value,
  }) : super(key: key);
  final String userName;
  final String companyName;
  final void Function(bool?)? acceptButton;
  final bool value;
  final String imagePath;

  @override
  State<UserInfoWidget> createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends State<UserInfoWidget> {

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          selectUserCheckBox(
            acceptButton: widget.acceptButton,
            value: widget.value,
          ),
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
                  child: widget.imagePath != null && widget.imagePath.isNotEmpty
                      ? Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(100),
                              ),
                              image: DecorationImage(
                                  image: NetworkImage(widget.imagePath),
                                  fit: BoxFit.fill)),
                        )
                      : Container(
                          width: 45,
                          height: 45,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(100),
                              ),
                              image: DecorationImage(
                                  image: AssetImage(Images.defaultUserImage),
                                  fit: BoxFit.fill)),
                        ),
                ),
              ),
              title: Text(
                widget.userName,
                style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize:12),
              ),
              subtitle: Text(
                'Work @${widget.companyName}',
                style: const TextStyle(
                  color: AppColors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
