import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provision/core/resources/app_colors.dart';
import 'package:provision/core/resources/app_strings.dart';
import 'package:provision/features/auth/sign_in/presentation/cubit/sign_in_cubit.dart';
import 'package:provision/features/reset_password/presentation/page/reset_password_page.dart';

class TitleAndInputWidget extends StatelessWidget {
  const TitleAndInputWidget({
    Key? key,
    required this.controller,
    required this.labelName,
    this.hiddenText = false,
    this.forgetPassword = false,
  }) : super(key: key);
  final TextEditingController controller;
  final String labelName;
  final bool hiddenText;
  final bool forgetPassword;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return BlocBuilder<SignInCubit, SignInState>(builder: (context, state) {
      return Container(
        margin: EdgeInsets.only(bottom: screenHeight * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Text(
                labelName,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.white),
              ),
            ),
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.white,
                ),
                width: MediaQuery.of(context).size.width * 0.85,
                height: 40,
                child: TextFormField(
                  obscureText: hiddenText &&
                      !BlocProvider.of<SignInCubit>(context).getShowPassword,
                  controller: controller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(top: 7, left: 5),
                    suffixIcon: hiddenText
                        ? IconButton(
                      onPressed: () {
                        BlocProvider.of<SignInCubit>(context)
                            .setShowPassword =
                        !BlocProvider.of<SignInCubit>(context)
                            .getShowPassword;
                      },
                      icon: Icon(BlocProvider.of<SignInCubit>(context)
                          .getShowPassword
                          ? Icons.visibility_off
                          : Icons.visibility,color: AppColors.orange,),
                    )
                        : const SizedBox(),
                  ),
                )),
            forgetPassword
                ? GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ResetPasswordPage(),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 7, horizontal: 5),
                child: Text(
                  AppStrings.forgetPassword,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                    fontSize: 8,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            )
                : const SizedBox(),
          ],
        ),
      );
    });
  }
}
