import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provision/core/widgets/no_internet_widget.dart';
import 'package:provision/features/home/data/repository/home_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/all_meetings_model.dart';

class MeetingsRepository {
  static Map<String, String> requestHeaders({required String token}) {
    return {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
  }

  static Future<List<AllMeetingsModel>> getAllMeetings(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
   if(await HomeRepository.checkIsConnected()){ final getAllMeetings = await http.get(
      Uri.parse(
          'https://vmi1258605.contaboserver.net/agg/api/v1/meeting/findMyMeetings/${preferences.getInt('id')}'),
      headers: requestHeaders(token: preferences.getString('token') ?? ''),
    );

    if (getAllMeetings.statusCode == 200) {
      log('================================= getAllMeetings.body ${getAllMeetings.body}');
      List<AllMeetingsModel> allMeetings = jsonDecode(getAllMeetings.body)
          .map<AllMeetingsModel>(
            (e) => AllMeetingsModel.fromJson(e),
          )
          .toList();
      return allMeetings;
    } else {
      throw Exception('Failed to get meetings');
    }}else{
     // ignore: use_build_context_synchronously
     Navigator.push(context, MaterialPageRoute(builder: (_)=>NoInternetConnectionWidget()));
     throw Exception('Failed to get meetings');
   }
  }

  static Future<bool> acceptMeeting(BuildContext context,{required int meetingId}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(await HomeRepository.checkIsConnected()){  final acceptMeeting = await http.patch(
      Uri.parse(
          'https://vmi1258605.contaboserver.net/agg/api/v1/meeting/acceptMeeting/$meetingId'),
      headers: requestHeaders(token: preferences.getString('token') ?? ''),
    );
    log('========================================== ${acceptMeeting.statusCode}');
    if (acceptMeeting.statusCode == 200) {
      log('===================================== OK');
      return true;
    } else {
      return false;
    }}else{
      // ignore: use_build_context_synchronously
      Navigator.push(context, MaterialPageRoute(builder: (_)=>NoInternetConnectionWidget()));
      throw Exception('Failed to get meetings');
    }
  }

  static Future<bool> rejectMeeting(BuildContext context,{required int meetingId}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(await HomeRepository.checkIsConnected()){    final acceptMeeting = await http.patch(
      Uri.parse(
          'https://vmi1258605.contaboserver.net/agg/api/v1/meeting/rejectMeeting/$meetingId'),
      headers: requestHeaders(token: preferences.getString('token') ?? ''),
    );
    if (acceptMeeting.statusCode == 200) {
      log('===================================== OK');
      return true;
    } else {
      return false;
    }}else{
      // ignore: use_build_context_synchronously
      Navigator.push(context, MaterialPageRoute(builder: (_)=>NoInternetConnectionWidget()));
      throw Exception('Failed to get meetings');
    }
  }

  static Future<bool> rescheduleMeeting(BuildContext context,
      {required int meetingId, required int meetingTimeId}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(await HomeRepository.checkIsConnected()){  final acceptMeeting = await http.patch(
      Uri.parse(
          'https://vmi1258605.contaboserver.net/agg/api/v1/meeting/rescheduleMeeting/$meetingId?meetingTimeId=$meetingTimeId&requestedBy=${preferences.getInt('id')}'),
      headers: requestHeaders(token: preferences.getString('token') ?? ''),
    );
    if (acceptMeeting.statusCode == 200) {
      log('===================================== OK');
      return true;
    } else {
      return false;
    }}else{
      // ignore: use_build_context_synchronously
      Navigator.push(context, MaterialPageRoute(builder: (_)=>NoInternetConnectionWidget()));
      throw Exception('Failed to get meetings');
    }
  }

  static Future<AllMeetingsModel> getMeetingById(BuildContext context,
      {required int meetingId}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(await HomeRepository.checkIsConnected()){   final get = await http.get(
        Uri.parse(
            'https://vmi1258605.contaboserver.net/agg/api/v1/meeting/getMeeting/$meetingId'),
        headers: requestHeaders(token: preferences.getString('token') ?? ''));

    if (get.statusCode == 200) {
      AllMeetingsModel meetingsModel =
          AllMeetingsModel.fromJson(json.decode(get.body));
      return meetingsModel;
    } else {
      throw Exception('Failed to get meeting');
    }}else{
      // ignore: use_build_context_synchronously
      Navigator.push(context, MaterialPageRoute(builder: (_)=>NoInternetConnectionWidget()));
      throw Exception('Failed to get meetings');
    }
  }
}
