import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provision/features/auth/sign_up/presentation/cubit/sign_up_cubit.dart';

import '../../../../../core/resources/app_colors.dart';
import '../../../../../core/resources/utilities.dart';

class TextFieldCustomWidget extends StatefulWidget {
  TextFieldCustomWidget(
      {Key? key,
      this.hideText = false,
      this.passwordStrength = false,
      this.validator,
      this.isMobileNumber = false,
      this.errorValidation = false,
      required this.controller,
      this.textInputType = TextInputType.emailAddress,
      required this.labelName,
      this.description = '',
      this.suffixIcon = const SizedBox()})
      : super(key: key);
  final bool hideText;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final TextInputType textInputType;
  final String labelName;
  final String description;
  final Widget suffixIcon;
  final bool passwordStrength;
  final bool isMobileNumber;
  final bool errorValidation;

  @override
  State<TextFieldCustomWidget> createState() => _TextFieldCustomWidgetState();
}

class _TextFieldCustomWidgetState extends State<TextFieldCustomWidget> {
  String strength = '';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
                child: RichText(
                  text: TextSpan(
                      text: widget.labelName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                      children: [
                        const TextSpan(
                          text: '*',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.red,
                          ),
                        ),
                        TextSpan(
                          text: widget.description.isNotEmpty
                              ? '   (${widget.description})'
                              : '',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 8.5,
                          ),
                        ),
                      ]),
                )),
            Container(
              margin: widget.hideText
                  ? EdgeInsets.only(bottom: Utilities.screenHeight! * 0.009)
                  : EdgeInsets.only(bottom: Utilities.screenHeight! * 0.02),
              width: Utilities.screenWidth! * 0.85,
              height: widget.errorValidation ? 60 : 40,
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    if (value.length < 6) {
                      strength = 'weak';
                    } else if (value.length > 6 &&
                        !containsAlphabet(value) &&
                        !containsSpecialChar(value)) {
                      strength = 'normal';
                    } else if (containsAlphabet(value) &&
                        containsNumber(value) &&
                        value.length >= 6 &&
                        !containsSpecialChar(value)) {
                      strength = 'good';
                    } else if (containsSpecialChar(value) &&
                        value.length >= 6 &&
                        containsAlphabet(value) &&
                        containsNumber(value)) {
                      strength = 'very good';
                    } else {
                      strength = 'normal';
                    }
                    if (value.isEmpty) {
                      strength = '';
                    }
                  });
                },
                style: const TextStyle(fontSize: 14),
                obscureText: widget.hideText,
                validator: widget.validator,
                controller: widget.controller,
                keyboardType: widget.textInputType,
                decoration: InputDecoration(
                  prefixIcon: widget.isMobileNumber
                      ? Text(
                          '${BlocProvider.of<SignUpCubit>(context).getCountryCode} ',
                          style: const TextStyle(color: AppColors.orange),
                        )
                      : const SizedBox(),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 5,
                    minHeight: 0,
                  ),
                  //errorText: '',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.only(left: 7, top: 6),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.red,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  disabledBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: widget.suffixIcon,
                ),
              ),
            ),
            widget.passwordStrength && strength.isNotEmpty
                ? Container(
                    margin: EdgeInsets.only(
                        bottom: Utilities.screenHeight! * 0.011, left: 5),
                    width: Utilities.screenWidth! * 0.83,
                    height: 10,
                    child: LinearProgressIndicator(
                      color: strength == 'weak'
                          ? Colors.red
                          : strength == 'normal'
                              ? Colors.yellow
                              : strength == 'good'
                                  ? Colors.green
                                  : strength == 'very good'
                                      ? Colors.lightGreen
                                      : Colors.transparent,
                      value: strength == 'weak'
                          ? 0.25
                          : strength == 'normal'
                              ? 0.5
                              : strength == 'good'
                                  ? 0.75
                                  : strength == 'very good'
                                      ? 1
                                      : 0,
                      semanticsLabel: 'test',
                    ))
                : const SizedBox()
          ],
        );
      },
    );
  }

  bool containsAlphabet(String text) {
    final RegExp regex = RegExp('[a-zA-Z]');
    return regex.hasMatch(text);
  }

  bool containsSpecialChar(String text) {
    final RegExp regex = RegExp(r'[!@#%$^&*(),.?":{}|<>]');
    return regex.hasMatch(text);
  }

  bool containsNumber(String text) {
    final RegExp regex = RegExp(r'\d');
    return regex.hasMatch(text);
  }
}
