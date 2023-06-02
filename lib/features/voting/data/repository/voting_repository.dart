import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../../core/widgets/no_internet_widget.dart';
import '../model/voting_model.dart';

class VotingRepository {
  static Map<String, String> requestHeaders(
      {String token =
          'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhYWc1Z3N1bW1pdDIwMjNAZ21haWwuY29tIiwiaWF0IjoxNjg1Njg1MzAwLCJleHAiOjE2OTA4NjkzMDB9.UQ1MimhBmkhAwduGx13tJepZ1y_Y2dz8b94rWdWWbg8'}) {
    return {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
  }

  static Future<VotingModel> getActiveForm(BuildContext context) async {
    if (await checkIsConnected()) {
      final get = await http.get(
          Uri.parse(
              'https://vmi1258605.contaboserver.net/agg/api/v1/voting/getActiveForm'),
          headers: requestHeaders());
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
    if (await checkIsConnected()) {
      final get = await http.patch(
        Uri.parse(
            'https://vmi1258605.contaboserver.net/agg/api/v1/voting/vote'),
        headers: requestHeaders(),
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
