import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as date_format;
import 'package:provision/core/resources/app_colors.dart';
import 'package:provision/core/resources/images.dart';
import 'package:provision/features/event/data/model/get_all_participants_model.dart';
import 'package:provision/features/event/data/repository/events_repository.dart';
import 'package:provision/features/home/data/repository/home_repository.dart';

import '../../../../core/resources/app_strings.dart';
import '../../data/model/messages_model.dart';
import '../../data/repository/connections_repository.dart';
import '../cubit/my_connection_cubit.dart';

class ChatContainer extends StatefulWidget {
  ChatContainer(
      {Key? key,
      required this.messageController,
      required this.friendId,
      required this.name,
      required this.company,
      required this.image,
      required this.height,
      required this.chatId})
      : super(key: key);
  TextEditingController messageController;
  final int friendId;
  final int chatId;
  final String name;
  final String company;
  final String image;
  final double height;

  @override
  State<ChatContainer> createState() => _ChatContainerState();
}

class _ChatContainerState extends State<ChatContainer> {
  List<GetMessages> messagesList = [];
  bool loading = true;
  Timer? timer;
  AllParticipantsModel? participantsModel;
  String image = '';

  @override
  void initState() {
    EventsRepository.showMyProfile(context).then(
      (value) {
        setState(
          () {
            participantsModel = value;
          },
        );
        image = value.image;
      },
    );

    ConnectionsRepository.getMessages(chatId: widget.chatId, context: context)
        .then(
      (value) => setState(() {
        messagesList = value;
        loading = false;
      }),
    );
    timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      log('=========================== Refresh');
      ConnectionsRepository.getMessages(chatId: widget.chatId, context: context)
          .then((value) {
        if (mounted) {
          setState(() {
            messagesList = value;
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    double screenWidth = MediaQuery.of(context).size.width -
        MediaQuery.of(context).padding.left -
        MediaQuery.of(context).padding.right;
    return BlocBuilder<MyConnectionCubit, MyConnectionState>(
        builder: (context, state) {
      return Container(
        width: screenWidth * 0.9,
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.black),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              friendInfo(),
              Container(
                width: double.infinity,
                height: 0.3,
                color: AppColors.grey,
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                height: widget.height,
                width: screenWidth * 0.88,
                child: loading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.orange,
                        ),
                      )
                    : messagesList.isEmpty
                        ? const Center(
                            child: Text(
                              'No Messages Yet',
                              style: TextStyle(
                                color: AppColors.orange,
                              ),
                            ),
                          )
                        : ListView.builder(
                            reverse: true,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 2, vertical: 2),
                            itemCount: messagesList.length,
                            itemBuilder: (context, index) {
                              return Directionality(
                                textDirection: participantsModel!.name ==
                                        messagesList[index].name
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: image != null &&
                                              image.isNotEmpty &&
                                              participantsModel!.name !=
                                                  messagesList[index].name
                                          ? Container(
                                              width: 25,
                                              height: 25,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(100),
                                                ),
                                                border: Border.all(
                                                    color: AppColors.grey
                                                        .withOpacity(0.4)),
                                                image: DecorationImage(
                                                    image: NetworkImage(image),
                                                    fit: BoxFit.fill),
                                              ),
                                            )
                                          : widget.image != null &&
                                                  widget.image.isNotEmpty &&
                                                  participantsModel!.name ==
                                                      messagesList[index].name
                                              ? Container(
                                                  width: 25,
                                                  height: 25,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(100),
                                                    ),
                                                    border: Border.all(
                                                        color: AppColors.grey
                                                            .withOpacity(0.4)),
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            image),
                                                        fit: BoxFit.fill),
                                                  ),
                                                )
                                              : Container(
                                                  width: 25,
                                                  height: 25,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(100),
                                                      ),
                                                      border: Border.all(
                                                          color: AppColors.grey
                                                              .withOpacity(
                                                                  0.4)),
                                                      image: const DecorationImage(
                                                          image: AssetImage(Images
                                                              .defaultUserImage),
                                                          fit: BoxFit.fill)),
                                                ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth: screenWidth * 0.75,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2, vertical: 5),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: AppColors.grey,
                                            width: 0.5,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(7)),
                                      child: RichText(
                                        text: TextSpan(
                                          text: messagesList[index].message,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: AppColors.black,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text:
                                                  '      ${date_format.DateFormat('hh:mm a').format(messagesList[index].timestamp)}',
                                              style: const TextStyle(
                                                fontSize: 8,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
              ),
              sendMessageTextFiled(context),
            ],
          ),
        ),
      );
    });
  }

  Widget friendInfo() {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: image != null && image.isNotEmpty
            ? Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(100),
                  ),
                  image: DecorationImage(
                      image: NetworkImage(image), fit: BoxFit.fill),
                ),
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
      title: Text(
        widget.name,
        style: const TextStyle(
          color: AppColors.black,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
      subtitle: Text(
        'Works @${widget.company}',
        style: const TextStyle(
          color: AppColors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 8,
        ),
      ),
    );
  }

  Widget sendMessageTextFiled(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      width: MediaQuery.of(context).size.width * 0.85,
      height: 35,
      child: TextFormField(
        onChanged: (value) {
          if (value.trim().isNotEmpty) {
            BlocProvider.of<MyConnectionCubit>(context).setHaveSuffix = true;
          } else {
            BlocProvider.of<MyConnectionCubit>(context).setHaveSuffix = false;
          }
        },
        controller: widget.messageController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 5),
          hintText: AppStrings.writeMessage,
          hintStyle: const TextStyle(color: AppColors.orange, fontSize: 9),
          suffixIcon: BlocProvider.of<MyConnectionCubit>(context).getHaveSuffix
              ? IconButton(
                  onPressed: () {
                    if (widget.messageController.text.trim().isNotEmpty) {
                      ConnectionsRepository.sendMessage(
                              context: context,
                              message: widget.messageController.text,
                              friendId: widget.friendId)
                          .then((value) {
                        if (value) {
                          HomeRepository.getToken(context,
                                  userId: widget.friendId)
                              .then((value) {
                            HomeRepository.sendNotifications(context,
                                title: participantsModel!.name,
                                body: widget.messageController.text,
                                token: value);
                          });
                          ConnectionsRepository.getMessages(
                                  chatId: widget.chatId, context: context)
                              .then(
                            (value) => setState(
                              () {
                                messagesList = value;
                                loading = false;
                                widget.messageController.clear();
                              },
                            ),
                          );
                        } else {
                          widget.messageController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Send failed')));
                        }
                      });
                    }
                  },
                  icon: const Icon(
                    Icons.send,
                    size: 17,
                    color: AppColors.orange,
                  ),
                )
              : const SizedBox(),
          filled: true,
          fillColor: AppColors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: AppColors.grey, width: 0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.grey, width: 0.5),
            borderRadius: BorderRadius.circular(5),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: AppColors.grey, width: 0.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: AppColors.grey, width: 0.5),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }
}
