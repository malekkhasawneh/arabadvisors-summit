import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provision/features/home/data/model/all_events.dart';
import 'package:provision/features/home/data/model/feed_back_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/widgets/no_internet_widget.dart';
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

  static Future<List<GetAllEvents>> getEventsDetails(
      BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (await checkIsConnected()) {
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
    } else {
      // ignore: use_build_context_synchronously
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => NoInternetConnectionWidget()));
      throw Exception();
    }
  }

  static Future<List<GetAllTimes>> getTimes(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (await checkIsConnected()) {
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
    } else {
      // ignore: use_build_context_synchronously
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => NoInternetConnectionWidget()));
      throw Exception();
    }
  }

  static Future<AllParticipantsModel> showParticipantProfile(
    BuildContext context, {
    required int profileId,
  }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (await checkIsConnected()) {
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
    } else {
      // ignore: use_build_context_synchronously
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => NoInternetConnectionWidget()));
      throw Exception();
    }
  }

  static Future<Map<AllParticipantsModel, bool>> getAllFriends(
      BuildContext context,
      {String searchText = ''}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (await checkIsConnected()) {
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
    } else {
      // ignore: use_build_context_synchronously
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => NoInternetConnectionWidget()));
      throw Exception();
    }
  }

  static Future<void> goToUrl(BuildContext context,
      {required String url}) async {
    if (await checkIsConnected()) {
      await launchUrl(Uri.parse(url));
    } else {
      // ignore: use_build_context_synchronously
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => NoInternetConnectionWidget()));
      throw Exception();
    }
  }

  static Future<void> goToFeedBack(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (await checkIsConnected()) {
      final get = await http.get(
        Uri.parse(
            'https://vmi1258605.contaboserver.net/agg/api/v1/feedback/getActiveFeedbackForm'),
        headers: requestHeaders(token: preferences.getString('token') ?? ''),
      );
      if (get.statusCode == 202) {
        FeedBackModel feedBackModel =
            FeedBackModel.fromJson(json.decode(get.body));
        // ignore: use_build_context_synchronously
        await goToUrl(context, url: feedBackModel.formUrl);
      } else {
        throw Exception('Failed to get from url');
      }
    } else {
      // ignore: use_build_context_synchronously
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => NoInternetConnectionWidget()));
      throw Exception();
    }
  }

  static Future<bool> scheduleMeeting(BuildContext context,
      {required int timeId, required int friendId}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (await checkIsConnected()) {
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
    } else {
      // ignore: use_build_context_synchronously
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => NoInternetConnectionWidget()));
      throw Exception();
    }
  }

  static Future<void> sendNotifications(
    BuildContext context, {
    required String title,
    required String body,
    required String token,
  }) async {
    if (await checkIsConnected()) {
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'key=AAAAz8K1e6A:APA91bEbm1IwaHEf8_DAEcVcjH_Q6TXQ6xgbTocqk0jeuesnizevtFbh3gTx6Q1ozV2fdQD0ubPEopF0zdn47tO5C-dHtgRT0DE3xbhJYRKfX-PGhMSBZFLlgaTqND8p9hNZ_qyZBYKh'
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
    } else {
      // ignore: use_build_context_synchronously
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => NoInternetConnectionWidget()));
      throw Exception();
    }
  }

  static Future<bool> saveToken(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (await checkIsConnected()) {
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
    } else {
      // ignore: use_build_context_synchronously
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => NoInternetConnectionWidget()));
      throw Exception();
    }
  }

  static Future<String> getToken(
    BuildContext context, {
    required int userId,
  }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (await checkIsConnected()) {
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
