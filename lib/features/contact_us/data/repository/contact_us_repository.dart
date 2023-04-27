import 'package:url_launcher/url_launcher.dart';

class ContactUsRepository {
  static Future<void> goToUrl({required String url}) async {
    await launchUrl(Uri.parse(url));
  }
}