import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provision/core/resources/app_colors.dart';
import 'package:provision/core/resources/utilities.dart';
import 'package:provision/core/widgets/no_internet_widget.dart';
import 'package:provision/features/auth/sign_up/presentation/page/sign_up_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/resources/app_strings.dart';
import '../../../../admin/presentation/page/admin_home_page.dart';
import '../../../../bottom_navigation/presentation/page.dart';
import '../widgets/app_logo_widget.dart';
import '../widgets/inputs_widget.dart';
import '../widgets/provision_logo_widget.dart';
import '../widgets/sign_in_button.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController email = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: Utilities.completeScreenHeight,
          width: Utilities.completeScreenWidth,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.blue,
              AppColors.skyBlue,
            ],
          )),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: Utilities.screenHeight! * 0.04,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const AppLogoWidget(),
                    SizedBox(
                      height: Utilities.screenHeight! * 0.025,
                    ),
                    TitleAndInputWidget(
                      labelName: AppStrings.email,
                      controller: email,
                    ),
                    TitleAndInputWidget(
                      labelName: AppStrings.password,
                      controller: passwordController,
                      hiddenText: true,
                      forgetPassword: true,
                    ),
                    SignInButton(
                      signIn: () async {
                        if (email.text.isNotEmpty &&
                            passwordController.text.isNotEmpty) {
                          if (await checkInternetConnection()) {
                            // ignore: use_build_context_synchronously
                            FocusScope.of(context).unfocus();
                            signIn();
                          } else {
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        NoInternetConnectionWidget()));
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Email and Password must not be Empty')));
                        }
                      },
                    ),
                    SizedBox(
                      height: Utilities.screenHeight! * 0.02,
                    ),
                    Text(
                      AppStrings.or,
                      style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: Utilities.screenWidth! * 0.03),
                    ),
                    SizedBox(
                      height: Utilities.screenHeight! * 0.005,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: Utilities.screenHeight! * 0.01,
                        left: Utilities.screenWidth! * 0.01,
                        right: Utilities.screenWidth! * 0.01,
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SignUpPage(),
                            ),
                          );
                        },
                        child: Text(
                          AppStrings.signUp,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                            fontSize: Utilities.screenWidth! * 0.033,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Positioned(bottom:0, child: ProVisionLogoWidget()),
            ],
          ),
        ),
      ),
    );
  }

  int id = 0;
  String token = '';

  Future<void> signIn() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var post = await http.post(
        Uri.parse(
            'https://vmi1258605.contaboserver.net/agg/api/v1/auth/authenticate'),
        headers: requestHeaders,
        body: json.encode({
          "email": email.text,
          "password": passwordController.text,
        }));
    if (post.statusCode == 200) {
      Map<String, dynamic> response = json.decode(post.body);

      if (response['admin'] == true) {
        await preferences.setInt('id', response['id']);
        await preferences.setString('token', response['token']);

        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => AdminHomePage()));
      } else if (response['statusCode'] == 1) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid Email or Password'),
          ),
        );
      } else if (response['statusCode'] == 2 && response['admin'] == false) {
        await preferences.setBool('userLogin', true);
        await preferences.setInt('id', response['id']);
        await preferences.setString('token', response['token']);
        await preferences.setString('loginDate', DateTime.now().toString());

        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainBottomSheet()),
        );
      } else {
        if (response['message'].toLowerCase() == 'pending') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Your registration is still in pending'),
            ),
          );
        } else if (response['message'].toLowerCase() == 'rejected') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Your registration is rejected'),
            ),
          );
        }
      }
    } else {
      log('========================= Failed');
    }
  }

  Future<bool> checkInternetConnection() async {
    InternetConnectionChecker internetConnectionChecker =
        InternetConnectionChecker();
    return await internetConnectionChecker.hasConnection;
  }
}
