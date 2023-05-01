import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provision/core/resources/app_colors.dart';

import '../../../../core/resources/images.dart';
import '../../../event/data/repository/events_repository.dart';
import 'connect_button.dart';

class UserInfoWidget extends StatefulWidget {
  UserInfoWidget({
    Key? key,
    required this.companyName,
    required this.userName,
    required this.acceptButton,
    required this.imagePath,
  }) : super(key: key);
  final String userName;
  final String companyName;
  final void Function() acceptButton;
  final String imagePath;

  @override
  State<UserInfoWidget> createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  Uint8List? _imageData;

  @override
  void initState() {
    if (widget.imagePath.isNotEmpty) {
      EventsRepository.getImageDetails(context,
              imageUrl: widget.imagePath.split('/').last)
          .then(
        (value) => setState(
          () {
            _imageData = value;
          },
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 5),
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: AppColors.red,
              borderRadius: BorderRadius.circular(
                100,
              ),
              border: Border.all(
                color: AppColors.black,
                width: 0.5,
              ),
            ),
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
                  child: _imageData != null
                      ? Image.memory(_imageData!)
                      : Image.asset(Images.defaultUserImage),
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
          ConnectButton(
            acceptButton: widget.acceptButton,
          ),
        ],
      ),
    );
  }
}
