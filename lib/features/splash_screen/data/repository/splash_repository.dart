import 'dart:convert';

import 'package:http/http.dart' as http;

class SplashRepository {
  static final String _basicAuth =
      'Basic ${base64Encode(utf8.encode('malek_mamoon123456456:!@#QWE123qwe'))}';

  static Map<String, String> myHeaders = {'authorization': _basicAuth};

  static Future<bool> blockUser() async {
    final get = await http.get(
      Uri.parse('https://doctoral-nation.000webhostapp.com/block_user.php'),
      headers: myHeaders,
    );

    if (get.statusCode == 200) {
      final response = json.decode(get.body);
      if (response['data']['isBlocked'] == '0') {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
