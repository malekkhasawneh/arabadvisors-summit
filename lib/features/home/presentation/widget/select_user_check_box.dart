import 'package:flutter/material.dart';
import 'package:provision/core/resources/app_colors.dart';

class selectUserCheckBox extends StatelessWidget {
  const selectUserCheckBox({
    Key? key,
    required this.acceptButton,
    required this.value,
  }) : super(key: key);
  final void Function(bool?)? acceptButton;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: Row(
        children: [
          Checkbox(
              fillColor: MaterialStateProperty.resolveWith((Set states) {
                if (states.contains(MaterialState.selected)) {
                  return AppColors.orange;
                }
              }),
              value: value,
              onChanged: acceptButton),
          Container(
            height: 50,
            color: AppColors.white,
            width: 1,
          ),
        ],
      ),
    );
  }
}
