import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provision/core/helpers/shared_preferences_helper.dart';
import 'package:provision/core/resources/utilities.dart';
import 'package:provision/features/auth/sign_in/presentation/cubit/sign_in_cubit.dart';
import 'package:provision/features/auth/sign_up/presentation/cubit/sign_up_cubit.dart';
import 'package:provision/features/edit_profile/presentation/cubit/edit_profile_cubit.dart';
import 'package:provision/features/event/presentation/cubit/event_cubit.dart';
import 'package:provision/features/reset_password/presentation/cubit/reset_password_cubit.dart';
import 'package:provision/features/splash_screen/presentation/pages/splash_screen.dart';

import 'features/alert/presentation/cubit/alert_cubit.dart';
import 'features/connection/presentation/cubit/my_connection_cubit.dart';
import 'features/bottom_navigation/presentation/page.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesHelper().initialize();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: true,
    sound: true,
    badge: true,
    carPlay: true,
    criticalAlert: true,
    provisional: true,
  );
  await FirebaseMessaging.instance.getToken().then((value) {
    log('================================== Token ${value}++++');
  });
  FirebaseMessaging.onMessage.listen((event) {
    log('======================================== Message');
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiBlocProvider(
      providers: [
        BlocProvider<ResetPasswordCubit>(
          create: (_) => ResetPasswordCubit(),
        ),
        BlocProvider<SignInCubit>(
          create: (_) => SignInCubit(),
        ),
        BlocProvider<SignUpCubit>(
          create: (_) => SignUpCubit(),
        ),
        BlocProvider<EditProfileCubit>(
          create: (_) => EditProfileCubit(),
        ),
        BlocProvider<MyConnectionCubit>(
          create: (_) => MyConnectionCubit(),
        ),
        BlocProvider<AlertCubit>(
          create: (_) => AlertCubit(),
        ),
        BlocProvider<EventCubit>(
          create: (_) => EventCubit(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'Poppins',
        ),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (routeSettings) => Utilities.onGenerateRoute(
          routeSettings: routeSettings,
          nextPage: const MainBottomSheet(),
        ),
      ),
    );
  }
}
