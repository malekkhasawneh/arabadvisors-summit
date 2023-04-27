import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provision/core/resources/app_colors.dart';
import 'package:provision/core/resources/app_strings.dart';
import 'package:provision/features/connection/data/repository/connections_repository.dart';
import 'package:provision/features/connection/presentation/cubit/my_connection_cubit.dart';

import '../../../event/data/model/get_all_participants_model.dart';
import '../widget/user_info_widget.dart';
import 'messages_page.dart';

class MyConnectionPage extends StatefulWidget {
  const MyConnectionPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyConnectionPage> createState() => _MyConnectionPageState();
}

class _MyConnectionPageState extends State<MyConnectionPage> {
  List<AllParticipantsModel> allFriends = [];
  bool loading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<MyConnectionCubit>(context).setShowClearSearch = false;

    ConnectionsRepository.getAllFriends().then(
      (value) => setState(
        () {
          allFriends = value;
          loading = false;
        },
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double safePadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<MyConnectionCubit, MyConnectionState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Container(
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
              child: Container(
                margin: EdgeInsets.only(
                    top: safePadding,
                    left: screenWidth * 0.05,
                    right: screenWidth * 0.05,
                    bottom: 0),
                width: screenWidth * 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.8,
                      child: const Text(
                        AppStrings.myConnectionTitle,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: screenWidth,
                      height: 0.8,
                      color: AppColors.white,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 35,
                      child: TextFormField(
                        controller: searchController,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            BlocProvider.of<MyConnectionCubit>(context)
                                .setShowClearSearch = false;
                          } else {
                            BlocProvider.of<MyConnectionCubit>(context)
                                .setShowClearSearch = true;
                          }
                          ConnectionsRepository.getAllFriends(searchText: value)
                              .then(
                            (value) => setState(
                              () {
                                allFriends = value;
                                loading = false;
                              },
                            ),
                          );
                        },
                        decoration: InputDecoration(
                          suffixIcon: BlocProvider.of<MyConnectionCubit>(
                                      context)
                                  .getShowClearSearch
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      searchController.clear();
                                    });
                                    ConnectionsRepository.getAllFriends().then(
                                      (value) => setState(
                                        () {
                                          allFriends = value;
                                          loading = false;
                                        },
                                      ),
                                    );
                                    BlocProvider.of<MyConnectionCubit>(context)
                                        .setShowClearSearch = false;
                                  },
                                  icon: const Icon(
                                    Icons.clear,
                                    color: AppColors.orange,
                                    size: 15,
                                  ),
                                )
                              : const SizedBox(),
                          prefixIcon: const Icon(
                            Icons.search,
                            size: 15,
                          ),
                          prefixIconColor: MaterialStateColor.resolveWith(
                              (states) => states.contains(MaterialState.focused)
                                  ? AppColors.orange
                                  : AppColors.grey),
                          prefixIconConstraints:
                              const BoxConstraints(minWidth: 20, maxHeight: 20),
                          contentPadding: const EdgeInsets.only(left: 5),
                          hintText: 'Search',
                          hintStyle: const TextStyle(
                              color: AppColors.grey, fontSize: 10),
                          filled: true,
                          fillColor: AppColors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                color: AppColors.grey, width: 0.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: AppColors.grey, width: 0.5),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                color: AppColors.grey, width: 0.5),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                color: AppColors.grey, width: 0.5),
                          ),
                        ),
                      ),
                    ),
                    loading
                        ? Container(
                            margin: EdgeInsets.only(
                                top: screenHeight / 3, left: screenWidth / 3),
                            child: const CircularProgressIndicator(
                              color: AppColors.orange,
                            ),
                          )
                        : allFriends.isEmpty
                            ? Container(
                                margin: EdgeInsets.only(
                                    top: screenHeight / 3,
                                    left: screenWidth / 3.5),
                                child: const Text(
                                  AppStrings.noData,
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : Container(
                                margin:
                                    EdgeInsets.only(top: screenHeight * 0.035),
                                height: screenHeight * 0.67,
                                child: ListView.builder(
                                    itemCount: allFriends.length,
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      return UserInfoWidget(
                                        userName: allFriends[index].name,
                                        companyName: allFriends[index].company,
                                        imagePath: allFriends[index].image,
                                        acceptButton: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => MessagesPage(
                                                friendId: allFriends[index].id,
                                                chatId:
                                                    allFriends[index].chatId,
                                                name: allFriends[index].name,
                                                company:
                                                    allFriends[index].company,
                                                image: allFriends[index].image,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }),
                              ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
