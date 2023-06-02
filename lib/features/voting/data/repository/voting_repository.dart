import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/widgets/no_internet_widget.dart';
import '../model/voting_model.dart';

class VotingRepository {
  static Map<String, String> requestHeaders({required String token}) {
    return {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
  }

  static Future<VotingModel> getActiveForm(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    if (await checkIsConnected()) {
      final get = await http.get(
        Uri.parse(
            'https://vmi1258605.contaboserver.net/agg/api/v1/voting/getActiveForm'),
        headers: requestHeaders(token: preferences.getString('token') ?? ''),
      );
      if (get.statusCode == 200) {
        Map<String, dynamic> response = json.decode(get.body);
        VotingModel votingModel = VotingModel.fromJson(response);
        return votingModel;
      } else {
        throw Exception(
          'Failed to get form',
        );
      }
    } else {
      // ignore: use_build_context_synchronously
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => NoInternetConnectionWidget()));
      throw Exception();
    }
  }

  static Future<bool> submitVote(
      BuildContext context, List<int> answers) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    if (await checkIsConnected()) {
      final get = await http.patch(
        Uri.parse(
            'https://vmi1258605.contaboserver.net/agg/api/v1/voting/vote'),
        headers: requestHeaders(token: preferences.getString('token') ?? ''),
        body: json.encode(answers),
      );
      if (get.statusCode == 200) {
        return get.body == 'Votes Saved';
      } else {
        throw Exception(
          'Failed to add vote',
        );
      }
    } else {
      // ignore: use_build_context_synchronously
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => NoInternetConnectionWidget()));
      throw Exception();
    }
  }

  static Future<bool> checkIsConnected() async {
    InternetConnectionChecker internetConnectionChecker =
        InternetConnectionChecker();
    return await internetConnectionChecker.hasConnection;
  }
}
