import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provision/core/resources/app_strings.dart';
import 'package:provision/features/auth/sign_in/presentation/page/sign_in_page.dart';
import 'package:provision/features/auth/sign_up/data/model/all_compamies_model.dart';
import 'package:provision/features/auth/sign_up/data/model/get_all_country_model.dart';
import 'package:provision/features/auth/sign_up/presentation/cubit/sign_up_cubit.dart';
import 'package:provision/features/auth/sign_up/presentation/widget/confirm_custom_dialog.dart';
import 'package:provision/features/auth/sign_up/presentation/widget/industry_dropdown.dart';
import 'package:provision/features/auth/sign_up/presentation/widget/text_field_custom_widget.dart';

import '../../../../../core/resources/app_colors.dart';
import '../../../../../core/widgets/no_internet_widget.dart';
import '../../data/model/all_industry_model.dart';
import '../widget/company_dropdown.dart';
import '../widget/country_dropdown.dart';
import '../widget/sign_up_button.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isSignUp = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  TextEditingController industryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool errorName = false;
  bool errorEmail = false;
  bool errorPassword = false;
  bool errorConfirmPassword = false;
  bool errorNumber = false;
  bool errorJobTitle = false;
  bool errorCountry = false;
  bool errorCompany = false;
  bool errorIndustry = false;

  @override
  void initState() {
    getAllCountry();
    getAllCompany();
    getAllIndustry();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
            ),
          ),
          elevation: 0,
          backgroundColor: AppColors.transparent,
        ),
        body: BlocBuilder<SignUpCubit, SignUpState>(
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
                      child: Form(
                        key: _formKey,
                        child: Container(
                          margin: EdgeInsets.only(
                            left: screenWidth * 0.075,
                            top: screenHeight * 0.01,
                            bottom: screenHeight * 0.05,
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
                              TextFieldCustomWidget(
                                controller: passwordController,
                                labelName: AppStrings.password,
                                hideText: !BlocProvider.of<SignUpCubit>(context)
                                    .getShowPassword,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    BlocProvider.of<SignUpCubit>(context)
                                            .setShowPassword =
                                        !BlocProvider.of<SignUpCubit>(context)
                                            .getShowPassword;
                                  },
                                  icon: Icon(
                                      BlocProvider.of<SignUpCubit>(context)
                                              .getShowPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                ),
                                passwordStrength: true,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    setState(() {
                                      errorPassword = true;
                                    });
                                    return 'Must not be Empty';
                                  } else if (value.length < 6) {
                                    setState(() {
                                      errorPassword = true;
                                    });
                                    return 'Password must be at least 6 characters';
                                  } else {
                                    setState(() {
                                      errorPassword = false;
                                    });
                                  }
                                  return null;
                                },
                                errorValidation: errorPassword,
                              ),
                              TextFieldCustomWidget(
                                controller: confirmPasswordController,
                                labelName: AppStrings.confirmPasswordHint,
                                hideText: !BlocProvider.of<SignUpCubit>(context)
                                    .getShowConfirmPassword,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    BlocProvider.of<SignUpCubit>(context)
                                            .setShowConfirmPassword =
                                        !BlocProvider.of<SignUpCubit>(context)
                                            .getShowConfirmPassword;
                                  },
                                  icon: Icon(
                                      BlocProvider.of<SignUpCubit>(context)
                                              .getShowConfirmPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                ),
                                validator: (value) {
                                  if (value != passwordController.text) {
                                    setState(() {
                                      errorConfirmPassword = true;
                                    });
                                    return 'Password does not match';
                                  } else if (value!.isEmpty) {
                                    setState(() {
                                      errorConfirmPassword = true;
                                    });
                                    return 'Must not be empty';
                                  } else {
                                    setState(() {
                                      errorConfirmPassword = false;
                                    });
                                  }
                                  return null;
                                },
                                errorValidation: errorConfirmPassword,
                              ),
                              CountryDropDown(
                                controller: countryController,
                                labelName: AppStrings.country,
                                allCountriesList: allCountriesList,
                                isError: errorCountry,
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
                              ),
                              SizedBox(
                                height: screenHeight * 0.02,
                              ),
                              SignUpButton(signUp: () async {
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
                                    await signUp();
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
                    isSignUp
                        ? ConfirmCustomDialog(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => SignInPage()));
                            },
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> signUp() async {
    try {
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      var post = await http.post(
          Uri.parse(
              'https://vmi1258605.contaboserver.net/agg/api/v1/auth/register'),
          headers: requestHeaders,
          body: json.encode({
            "email": emailController.text,
            "name": nameController.text,
            "phone": BlocProvider.of<SignUpCubit>(context).getCountryCode +
                numberController.text,
            "password": passwordController.text,
            "company": allCompanyList
                .firstWhere((element) => element.name == companyController.text)
                .id,
            "jobTitle": jobController.text,
            "country": countryController.text.isNotEmpty
                ? allCountriesList
                    .firstWhere(
                        (element) => element.name == countryController.text)
                    .id
                : null,
            "industry": allIndustryList
                .firstWhere(
                    (element) => element.name == industryController.text)
                .id,
          }));
      if (post.statusCode == 200) {
        Map<String, dynamic> response = json.decode(post.body);
        String here = response['message'];
        if (here.contains('Email already in use')) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Email Already in use')));
        } else {
          setState(() {
            isSignUp = true;
          });
        }
      } else {
        log('========================= Failed');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Please make sure that all fields are filled in correctly'),
        ),
      );
    }
  }

  List<GetAllCountryModel> allCountriesList = [];

  Future<void> getAllCountry() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final post = await http.get(
      Uri.parse(
          'https://vmi1258605.contaboserver.net/agg/api/v1/country/allCountries'),
      headers: requestHeaders,
    );
    if (post.statusCode == 200) {
      allCountriesList.clear();
      var users = json.decode(post.body);
      for (var data in users) {
        GetAllCountryModel country = GetAllCountryModel.fromJson(data);
        allCountriesList.add(country);
        setState(() {});
      }
    }
  }

  List<GetAllCompanyModel> allCompanyList = [];

  Future<void> getAllCompany() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final post = await http.get(
      Uri.parse(
          'https://vmi1258605.contaboserver.net/agg/api/v1/company/allCompanies'),
      headers: requestHeaders,
    );
    if (post.statusCode == 200) {
      allCompanyList.clear();
      var users = json.decode(post.body);
      for (var data in users) {
        GetAllCompanyModel country = GetAllCompanyModel.fromJson(data);
        allCompanyList.add(country);
        setState(() {});
      }
    }
  }

  List<GetAllIndustryModel> allIndustryList = [];

  Future<void> getAllIndustry() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final post = await http.get(
      Uri.parse(
          'https://vmi1258605.contaboserver.net/agg/api/v1/industry/allIndustries'),
      headers: requestHeaders,
    );
    if (post.statusCode == 200) {
      allIndustryList.clear();
      var users = json.decode(post.body);
      for (var data in users) {
        GetAllIndustryModel country = GetAllIndustryModel.fromJson(data);
        allIndustryList.add(country);
        setState(() {});
      }
    }
  }

  Future<bool> checkInternetConnection() async {
    InternetConnectionChecker internetConnectionChecker =
        InternetConnectionChecker();
    return await internetConnectionChecker.hasConnection;
  }
}
