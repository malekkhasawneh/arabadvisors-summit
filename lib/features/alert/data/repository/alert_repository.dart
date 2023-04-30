import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provision/core/widgets/no_internet_widget.dart';
import 'package:provision/features/alert/data/model/notifications_model.dart';
import 'package:provision/features/home/data/repository/home_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlertRepository {
  static Map<String, String> requestHeaders({required String token}) {
    return {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
  }

  static Future<List<NotificationsModel>> getAllNotifications(
      BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (await HomeRepository.checkIsConnected()) {
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
    } else {
      // ignore: use_build_context_synchronously
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => NoInternetConnectionWidget()));
      throw Exception();
    }
  }
}
