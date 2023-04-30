import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provision/features/auth/sign_up/data/model/all_compamies_model.dart';
import 'package:provision/features/auth/sign_up/data/model/all_industry_model.dart';
import 'package:provision/features/auth/sign_up/data/model/get_all_country_model.dart';
import 'package:provision/features/auth/sign_up/presentation/widget/company_dropdown.dart';
import 'package:provision/features/auth/sign_up/presentation/widget/country_dropdown.dart';
import 'package:provision/features/auth/sign_up/presentation/widget/industry_dropdown.dart';
import 'package:provision/features/auth/sign_up/presentation/widget/text_field_custom_widget.dart';
import 'package:provision/features/edit_profile/presentation/widget/confirm_custom_dialog.dart';
import 'package:provision/features/reset_password/presentation/page/reset_password_page.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_strings.dart';
import '../../../../core/widgets/no_internet_widget.dart';
import '../../../auth/sign_up/presentation/cubit/sign_up_cubit.dart';
import '../../data/repository/edit_profile_repository.dart';
import '../widget/save_button.dart';

class EditUserInfo extends StatefulWidget {
  EditUserInfo({Key? key}) : super(key: key);

  @override
  State<EditUserInfo> createState() => _EditUserInfoState();
}

class _EditUserInfoState extends State<EditUserInfo> {
  bool isUpdated = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  TextEditingController industryController = TextEditingController();
  String image = '';

  final _formKey = GlobalKey<FormState>();
  bool loading = true;
  bool errorName = false;
  bool errorEmail = false;
  bool errorNumber = false;
  bool errorJobTitle = false;
  bool errorCountry = false;
  bool errorCompany = false;
  bool errorIndustry = false;

