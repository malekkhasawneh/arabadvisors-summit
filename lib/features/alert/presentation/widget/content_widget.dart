import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provision/core/resources/app_colors.dart';
import 'package:provision/core/resources/app_strings.dart';
import 'package:provision/features/alert/data/repository/alert_repository.dart';
import 'package:provision/features/connection/data/repository/connections_repository.dart';
import 'package:provision/features/event/data/repository/events_repository.dart';

import '../../../connection/data/model/chats_model.dart';
import '../../../connection/presentation/page/messages_page.dart';
import '../../../meetings/presentation/page/meeting_page.dart';
import '../../data/model/notifications_model.dart';
import '../cubit/alert_cubit.dart';
import 'message_info_list_tile.dart';

class ContentWidget extends StatefulWidget {
  const ContentWidget({Key? key, required this.userId}) : super(key: key);
  final int userId;

  @override
  State<ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  List<GetAllChats> chatList = [];
  List<NotificationsModel> notifications = [];

  @override
  void initState() {
    ConnectionsRepository.getAllChats().then((value) => setState(() {
          chatList = value;
        }));
    AlertRepository.getAllNotifications().then((value) => setState(() {
          notifications = value;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return BlocBuilder<AlertCubit, AlertState>(
      builder: (context, state) {
        return Container(
            width: screenWidth * 0.9,
            height: screenHeight * 0.57,
            padding: EdgeInsets.all(screenWidth * 0.05),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.white,
                  AppColors.skyBlue.withOpacity(0.2),
                ],
              ),
            ),
            child: BlocProvider.of<AlertCubit>(context).getSelectedTabName ==
                    AppStrings.messages
                ? chatList.isEmpty
                    ? const Center(
                        child: Text(
                          AppStrings.noData,
                          style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: chatList.length,
                        itemBuilder: (context, index) {
                          return MessageInfoListTile(
                            companyName: chatList[index].company,
                            userName: chatList[index].name,
                            imagePath: chatList[index].image,
                            acceptButton: () async {
                              bool refresh = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MessagesPage(
                                    friendId: chatList[index].friendId,
                                    chatId: chatList[index].id,
                                    name: chatList[index].name,
                                    company: chatList[index].company,
                                    image: chatList[index].image,
                                  ),
                                ),
                              );
                              if (refresh) {
                                await ConnectionsRepository.getAllChats()
                                    .then((value) => setState(() {
                                          chatList = value;
                                        }));
                              }
                            },
                            lastMessage: chatList[index].lastMessage,
                            isRed: chatList[index].read,
                            viewInvite: () {},
                            acceptFriend: () {},
                            rejectFriend: () {},
                          );
                        })
                : notifications.isEmpty
                    ? const Center(
                        child: Text(
                          AppStrings.noData,
                          style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          return MessageInfoListTile(
                            companyName: notifications[index].companyName,
                            userName: notifications[index].name,
                            imagePath: notifications[index].photoUrl,
                            acceptButton: () {},
                            lastMessage:
                                notifications[index].type == 'CONNECTION'
                                    ? 'Connection Request'
                                    : 'Meeting Request',
                            isNotification: true,
                            status: notifications[index].status,
                            type: notifications[index].type,
                            viewInvite: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => MeetingPage(
                                            userId: widget.userId,
                                            meetingId:
                                                notifications[index].objectId,
                                            isViewOneMeeting: true,
                                          )));
                            },
                            acceptFriend: () {
                              EventsRepository.acceptFriendRequest(
                                      friendId: notifications[index].objectId)
                                  .then((value) {
                                if (value) {
                                  return AlertRepository.getAllNotifications()
                                      .then((value) => setState(() {
                                            notifications = value;
                                          }));
                                }
                              });
                            },
                            rejectFriend: () {
                              EventsRepository.rejectFriendRequest(
                                      friendId: notifications[index].objectId)
                                  .then((value) {
                                if (value) {
                                  return AlertRepository.getAllNotifications()
                                      .then((value) => setState(() {
                                            notifications = value;
                                          }));
                                }
                              });
                            },
                          );
                        }));
      },
    );
  }
}
