import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
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

  static Future<void> sendNotifications({
    required String title,
    required String body,
    required String token,
  }) async {
    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAF9IH93Y:APA91bFrxtj9uS39MeRhE7Y39tfE0DMmHPynZUWNmG9kKNGOZ5-hXAkpe-knXOBTLQMbrY8CAYP9mMx-rD3U_-XpLrl4ak5UIKbcs-rloTbr5scRVQ4W5xGde6NUaStUqCa14rWIDPlN'
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

  static Future<bool> saveToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final post = await http.post(
      Uri.parse(
          'https://vmi1258605.contaboserver.net/agg/api/v1/firebase/saveToken'),
      headers: requestHeaders(token: preferences.getString('token') ?? ''),
      body: json.encode(
        {
          'userId': preferences.getInt('id'),
          "token": await FirebaseMessaging.instance.getToken()
        },
      ),
    );
    if (post.statusCode == 200) {
      log('======================================= Success');
      return true;
    } else {
      log('======================================= Failed');

      return false;
    }
  }

  static Future<String> getToken({
    required int userId,
  }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final get = await http.get(
      Uri.parse(
          'https://vmi1258605.contaboserver.net/agg/api/v1/firebase/findToken?userId=$userId'),
      headers: requestHeaders(token: preferences.getString('token') ?? ''),
    );
    if (get.statusCode == 200) {
      final data = json.decode(get.body);
      return data['ftoken'];
    } else {
      throw Exception();
    }
  }
}