  @override
  void initState() {
    EditProfileRepository.showMyProfile().then(
      (userInfo) {
        setState(
          () {
            nameController.text = userInfo.name ?? '';
            emailController.text = userInfo.email ?? '';
            countryController.text = userInfo.country ?? '';
            numberController.text = userInfo.mobileNo.startsWith('+')
                ? userInfo.mobileNo.replaceRange(0, 4, '')
                : userInfo.mobileNo ?? '';
            companyController.text = userInfo.company ?? '';
            jobController.text = userInfo.jobTitle ?? '';
            industryController.text = userInfo.industry ?? '';
            image = userInfo.image;
          },
        );
        EditProfileRepository.getAllCountry(context)
            .then((value) => setState(() {
                  allCountriesList = value;
                  BlocProvider.of<SignUpCubit>(context).setCountryCode = value
                      .firstWhere(
                          (element) => element.name == countryController.text)
                      .countryCode;
                  loading = false;
                }));
        EditProfileRepository.getAllCompany(context)
            .then((value) => setState(() {
                  allCompanyList = value;
                }));
        EditProfileRepository.getAllIndustry(context)
            .then((value) => setState(() {
                  allIndustryList = value;
                }));
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  height: screenHeight,
                  width: screenWidth,
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
                  child: loading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.orange,
                          ),
                        )
                      : Form(
                          key: _formKey,
                          child: Container(
                            margin: EdgeInsets.only(
                              left: screenWidth * 0.075,
                              top: screenHeight * 0.01,
                              bottom: screenHeight * 0.12,
                            ),
                            width: screenWidth * 0.85,
                            child: ListView(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 20),
                                  child: Text(
                                    AppStrings.signUp,
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                TextFieldCustomWidget(
                                  controller: nameController,
                                  labelName: AppStrings.name,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      setState(() {
                                        errorName = true;
                                      });
                                      return 'Must not be Empty';
                                    } else {
                                      setState(() {
                                        errorName = false;
                                      });
                                    }
                                    return null;
                                  },
                                  errorValidation: errorName,
                                ),
                                TextFieldCustomWidget(
                                  controller: emailController,
                                  labelName: AppStrings.email,
                                  textInputType: TextInputType.emailAddress,
                                  description:
                                      'only Visible to people who you connected with',
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      setState(() {
                                        errorEmail = true;
                                      });
                                      return 'Must not be Empty';
                                    } else if (!value.contains('@')) {
                                      setState(() {
                                        errorEmail = true;
                                      });
                                      return 'Invalid Email';
                                    } else {
                                      setState(() {
                                        errorEmail = false;
                                      });
                                    }
                                    return null;
                                  },
                                  errorValidation: errorEmail,
                                ),
                                CountryDropDown(
                                  controller: countryController,
                                  labelName: AppStrings.country,
                                  allCountriesList: allCountriesList,
                                  isError: errorCountry,
                                  isFromEdit: true,
                                  hintText: countryController.text,
                                ),
                                TextFieldCustomWidget(
                                  controller: numberController,
                                  labelName: AppStrings.number,
                                  textInputType: TextInputType.phone,
                                  description:
                                      'only Visible to people who you connected with',
                                  isMobileNumber: true,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      setState(() {
                                        errorNumber = true;
                                      });
                                      return 'Must not be Empty';
                                    } else {
                                      setState(() {
                                        errorNumber = false;
                                      });
                                    }
                                    return null;
                                  },
                                  errorValidation: errorNumber,
                                ),
                                CompanyDropDown(
                                  controller: companyController,
                                  labelName: AppStrings.companyName,
                                  allCompanyList: allCompanyList,
                                  isError: errorCompany,
                                  isFromEdit: true,
                                  hintText: companyController.text,
                                ),
                                TextFieldCustomWidget(
                                  controller: jobController,
                                  labelName: AppStrings.jobTitle,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      setState(() {
                                        errorJobTitle = true;
                                      });
                                      return 'Must not be Empty';
                                    } else {
                                      setState(() {
                                        errorJobTitle = false;
                                      });
                                    }
                                    return null;
                                  },
                                  errorValidation: errorJobTitle,
                                ),
                                IndustryDropDown(
                                  controller: industryController,
                                  labelName: AppStrings.industry,
                                  allIndustryList: allIndustryList,
                                  isError: errorIndustry,
                                  isFromEdit: true,
                                  hintText: industryController.text,
                                ),
                                SizedBox(
                                  height: screenHeight * 0.005,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ResetPasswordPage(),
                                        ),
                                      );
                                    },
                                    child: const Center(
                                      child: Text(
                                        AppStrings.resetPassword,
                                        style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: 12,
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: screenHeight * 0.015,
                                ),
                                SaveButton(signUp: () async {
                                  if (!_formKey.currentState!.validate() ||
                                      companyController.text.isEmpty ||
                                      countryController.text.isEmpty ||
                                      industryController.text.isEmpty) {
                                    if (countryController.text.isEmpty) {
                                      setState(() {
                                        errorCountry = true;
                                      });
                                    } else {
                                      setState(() {
                                        errorCountry = false;
                                      });
                                    }
                                    if (companyController.text.isEmpty) {
                                      setState(() {
                                        errorCompany = true;
                                      });
                                    } else {
                                      setState(() {
                                        errorCompany = false;
                                      });
                                    }
                                    if (industryController.text.isEmpty) {
                                      setState(() {
                                        errorIndustry = true;
                                      });
                                    } else {
                                      setState(() {
                                        errorIndustry = false;
                                      });
                                    }
                                    return;
                                  } else {
                                    if (await checkInternetConnection()) {
                                      // ignore: use_build_context_synchronously
                                      await EditProfileRepository.editInfo(
                                              context,
                                              name: nameController.text,
                                              email: emailController.text,
                                              mobileNumber: allCountriesList
                                                      .firstWhere((element) =>
                                                          element.name ==
                                                          countryController
                                                              .text)
                                                      .countryCode +
                                                  numberController.text,
                                              company: companyController.text,
                                              country: countryController.text,
                                              jobTitle: jobController.text,
                                              industry: industryController.text,
                                              connectionStatus: 'CONNECTED',
                                              image: image)
                                          .then((value) => setState(() {
                                                isUpdated = true;
                                              }));
                                    } else {
                                      // ignore: use_build_context_synchronously
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  NoInternetConnectionWidget()));
                                    }
                                  }
                                }),
                              ],
                            ),
                          ),
                        ),
                ),
                isUpdated
                    ? ConfirmCustomDialog(
                        onPressed: () {
                          setState(() {
                            isUpdated = false;
                          });
                        },
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }

  List<GetAllCountryModel> allCountriesList = [];
  List<GetAllCompanyModel> allCompanyList = [];
  List<GetAllIndustryModel> allIndustryList = [];

  Future<bool> checkInternetConnection() async {
    InternetConnectionChecker internetConnectionChecker =
        InternetConnectionChecker();
    return await internetConnectionChecker.hasConnection;
  }
}
