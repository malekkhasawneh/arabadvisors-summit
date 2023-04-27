import 'package:flutter/material.dart';

class Utilities {
  static double? screenWidth;
  static double? screenHeight;
  static double? completeScreenWidth;
  static double? completeScreenHeight;

  static void getScreenDimensions(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width -
        MediaQuery.of(context).padding.right -
        MediaQuery.of(context).padding.left;
    screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    completeScreenWidth = MediaQuery.of(context).size.width;
    completeScreenHeight = MediaQuery.of(context).size.height;
  }

  static onGenerateRoute({
    required RouteSettings routeSettings,
    required Widget nextPage,
  }) {
    return MaterialPageRoute(
      builder: (context) {
        getScreenDimensions(context);
        return nextPage;
      },
      settings: routeSettings,
    );
  }
}
