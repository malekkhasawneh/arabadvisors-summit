import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provision/core/resources/app_colors.dart';
import 'package:provision/features/alert/presentation/cubit/alert_cubit.dart';

import '../../../../core/resources/app_strings.dart';

class TabsRow extends StatefulWidget {
  const TabsRow({Key? key}) : super(key: key);

  @override
  State<TabsRow> createState() => _TabsRowState();
}

class _TabsRowState extends State<TabsRow> {
  @override
  void initState() {
    BlocProvider.of<AlertCubit>(context).setSelectedTabName = 'Notifications';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<AlertCubit, AlertState>(
      builder: (context, state) {
        return Center(
          child: Container(
              width: screenWidth * 0.85,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppColors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      BlocProvider.of<AlertCubit>(context).setSelectedTabName =
                          AppStrings.notification;
                    },
                    child: Text(
                      AppStrings.notification,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: BlocProvider.of<AlertCubit>(context)
                                    .getSelectedTabName ==
                                AppStrings.notification
                            ? AppColors.orange
                            : AppColors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    color: AppColors.grey,
                    width: 0.5,
                  ),
                  GestureDetector(
                    onTap: () {
                      BlocProvider.of<AlertCubit>(context).setSelectedTabName =
                          AppStrings.messages;
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Text(
                        AppStrings.messages,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: BlocProvider.of<AlertCubit>(context)
                                      .getSelectedTabName ==
                                  AppStrings.messages
                              ? AppColors.orange
                              : AppColors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }
}
