import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:provision/features/home/data/repository/home_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/widgets/no_internet_widget.dart';
import '../model/get_all_friends_model.dart';
import '../model/get_all_participants_model.dart';

class EventsRepository {
  static Map<String, String> requestHeaders({required String token}) {
    return {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
  }

  static Future<List<AllParticipantsModel>> getAllParticipant(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (await HomeRepository.checkIsConnected()) {  final getAllParticipant = await http.get(
      Uri.parse(
          'https://vmi1258605.contaboserver.net/agg/api/v1/participant/allParticipants?personId=${preferences.getInt('id')}'),
      headers: requestHeaders(token: preferences.getString('token') ?? ''),
    );
    log('=================================== ff ${preferences.getString('token') ?? ''}');
    if (getAllParticipant.statusCode == 200) {
      var decoded = json.decode(getAllParticipant.body);
      List<AllParticipantsModel> allParticipants = decoded
          .map<AllParticipantsModel>((e) => AllParticipantsModel.fromJson(e))
          .toList();
      return allParticipants;
    } else {
      throw Exception();
    }} else {
      // ignore: use_build_context_synchronously
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => NoInternetConnectionWidget()));
      throw Exception();
    }
  }

  static Future<List<AllParticipantsModel>> searchParticipant(BuildContext context,{
    required String searchText,
  }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (await HomeRepository.checkIsConnected()) {
      final searchParticipant = await http.get(
      Uri.parse(
          'https://vmi1258605.contaboserver.net/agg/api/v1/participant/getParticipantLike?name=$searchText&personId=${preferences.getInt('id')}'),
      headers: requestHeaders(token: preferences.getString('token') ?? ''),
    );
    if (searchParticipant.statusCode == 200) {
      var decoded = json.decode(searchParticipant.body);
      List<AllParticipantsModel> allParticipants = decoded
          .map<AllParticipantsModel>((e) => AllParticipantsModel.fromJson(e))
          .toList();
      return allParticipants;
    } else {
      throw Exception();
    }} else {
      // ignore: use_build_context_synchronously
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => NoInternetConnectionWidget()));
      throw Exception();
    }
  }

  static Future<AllParticipantsModel> showParticipantProfile(BuildContext context,{
    required int profileId,
  }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (await HomeRepository.checkIsConnected()) {
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
    }} else {
      // ignore: use_build_context_synchronously
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => NoInternetConnectionWidget()));
      throw Exception();
    }
  }

  static Future<AllParticipantsModel> showMyProfile(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (await HomeRepository.checkIsConnected()) {
    final searchParticipant = await http.get(
      Uri.parse(
          'https://vmi1258605.contaboserver.net/agg/api/v1/participant/getParticipantById?id=${preferences.getInt('id')}'),
      headers: requestHeaders(token: preferences.getString('token') ?? ''),
    );
    if (searchParticipant.statusCode == 200) {
      var decoded = json.decode(searchParticipant.body);
      AllParticipantsModel participantsModel =
          AllParticipantsModel.fromJson(decoded);
      return participantsModel;
    } else {
      throw Exception();
    }} else {
      // ignore: use_build_context_synchronously
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => NoInternetConnectionWidget()));
      throw Exception();
    }
  }

  static Future<List<GetAllFriendsModel>> getFriendRequests(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (await HomeRepository.checkIsConnected()) {
    final searchParticipant = await http.get(
      Uri.parse(
          'https://vmi1258605.contaboserver.net/agg/api/v1/connections/getFriendRequests?personId=${preferences.getInt('id')}'),
      headers: requestHeaders(token: preferences.getString('token') ?? ''),
    );
    if (searchParticipant.statusCode == 200) {
      var decoded = json.decode(searchParticipant.body);
      List<GetAllFriendsModel> getAllFriends = decoded
          .map<GetAllFriendsModel>((e) => GetAllFriendsModel.fromJson(e))
          .toList();
      return getAllFriends;
    } else {
      throw Exception();
    }} else {
      // ignore: use_build_context_synchronously
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => NoInternetConnectionWidget()));
      throw Exception();
    }
  }

  static Future<List<GetAllFriendsModel>> getAllFriends(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (await HomeRepository.checkIsConnected()) {
    final searchParticipant = await http.get(
      Uri.parse(
          'https://vmi1258605.contaboserver.net/agg/api/v1/connections/getFriends?personId=${preferences.getInt('id')}'),
      headers: requestHeaders(token: preferences.getString('token') ?? ''),
    );
    if (searchParticipant.statusCode == 200) {
      var decoded = json.decode(searchParticipant.body);
      List<GetAllFriendsModel> getAllFriends = decoded
          .map<GetAllFriendsModel>((e) => GetAllFriendsModel.fromJson(e))
          .toList();
      return getAllFriends;
    } else {
      throw Exception();
    }} else {
      // ignore: use_build_context_synchronously
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => NoInternetConnectionWidget()));
      throw Exception();
    }
  }

  static Future<void> sendFriendRequest(
      {required int friendId, required BuildContext context}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (await HomeRepository.checkIsConnected()) {
      final sendFriendRequest = await http.patch(
          Uri.parse(
              'https://vmi1258605.contaboserver.net/agg/api/v1/connections/sendFriendRequest?personId=${preferences.getInt('id')}&friendId=$friendId'),
          headers: requestHeaders(token: preferences.getString('token') ?? ''),
          body: json.encode(
              {"personId": preferences.getInt('id'), "friendId": friendId}));
      if (sendFriendRequest.statusCode == 200) {
        log('Ok');
      } else {
        throw Exception();
      }
    } else {
      // ignore: use_build_context_synchronously
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => NoInternetConnectionWidget()));
    }
  }

  static Future<bool> acceptFriendRequest(
    BuildContext context, {
    required int friendId,
  }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (await HomeRepository.checkIsConnected()) {
      final sendFriendRequest = await http.patch(
          Uri.parse(
              'https://vmi1258605.contaboserver.net/agg/api/v1/connections/acceptFriendRequest?senderId=${preferences.getInt('id')}&receiverId=$friendId'),
          headers: requestHeaders(token: preferences.getString('token') ?? ''),
          body: json.encode(
              {"senderId": preferences.getInt('id'), "receiverId": friendId}));
      if (sendFriendRequest.statusCode == 200) {
        return true;
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

  static Future<bool> rejectFriendRequest(
    BuildContext context, {
    required int friendId,
  }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (await HomeRepository.checkIsConnected()) {
      final sendFriendRequest = await http.patch(
          Uri.parse(
              'https://vmi1258605.contaboserver.net/agg/api/v1/connections/declineFriendRequest?personId=${preferences.getInt('id')}&friendId=$friendId'),
          headers: requestHeaders(token: preferences.getString('token') ?? ''),
          body: json.encode(
              {"personId": preferences.getInt('id'), "friendId": friendId}));
      if (sendFriendRequest.statusCode == 200) {
        log('Ok');
        return true;
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

  static Future<void> removeFriendRequest(
    BuildContext context, {
    required int friendId,
  }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (await HomeRepository.checkIsConnected()) {
      final sendFriendRequest = await http.patch(
          Uri.parse(
              'https://vmi1258605.contaboserver.net/agg/api/v1/connections/removeFriendRequest?personId=${preferences.getInt('id')}&friendId=$friendId'),
          headers: requestHeaders(token: preferences.getString('token') ?? ''),
          body: json.encode(
              {"personId": preferences.getInt('id'), "friendId": friendId}));
      if (sendFriendRequest.statusCode == 200) {
        log('Ok');
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

  static Future<void> removeFriend(
    BuildContext context, {
    required int friendId,
  }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (await HomeRepository.checkIsConnected()) {
      final sendFriendRequest = await http.patch(
          Uri.parse(
              'https://vmi1258605.contaboserver.net/agg/api/v1/connections/removeFriend?personId=${preferences.getInt('id')}&friendId=$friendId'),
          headers: requestHeaders(token: preferences.getString('token') ?? ''),
          body: json.encode(
              {"personId": preferences.getInt('id'), "friendId": friendId}));
      if (sendFriendRequest.statusCode == 200) {
        log('Ok');
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

  static Future<bool> uploadImage(File imageFile, BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (await HomeRepository.checkIsConnected()) {
      final url = Uri.parse(
          'https://vmi1258605.contaboserver.net/agg/api/v1/participant/upload_image');
      var request = http.MultipartRequest('POST', url);
      request.fields['id'] = preferences.getInt('id').toString();
      var pic = await http.MultipartFile.fromPath('image', imageFile.path);
      request.files.add(pic);
      requestHeaders(token: preferences.getString('token') ?? '')
          .forEach((key, value) {
        request.headers[key] = value;
      });
      var response = await request.send();
      if (response.statusCode == 200) {
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
}
