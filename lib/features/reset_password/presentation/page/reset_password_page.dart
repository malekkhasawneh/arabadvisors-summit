import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:provision/core/resources/app_strings.dart';
import 'package:provision/core/resources/dimentions.dart';
import 'package:provision/core/resources/network_constants.dart';
import 'package:provision/core/resources/utilities.dart';

import '../../../../core/resources/app_colors.dart';
import '../cubit/reset_password_cubit.dart';
import '../widget/reset_password_button.dart';
import '../widget/text_filed_widget.dart';

class ResetPasswordPage extends StatefulWidget {
  ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController emailController = TextEditingController();

  TextEditingController otpController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _showOtp = false;
  bool _showpassword = false;
  bool canEditEmail = true;
  bool canEditOtp = true;
  bool showPassword = true;
  bool showConfirmPassword = true;
  bool iLoading = false;
  bool isSuccess = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: AppColors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
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
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: defaultAppBarHeight + 22,
                          left: Utilities.screenWidth! / 5 + 22),
                      width: Utilities.screenWidth! * 0.6,
                      child:  Text(
                        AppStrings.resetPasswordTitle,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                          fontSize: Utilities.screenWidth!*0.062,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: defaultAppBarHeight, left: Utilities.screenWidth! * 0.075),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFiledWidget(
                              controller: emailController,
                              isHiddenPassword: false,
                              hintText: AppStrings.emailHint,
                              validator: (value) {
                                if (value!.isEmpty || !value.contains('@')) {
                                  BlocProvider.of<ResetPasswordCubit>(context)
                                      .setInvalid = true;
                                  return AppStrings.emailError;
                                }
                                return null;
                              },
                              textInputType: TextInputType.emailAddress,
                              enabled: canEditEmail,
                            ),
                            _showOtp
                                ? TextFiledWidget(
                                    controller: otpController,
                                    isHiddenPassword: false,
                                    hintText: AppStrings.otpHint,
                                    validator: (value) {
                                      if (_showOtp) {
                                        if (value!.isEmpty ||
                                            value.length < 6) {
                                          BlocProvider.of<ResetPasswordCubit>(
                                                  context)
                                              .setInvalid = true;
                                          return AppStrings.otpError;
                                        }
                                        return null;
                                      }
                                      return null;
                                    },
                                    textInputType: TextInputType.number,
                                    enabled: canEditOtp,
                                  )
                                : const SizedBox(),
                            _showpassword
                                ? TextFiledWidget(
                                    controller: passwordController,
                                    isHiddenPassword: false,
                                    hintText: AppStrings.passwordHint,
                                    validator: (value) {
                                      return null;
                                    },
                                    textInputType: TextInputType.text,
                                    enabled: true,
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          showPassword = !showPassword;
                                        });
                                      },
                                      icon: Icon(showPassword
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                    ),
                                    hideText: showPassword,
                                  )
                                : const SizedBox(),
                            _showpassword
                                ? TextFiledWidget(
                                    controller: confirmPasswordController,
                                    isHiddenPassword: false,
                                    hintText: AppStrings.confirmPasswordHint,
                                    validator: (value) {
                                      if (_showpassword) {
                                        if (value!.isEmpty ||
                                            passwordController.text !=
                                                confirmPasswordController
                                                    .text) {
                                          BlocProvider.of<ResetPasswordCubit>(
                                                  context)
                                              .setInvalid = true;
                                          return AppStrings
                                              .confirmPasswordError;
                                        }
                                        return null;
                                      }
                                      return null;
                                    },
                                    textInputType: TextInputType.text,
                                    enabled: true,
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          showConfirmPassword =
                                              !showConfirmPassword;
                                        });
                                      },
                                      icon: Icon(showConfirmPassword
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                    ),
                                    hideText: showConfirmPassword,
                                  )
                                : const SizedBox(),
                            ResetPasswordButton(
                              isLoading: iLoading,
                              isSuccess: isSuccess,
                              resetPassword: !iLoading
                                  ? () async {
                                      if (!_formKey.currentState!.validate()) {
                                        return;
                                      } else {
                                        setState(() {
                                          iLoading = true;
                                        });
                                        FocusScope.of(context).unfocus();
                                        if (!_showOtp && !_showpassword) {
                                          resetPassword();
                                        } else if (!_showpassword) {
                                          verifyOtp();
                                        } else if (_showOtp && _showpassword) {
                                          setNewPassword();
                                        }
                                      }
                                    }
                                  : () {},
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Future<void> resetPassword() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final request = await http.post(
      Uri.parse(
          '${NetworkConstants.resetPasswordEndPoint}?email=${emailController.text}'),
      body: jsonEncode({'email': emailController.text}),
      headers: requestHeaders,
    );
    log('================================ here ${request.statusCode}');
    if (request.statusCode == 200) {
      var decoded = jsonDecode(request.body);
      if (decoded['statusCode'] == 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'OTP has been sent to your email',
            ),
          ),
        );
        setState(() {
          _showOtp = true;
          canEditEmail = false;
          iLoading = false;
        });
      } else {
        setState(() {
          iLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Invalid Email',
            ),
          ),
        );
      }
    } else {
      setState(() {
        iLoading = false;
      });
    }
  }

  Future<void> verifyOtp() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final request = await http.post(
      Uri.parse(
          'https://vmi1258605.contaboserver.net/agg/api/v1/auth/verifyToken?email=${emailController.text}&token=${otpController.text}'),
      body: jsonEncode(
          {'email': emailController.text, "token": otpController.text}),
      headers: requestHeaders,
    );
    log('================================ here ${request.body}');
    if (request.body == 'Invalid token') {
      setState(() {
        iLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Invalid OTP',
          ),
        ),
      );
    } else {
      if (request.statusCode == 200) {
        var decoded = jsonDecode(request.body);
        if (decoded['statusCode'] == 2) {
          setState(() {
            _showpassword = true;
            canEditOtp = false;
            iLoading = false;
          });
        }
      } else {
        setState(() {
          iLoading = false;
        });
      }
    }
  }

  Future<void> setNewPassword() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final request = await http.post(
      Uri.parse(
          'https://vmi1258605.contaboserver.net/agg/api/v1/auth/changePassword?email=${emailController.text}&password=${confirmPasswordController.text}'),
      body: jsonEncode({
        'email': emailController.text,
        "password": confirmPasswordController.text
      }),
      headers: requestHeaders,
    );
    log('================================ here ${request.statusCode}');
    if (request.statusCode == 200) {
      var decoded = jsonDecode(request.body);
      if (decoded['statusCode'] == 2) {
        setState(() {
          iLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Password Change Successfully',
            ),
          ),
        );
        await Future.delayed(const Duration(seconds: 3)).then((_) {
          Navigator.pop(context);
        });
        log('=================================== Success');
      } else if (decoded['statusCode'] == 1) {
        setState(() {
          iLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              decoded['message'],
            ),
          ),
        );
      } else {
        setState(() {
          iLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Something Wrong',
            ),
          ),
        );
      }
    } else {
      setState(() {
        iLoading = false;
      });
    }
  }
}
