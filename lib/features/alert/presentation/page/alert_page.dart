import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provision/features/alert/presentation/cubit/alert_cubit.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_strings.dart';
import '../widget/content_widget.dart';
import '../widget/tabs_row.dart';

class AlertPage extends StatelessWidget {
  const AlertPage({Key? key,required this.userId}) : super(key: key);
final int userId;
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double safePadding = MediaQuery.of(context).padding.top;
    return BlocBuilder<AlertCubit, AlertState>(
      builder: (context, state) {
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
                ])),
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
                      AppStrings.alert,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const TabsRow(),
                  const SizedBox(
                    height: 50,
                  ),
                   ContentWidget(userId: userId,),
                ],
              ),
            ));
      },
    );
  }
}
