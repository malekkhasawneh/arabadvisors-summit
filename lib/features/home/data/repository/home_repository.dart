import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:provision/features/home/data/model/all_events.dart';
import 'package:provision/features/home/data/model/feed_back_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../event/data/model/get_all_participants_model.dart';
import '../model/all_times.dart';

class HomeRepository {
  static Map<String, String> requestHeaders({required String token}) {
    return {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
  }

  static Future<List<GetAllEvents>> getEventsDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final get = await http.get(
        Uri.parse(
            'https://vmi1258605.contaboserver.net/agg/api/v1/schedule/getAllScheduledItems'),
        headers: requestHeaders(token: preferences.getString('token') ?? ""));
    log('===================================== token ${preferences.getString('token')}');
    if (get.statusCode == 200) {
      List<GetAllEvents> eventList = json
          .decode(get.body)
          .map<GetAllEvents>((e) => GetAllEvents.fromJson(e))
          .toList();
      return eventList;
    } else {
      throw Exception(
        'Failed to get Events',
      );
    }
  }

  static Future<List<GetAllTimes>> getTimes() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final get = await http.get(
        Uri.parse(
            'https://vmi1258605.contaboserver.net/agg/api/v1/meeting/allTimes'),
        headers: requestHeaders(token: preferences.getString('token') ?? ""));
    if (get.statusCode == 200) {
      List<GetAllTimes> timesList = json
          .decode(get.body)
          .map<GetAllTimes>((e) => GetAllTimes.fromJson(e))
          .toList();
      return timesList;
    } else {
      throw Exception(
        'Failed to get Times',
      );
    }
  }

  static Future<AllParticipantsModel> showParticipantProfile({
    required int profileId,
  }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final searchParticipant = await http.get(
      Uri.parse(
          'https://vmi1258605.contaboserver.net/agg/api/v1/participant/ViewProfileByOthers?viewerId=${preferences.getInt('id')}&profileId=$profileId'),
      headers: requestHeaders(token: preferences.getString('token') ?? ''),
    );
    if (searchParticipant.statusCode == 200) {
      var decoded = json.decode(searchParticipant.body);
      AllParticipantsModel participantsModel =
          AllParticipantsModel.fromJson(decoded);
      return participantsModel;
    } else {
      throw Exception();
    }
  }

  static Future<Map<AllParticipantsModel, bool>> getAllFriends(
      {String searchText = ''}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final getAllParticipant = await http.get(
      Uri.parse(
          'https://vmi1258605.contaboserver.net/agg/api/v1/connections/getFriends?personId=${preferences.getInt('id')}&term=$searchText'),
      headers: requestHeaders(token: preferences.getString('token') ?? ''),
    );
    if (getAllParticipant.statusCode == 200) {
      var decoded = json.decode(getAllParticipant.body);
      Map<AllParticipantsModel, bool> participantMap = {};
      List<AllParticipantsModel> allParticipants = decoded
          .map<AllParticipantsModel>((e) => AllParticipantsModel.fromJson(e))
          .toList();
      for (var participant in allParticipants) {
        participantMap[participant] = false;
      }
      return participantMap;
    } else {
      throw Exception();
    }
  }

  static Future<void> goToUrl({required String url}) async {
    await launchUrl(Uri.parse(url));
  }

  static Future<void> goToFeedBack() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final get = await http.get(
      Uri.parse(
          'https://vmi1258605.contaboserver.net/agg/api/v1/feedback/getActiveFeedbackForm'),
      headers: requestHeaders(token: preferences.getString('token') ?? ''),
    );
    if (get.statusCode == 202) {
      FeedBackModel feedBackModel =
          FeedBackModel.fromJson(json.decode(get.body));
      await goToUrl(url: feedBackModel.formUrl);
    } else {
      throw Exception('Failed to get from url');
    }
  }

  static Future<bool> scheduleMeeting(
      {required int timeId, required int friendId}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final scheduleMeeting = await http.post(
      Uri.parse(
          'https://vmi1258605.contaboserver.net/agg/api/v1/meeting/scheduleMeeting'),
      headers: requestHeaders(token: preferences.getString('token') ?? ''),
      body: json.encode({
        "timeId": timeId,
        "inviter": preferences.getInt('id'),
        "invited": friendId
      }),
    );
    if (scheduleMeeting.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> sendNotifications({
    required String title,
    required String body,
    required String token,
  }) async {
    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAABBDLTWA:APA91bFvM82OF_i2e9QGBy71stCT7XTjZ0nh4ERrHIZxlMhiOFGQDP6rg2pUN6-VI75GDsZfb-qy735DfJexQTRCAyN_m8J7w6u_VzItbpihkfKd0O8HSGyQ7SbhAdH8ilTDEFq96swB'
        },
        body: json.encode(
          {
            'notification': {
              'title': title,
              'body': body,
            },
            'priority': 'high',
            'data': {
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            },
            'to': token,
          },
        ));
  }
}
