import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provision/core/resources/app_colors.dart';

import '../../../../core/resources/images.dart';
import '../../data/repository/events_repository.dart';
import 'accept_or_reject_buttons.dart';
import 'accept_or_reject_connection_reqest.dart';

class UserInfoWidget extends StatefulWidget {
  UserInfoWidget({
    Key? key,
    required this.companyName,
    required this.userName,
    required this.acceptButton,
    required this.imagePath,
    required this.buttonText,
    required this.isStatusRecived,
    required this.acceptFriend,
    required this.declineFriend,
    required this.tapOnListTile,
  }) : super(key: key);
  final String userName;
  final String companyName;
  final void Function() acceptButton;
  final String imagePath;
  final String buttonText;
  final bool isStatusRecived;
  void Function()? acceptFriend;
  void Function()? declineFriend;
  void Function()? tapOnListTile;

  @override
  State<UserInfoWidget> createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  Uint8List? _imageData;

  @override
  void initState() {
    EventsRepository.getImageDetails(context,imageUrl: widget.imagePath.split('/').last)
        .then((value) => setState(() {
              _imageData = value;
            }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.005),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: widget.tapOnListTile,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.white),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: _imageData != null
                        ? Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(100),
                          ),
                          image: DecorationImage(
                              image: MemoryImage(_imageData!),
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
                              image: AssetImage(
                                  Images.defaultUserImage),
                              fit: BoxFit.fill)),
                    ),
                  ),
                ),
                title: Text(
                  widget.userName,
                  style: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                subtitle: Text(
                  'Work @${widget.companyName}',
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
          widget.isStatusRecived
              ? AcceptOrRejectConnectionButton(
                  acceptFriend: widget.acceptFriend,
                  declineFriend: widget.declineFriend,
                )
              : AcceptOrRejectButton(
                  buttonText: widget.buttonText,
                  acceptButton: widget.acceptButton,
                ),
        ],
      ),
    );
  }
}
