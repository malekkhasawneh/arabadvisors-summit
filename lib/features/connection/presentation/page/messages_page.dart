import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provision/core/resources/app_colors.dart';
import 'package:provision/core/resources/dimentions.dart';
import 'package:provision/features/connection/presentation/cubit/my_connection_cubit.dart';

import '../../../../core/resources/app_strings.dart';
import '../../../event/data/repository/events_repository.dart';
import '../widget/chat_container.dart';

class MessagesPage extends StatefulWidget {
  MessagesPage({
    Key? key,
    required this.friendId,
    required this.chatId,
    required this.name,
    required this.company,
    required this.image,
  }) : super(key: key);
  final int friendId;
  final int chatId;
  final String name;
  final String company;
  final String image;

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double safeAreaPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: BlocBuilder<MyConnectionCubit, MyConnectionState>(
        builder: (context, state) {
          return KeyboardVisibilityBuilder(builder: (context, show) {
            return Container(
              height: screenHeight,
              width: screenWidth,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.blue,
                    AppColors.skyBlue,
                  ],
                ),
              ),
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(
                      top: defaultAppBarHeight + safeAreaPadding,
                      left: screenWidth * 0.05),
                  width: screenWidth * 0.9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        child: Text(
                          show ? '' : AppStrings.messages,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 34,
                      ),
                      ChatContainer(
                        messageController: messageController,
                        friendId: widget.friendId,
                        chatId: widget.chatId,
                        name: widget.name,
                        company: widget.company,
                        image: widget.image,
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
