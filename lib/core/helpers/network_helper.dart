import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:provision/core/error/exceptions.dart';

class NetWorkHelper {
  Future<Map<String, dynamic>> postData(
      {required String url, required Map<String, dynamic> query}) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var post = await http.post(
      Uri.parse(url),
      body: jsonEncode(query),
      headers: requestHeaders,
    );
    if (post.statusCode == 200) {
      Map<String, dynamic> decode = jsonDecode(post.body);
      return decode;
    } else {
      throw ServerException();
    }
  }
}
