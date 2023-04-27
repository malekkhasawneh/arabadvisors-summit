import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provision/core/resources/app_colors.dart';
import 'package:provision/core/resources/app_strings.dart';

import '../../../auth/sign_up/data/model/all_industry_model.dart';

class IndustryDropDown extends StatefulWidget {
  IndustryDropDown({
    Key? key,
    required this.controller,
    required this.labelName,
    required this.allIndustryList,
    required this.hintText,
  }) : super(key: key);
  final TextEditingController controller;
  final String labelName;
  final List<GetAllIndustryModel> allIndustryList;
final String hintText;
  @override
  State<IndustryDropDown> createState() => _IndustryDropDownState();
}

class _IndustryDropDownState extends State<IndustryDropDown> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.01),
      child: Column(
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
                    children: const [
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.red,
                        ),
                      ),
                    ]),
              )),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.white,
            ),
            width: MediaQuery.of(context).size.width * 0.85,
            height: 40,
            child: DropdownSearch<String>(
              onChanged: (val) {
                setState(() {
                  widget.controller.text = val!;
                });
              },
              mode: Mode.BOTTOM_SHEET,
              showSelectedItems: true,
              items: [...widget.allIndustryList.map((e) => e.name).toList()],
              dropdownSearchDecoration:  InputDecoration(
                hintText: widget.hintText,
                hintStyle: const TextStyle(
                  color: AppColors.black,),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(
                  left: 7,
                  top: 7,
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
                      fontSize: 12,
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
          )
        ],
      ),
    );
  }
}
