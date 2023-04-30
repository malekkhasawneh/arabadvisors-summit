import 'package:flutter/material.dart';
import 'package:provision/core/widgets/no_internet_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../home/data/repository/home_repository.dart';

class ContactUsRepository {
  static Future<void> goToUrl(
      {required String url, required BuildContext context}) async {
    if (await HomeRepository.checkIsConnected()) {
      await launchUrl(Uri.parse(url));
    } else {
      // ignore: use_build_context_synchronously
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => NoInternetConnectionWidget()));
    }
  }
}
