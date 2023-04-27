import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provision/core/resources/app_colors.dart';
import 'package:provision/core/resources/app_strings.dart';
import 'package:provision/features/auth/sign_up/data/model/get_all_country_model.dart';

import '../cubit/sign_up_cubit.dart';

class CountryDropDown extends StatefulWidget {
  CountryDropDown({
    Key? key,
    required this.controller,
    required this.labelName,
    required this.isError,
    this.isFromEdit = false,
    this.hintText = '',
    required this.allCountriesList,
  }) : super(key: key);
  final TextEditingController controller;
  final String labelName;
  final String hintText;
  final List<GetAllCountryModel> allCountriesList;
  final bool isError;
  final bool isFromEdit;

  @override
  State<CountryDropDown> createState() => _CountryDropDownState();
}

class _CountryDropDownState extends State<CountryDropDown> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
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
              border: Border.all(
                  color: widget.isError ? AppColors.red : AppColors.white)),
          width: MediaQuery.of(context).size.width * 0.85,
          height: 40,
          child: DropdownSearch<String>(
            onChanged: (val) {
              setState(() {
                widget.controller.text = val!;
                BlocProvider.of<SignUpCubit>(context).setCountryCode = widget
                    .allCountriesList
                    .firstWhere((element) => element.name == val)
                    .countryCode;
              });
            },
            mode: Mode.BOTTOM_SHEET,
            showSelectedItems: true,
            items: [...widget.allCountriesList.map((e) => e.name).toList()],
            dropdownSearchDecoration: InputDecoration(
              hintText: widget.isFromEdit ? widget.hintText : AppStrings.select,
              hintStyle: !widget.isFromEdit
                  ? const TextStyle(
                      color: AppColors.orange,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)
                  : const TextStyle(color: AppColors.black),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(
                left: 7,
                top: 5,
              ),
            ),
            //selectedItem: "",
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              autofocus: true,
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
        ),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }
}
