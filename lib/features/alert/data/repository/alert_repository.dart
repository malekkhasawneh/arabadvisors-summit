import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:provision/features/alert/data/model/notifications_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlertRepository {
  static Map<String, String> requestHeaders({required String token}) {
    return {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
  }

  static Future<List<NotificationsModel>> getAllNotifications() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final get = await http.get(
        Uri.parse(
            'https://vmi1258605.contaboserver.net/agg/api/v1/notification/connections/${preferences.getInt('id')}'),
        headers: requestHeaders(token: preferences.getString('token') ?? ''));
    if (get.statusCode == 200) {
      log('==================================== jj ${json.decode(get.body)}');
      List<NotificationsModel> notification = json
          .decode(get.body)
          .map<NotificationsModel>((e) => NotificationsModel.fromJson(e))
          .toList();
      return notification;
    } else {
      throw Exception();
    }
  }
}
