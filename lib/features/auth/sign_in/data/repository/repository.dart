import 'package:provision/core/resources/app_strings.dart';
import 'package:url_launcher/url_launcher.dart';

class SignInRepository {
  static Future<void> goToUrl() async {
    await launchUrl(Uri.parse(AppStrings.provisionUrl));
  }
}
