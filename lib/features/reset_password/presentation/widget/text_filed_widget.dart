import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provision/features/reset_password/presentation/cubit/reset_password_cubit.dart';

import '../../../../core/resources/utilities.dart';

class TextFiledWidget extends StatelessWidget {
  TextFiledWidget({
    Key? key,
    required this.controller,
    required this.isHiddenPassword,
    required this.hintText,
    required this.validator,
    required this.textInputType,
    required this.enabled,
    this.suffixIcon = const SizedBox(),
    this.hideText = false,
  }) : super(key: key);
  final TextEditingController controller;
  final bool isHiddenPassword;
  final String hintText;
  final String? Function(String?)? validator;
  final TextInputType textInputType;
  final bool enabled;
  final Widget suffixIcon;
  final bool hideText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Utilities.screenHeight! * 0.02),
      width: Utilities.screenWidth! * 0.85,
      height: 70,
      child: TextFormField(
        obscureText: hideText,
        enabled: enabled,
        validator: validator,
        controller: controller,
        keyboardType: textInputType,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 10),
          contentPadding: const EdgeInsets.only(
              left: 7,
              top: 15),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          disabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
