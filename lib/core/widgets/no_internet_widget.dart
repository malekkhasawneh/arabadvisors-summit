import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:provision/core/resources/images.dart';

import '../resources/app_colors.dart';

class NoInternetConnectionWidget extends StatefulWidget {
  NoInternetConnectionWidget({Key? key}) : super(key: key);

  @override
  State<NoInternetConnectionWidget> createState() =>
      _NoInternetConnectionWidgetState();
}

class _NoInternetConnectionWidgetState
    extends State<NoInternetConnectionWidget> {
  InternetConnectionChecker internetConnectionChecker =
      InternetConnectionChecker();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(Images.noInternetLottie),
              const Text(
                'No Internet Connection!',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: isLoading
                    ? () {}
                    : () async {
                        setState(() {
                          isLoading = true;
                        });
                        if (await internetConnectionChecker.hasConnection) {
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        } else {
                          await Future.delayed(const Duration(seconds: 5))
                              .then((value) async => setState(() {
                                    isLoading = false;
                                  }));
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                ),
                child: isLoading
                    // ignore: sized_box_for_whitespace
                    ? Container(
                        height: 15,
                        width: 15,
                        child: const CircularProgressIndicator(
                          color: AppColors.white,
                        ),
                      )
                    : const Text(
                        'Reload',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
