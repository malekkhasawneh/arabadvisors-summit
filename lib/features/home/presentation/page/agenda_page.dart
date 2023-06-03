import 'package:flutter/material.dart';
import 'package:provision/features/home/data/repository/home_repository.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_strings.dart';
import '../../../../core/resources/dimentions.dart';
import '../../data/model/all_events.dart';
import 'session_description.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({Key? key}) : super(key: key);

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  List<GetAllEvents> eventList = [];
  bool loading = true;

  @override
  void initState() {
    HomeRepository.getEventsDetails(
      context,
    ).then(
      (value) => setState(
        () {
          eventList = value;
          loading = false;
        },
      ),
    );
    HomeRepository.saveToken(context).then((value) => setState(() {
          loading = false;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double safePadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Container(
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
        child: loading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.orange,
                ),
              )
            : eventList.isEmpty
                ? const Center(
                    child: Text(AppStrings.noData),
                  )
                : Container(
                    margin: EdgeInsets.only(
                        top: safePadding + 15,
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
                            AppStrings.homeTitle,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            border: Border.all(color: AppColors.grey, width: 1),
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                width: screenWidth * 0.9,
                                child: const Text(
                                  AppStrings.eventsTitle,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.blue,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                constraints: BoxConstraints(
                                  minHeight: 50,
                                  maxHeight: screenHeight - 230,
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      ...eventList.map((event) {
                                        return GestureDetector(
                                          onTap: event.moderatorIds.isEmpty &&
                                                  event.panelistsIds.isEmpty
                                              ? null
                                              : () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              SessionDescription(
                                                                eventDetails:
                                                                    event,
                                                              )));
                                                },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                top: 3,
                                                left: 5,
                                                right: 5,
                                                bottom: 3),
                                            width: screenWidth * 0.9,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              color: AppColors.homeCardColor,
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                  event.time,
                                                  style: const TextStyle(
                                                    color: AppColors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 4,
                                                  ),
                                                  child: Text(
                                                    event.title,
                                                    style: const TextStyle(
                                                        color: AppColors.white,
                                                        fontSize: 10),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
