import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provision/core/widgets/no_internet_widget.dart';
import 'package:provision/features/connection/data/model/chats_model.dart';
import 'package:provision/features/home/data/repository/home_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../event/data/model/get_all_participants_model.dart';
import '../model/messages_model.dart';

class ConnectionsRepository {
  static Map<String, String> requestHeaders({required String token}) {
    return {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
  }

  static Future<List<AllParticipantsModel>> getAllFriends(
      {String searchText = '', required BuildContext context}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (await HomeRepository.checkIsConnected()) {
      final getAllParticipant = await http.get(
        Uri.parse(
            'https://vmi1258605.contaboserver.net/agg/api/v1/connections/getFriends?personId=${preferences.getInt('id')}&term=$searchText'),
        headers: requestHeaders(token: preferences.getString('token') ?? ''),
      );
      if (getAllParticipant.statusCode == 200) {
        log('======================================= body ${getAllParticipant.body}');
        var decoded = json.decode(getAllParticipant.body);
        List<AllParticipantsModel> allParticipants = decoded
            .map<AllParticipantsModel>((e) => AllParticipantsModel.fromJson(e))
            .toList();
        return allParticipants;
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

  static Future<bool> sendMessage({
    required String message,
    required int friendId,
    required BuildContext context,
  }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (await HomeRepository.checkIsConnected()) {
      final send = await http.post(
          Uri.parse(
              'https://vmi1258605.contaboserver.net/agg/api/v1/message/sendMessage'),
          headers: requestHeaders(token: preferences.getString('token') ?? ''),
          body: json.encode({
            "message": message,
            "senderId": preferences.getInt('id'),
            "receiverId": friendId
          }));
      if (send.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } else {
      // ignore: use_build_context_synchronously
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => NoInternetConnectionWidget()));
      throw Exception();
    }
  }

  static Future<List<GetMessages>> getMessages(
      {required int chatId, required BuildContext context}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (await HomeRepository.checkIsConnected()) {
      final recive = await http.get(
        Uri.parse(
            'https://vmi1258605.contaboserver.net/agg/api/v1/message/getMessages?chatId=$chatId&pesronId=${preferences.getInt('id')}'),
        headers: requestHeaders(token: preferences.getString('token') ?? ''),
      );
      if (recive.statusCode == 200) {
        List<GetMessages> messages = json
            .decode(recive.body)
            .map<GetMessages>((e) => GetMessages.fromJson(e))
            .toList();
        return messages;
      } else {
        return [];
      }
    } else {
      // ignore: use_build_context_synchronously
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => NoInternetConnectionWidget()));
      throw Exception();
    }
  }

  static Future<List<GetAllChats>> getAllChats(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (await HomeRepository.checkIsConnected()) {
      final allChats = await http.get(
        Uri.parse(
            'https://vmi1258605.contaboserver.net/agg/api/v1/message/getAllChats/${preferences.getInt('id')}'),
        headers: requestHeaders(token: preferences.getString('token') ?? ''),
      );
      if (allChats.statusCode == 200) {
        log('========================= friend ${allChats.body}');
        List<GetAllChats> messages = json
            .decode(allChats.body)
            .map<GetAllChats>((e) => GetAllChats.fromJson(e))
            .toList();
        return messages;
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
