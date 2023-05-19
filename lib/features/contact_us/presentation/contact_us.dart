import 'package:flutter/material.dart';
import 'package:provision/core/resources/app_colors.dart';
import 'package:provision/core/resources/dimentions.dart';
import 'package:provision/core/widgets/no_internet_widget.dart';
import 'package:provision/features/contact_us/data/repository/contact_us_repository.dart';
import 'package:provision/features/home/data/repository/home_repository.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/resources/app_strings.dart';
import '../../../core/resources/images.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight,
      width: screenWidth,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.blue, AppColors.skyBlue])),
      child: Container(
        width: screenWidth * 0.9,
        margin: EdgeInsets.only(
            top: defaultAppBarHeight,
            left: screenWidth * 0.05,
            right: screenWidth * 0.05),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              width: screenWidth * 0.9,
              child: const Text(
                AppStrings.contactUs,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              width: screenWidth * 0.9,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: AppColors.orange,
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                SizedBox(
                                    width: screenWidth * 0.6,
                                    child: const Text(
                                      AppStrings.contactUsLocation,
                                    ))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.inbox_outlined,
                                  color: AppColors.orange,
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                SizedBox(
                                    width: screenWidth * 0.6,
                                    child:
                                        const Text(AppStrings.contactUsAddress))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.call,
                                  color: AppColors.orange,
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                SizedBox(
                                    width: screenWidth * 0.6,
                                    child: GestureDetector(
                                        onTap: () async {
                                          if (await HomeRepository
                                              .checkIsConnected()) {
                                            final Uri params = Uri(
                                              scheme: 'tel',
                                              path: AppStrings.contactPhone,
                                            );

                                            String url = params.toString();
                                            await launch(url);
                                          } else {
                                            // ignore: use_build_context_synchronously
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        NoInternetConnectionWidget()));
                                          }
                                        },
                                        child: const Text(
                                            AppStrings.contactPhone)))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.local_print_shop,
                                  color: AppColors.orange,
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                SizedBox(
                                    width: screenWidth * 0.6,
                                    child: const Text(AppStrings.contactPhone2))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.alternate_email,
                                  color: AppColors.orange,
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                SizedBox(
                                    width: screenWidth * 0.6,
                                    child: GestureDetector(
                                        onTap: () async {
                                          if (await HomeRepository
                                              .checkIsConnected()) {
                                            final Uri params = Uri(
                                              scheme: 'mailto',
                                              path: AppStrings.contactUsEmail,
                                            );

                                            String url = params.toString();
                                            await launch(url);
                                          } else {
                                            // ignore: use_build_context_synchronously
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        NoInternetConnectionWidget()));
                                          }
                                        },
                                        child: const Text(
                                            AppStrings.contactUsEmail)))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 45, top: 10),
                    color: AppColors.grey.withOpacity(0.4),
                    width: 1,
                    height: 215,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                if (await HomeRepository.checkIsConnected()) {
                  await launch(
                      'https://www.google.com/maps?q=31.967433,35.905494');
                } else {
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => NoInternetConnectionWidget()));
                }
              },
              child: Container(
                width: screenWidth * 0.9,
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                      image: AssetImage(
                        Images.mapImage,
                      ),
                      fit: BoxFit.fill,
                    )),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              margin: const EdgeInsets.only(left: 15, right: 30),
              width: screenWidth * 0.9,
              height: 0.5,
              color: AppColors.white,
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: screenWidth * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      ContactUsRepository.goToUrl(
                          url: AppStrings.websiteUrl, context: context);
                    },
                    child: Image.asset(
                      Images.website,
                      width: 30,
                      height: 30,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      ContactUsRepository.goToUrl(
                          url: AppStrings.facebookUrl, context: context);
                    },
                    child: Image.asset(
                      Images.faceBook,
                      width: 30,
                      height: 30,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      ContactUsRepository.goToUrl(
                          url: AppStrings.youtubeUrl, context: context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Image.asset(
                        Images.youtube,
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      ContactUsRepository.goToUrl(
                          url: AppStrings.linkedInUrl, context: context);
                    },
                    child: Image.asset(
                      Images.linkedIn,
                      width: 30,
                      height: 30,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      ContactUsRepository.goToUrl(
                          url: AppStrings.twitterUrl, context: context);
                    },
                    child: Image.asset(
                      Images.twitter,
                      width: 30,
                      height: 30,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
