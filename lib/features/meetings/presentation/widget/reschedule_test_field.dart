import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provision/core/resources/app_colors.dart';
import 'package:provision/core/resources/app_strings.dart';

import '../../../home/data/model/all_times.dart';

class RescheduleTextField extends StatefulWidget {
  RescheduleTextField({
    Key? key,
    required this.controller,
    required this.timesList,
  }) : super(key: key);
  final TextEditingController controller;
  final List<GetAllTimes> timesList;

  @override
  State<RescheduleTextField> createState() => _RescheduleTextFieldState();
}

class _RescheduleTextFieldState extends State<RescheduleTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.grey.withOpacity(0.4)),
            color: AppColors.white,
          ),
          width: MediaQuery.of(context).size.width * 0.6,
          height: 40,
          child: DropdownSearch<String>(
            onChanged: (val) {
              setState(() {
                widget.controller.text = val!;
              });
            },
            mode: Mode.BOTTOM_SHEET,
            showSelectedItems: true,
            items: [...widget.timesList.map((e) => e.roomTime).toList()],
            dropdownSearchDecoration: const InputDecoration(
              hintText: AppStrings.select,
              hintStyle: TextStyle(
                  color: AppColors.orange,
                  fontSize: 8,
                  fontWeight: FontWeight.bold),
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(
                left: 7,
                top: 4,
              ),
            ),
            //selectedItem: "",
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              controller: widget.controller,
              cursorColor: AppColors.orange,
              decoration: const InputDecoration(
                hintText: AppStrings.select,
                hintStyle: TextStyle(
                    color: AppColors.orange,
                    fontSize: 8,
                    fontWeight: FontWeight.bold),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.orange,
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.orange,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.orange,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
