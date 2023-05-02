import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provision/core/resources/app_colors.dart';
import 'package:provision/features/event/data/repository/events_repository.dart';

import '../../../../core/resources/images.dart';
import '../../../event/presentation/widget/accept_or_reject_connection_reqest.dart';

class MessageInfoListTile extends StatefulWidget {
  MessageInfoListTile({
    Key? key,
    required this.companyName,
    required this.userName,
    required this.acceptButton,
    required this.imagePath,
    required this.lastMessage,
    required this.viewInvite,
    required this.acceptFriend,
    required this.rejectFriend,
    this.isRed = false,
    this.isNotification = false,
    this.status = '',
    this.type = '',
  }) : super(key: key);
  final String userName;
  final String companyName;
  final void Function() acceptButton;
  final String imagePath;
  final String lastMessage;
  final bool isRed;
  final bool isNotification;
  final String status;
  final String type;
  void Function()? viewInvite;
  void Function()? acceptFriend;
  void Function()? rejectFriend;

  @override
  State<MessageInfoListTile> createState() => _MessageInfoListTileState();
}

class _MessageInfoListTileState extends State<MessageInfoListTile> {
  Uint8List? _imageData;

  @override
  void initState() {
  if(widget.imagePath.isNotEmpty){
    EventsRepository.getImageDetails(context,
              imageUrl: widget.imagePath.split('/').last)
          .then((value) => setState(() {
                _imageData = value;
              }));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
        children: [
          GestureDetector(
            onTap: widget.acceptButton,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                !widget.isNotification
                    ? Container(
                        margin: const EdgeInsets.only(right: 5),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: widget.isRed ? AppColors.white : AppColors.red,
                          borderRadius: BorderRadius.circular(
                            100,
                          ),
                          border: Border.all(
                            color: AppColors.black,
                            width: 0.5,
                          ),
                        ),
                      )
                    : const SizedBox(),
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.white),
                        borderRadius: BorderRadius.circular(100),
                      ),
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
                                      image:
                                          AssetImage(Images.defaultUserImage),
                                      fit: BoxFit.fill)),
                            ),
                    ),
                    title: Text(
                      widget.userName,
                      style: const TextStyle(
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(0, 0),
                              blurRadius: 3.0,
                              color: AppColors.black,
                            ),
                          ],
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:12),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Work @${widget.companyName}',
                          style: const TextStyle(
                            color: AppColors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 8,
                          ),
                        ),
                        const SizedBox(
                          height: 1,
                        ),
                        Row(
                          children: [
                            widget.isRed && !widget.isNotification
                                ? const Icon(
                                    Icons.check,
                                    size: 12,
                                  )
                                : const SizedBox(),
                            SizedBox(
                              width: widget.isNotification ? 120 : 170,
                              child: Text(
                                widget.lastMessage,
                                style: TextStyle(
                                    color:
                                        widget.isRed && !widget.isNotification
                                            ? AppColors.grey
                                            : AppColors.orange,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                widget.isNotification &&
                        widget.status != 'PENDING' &&
                        widget.type == 'CONNECTION'
                    ? SizedBox(
                        width: 70,
                        height: 25,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: AppColors.white),
                          onPressed: () {},
                          child: Text(
                            widget.status == 'ACCEPTED'
                                ? 'Accepted'
                                : 'Rejected',
                            style: TextStyle(
                                fontSize:8,
                                color: widget.status == 'ACCEPTED'
                                    ? AppColors.black
                                    : AppColors.red),
                          ),
                        ),
                      )
                    : widget.isNotification &&
                            widget.status == 'PENDING' &&
                            widget.type == 'CONNECTION'
                        ? AcceptOrRejectConnectionButton(
                            acceptFriend: widget.acceptFriend,
                            declineFriend: widget.rejectFriend,
                          )
                        : widget.isNotification
                            ? SizedBox(
                                height: 30,
                                child: ElevatedButton(
                                  onPressed: widget.viewInvite,
                                  style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      backgroundColor: AppColors.orange),
                                  child: const Text('view'),
                                ),
                              )
                            : const SizedBox(),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 4),
            color: AppColors.grey,
            height: 1,
            width: double.infinity,
          )
        ],

    );
  }
}
