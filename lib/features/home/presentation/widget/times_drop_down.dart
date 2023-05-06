
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provision/core/resources/app_colors.dart';
import 'package:provision/core/resources/app_strings.dart';
import 'package:provision/features/home/data/model/all_times.dart';

class TimesDropDown extends StatefulWidget {
  TimesDropDown({
    Key? key,
    required this.controller,
    required this.labelName,
    required this.timesList,
  }) : super(key: key);
  final TextEditingController controller;
  final String labelName;
  final List<GetAllTimes> timesList;

  @override
  State<TimesDropDown> createState() => _TimesDropDownState();
}

class _TimesDropDownState extends State<TimesDropDown> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: screenHeight * 0.02,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: RichText(
              text: TextSpan(
                text: widget.labelName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            )),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.white,
          ),
          width: MediaQuery.of(context).size.width * 0.9,
          height: 40,
          child: DropdownSearch<String>(
            onChanged: (val) {
              setState(() {
                widget.controller.text = val!;
              });
            },

            items: [...widget.timesList.map((e) => e.roomTime).toList()],
            dropdownSearchDecoration: const InputDecoration(
              hintText: AppStrings.select,
              hintStyle: TextStyle(
                  color: AppColors.orange,
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(
                left: 7,
                top: 2,
              ),
            ),
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              controller: widget.controller,
              cursorColor: AppColors.orange,
              decoration: const InputDecoration(
                hintText: AppStrings.select,
                hintStyle: TextStyle(
                    color: AppColors.orange,
                    fontSize: 10,
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
