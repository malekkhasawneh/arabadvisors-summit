import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  static Future<List<AllParticipantsModel>> getAllParticipant() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final getAllParticipant = await http.get(
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
    }
  }

  static Future<List<AllParticipantsModel>> searchParticipant({
    required String searchText,
  }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

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

  static Future<AllParticipantsModel> showMyProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

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
    }
  }

  static Future<List<GetAllFriendsModel>> getFriendRequests() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

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
    }
  }

  static Future<List<GetAllFriendsModel>> getAllFriends() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

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
    }
  }

  static Future<void> sendFriendRequest({
    required int friendId,
  }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

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
  }

  static Future<bool> acceptFriendRequest({
    required int friendId,
  }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

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
  }

  static Future<bool> rejectFriendRequest({
    required int friendId,
  }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

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
  }

  static Future<void> removeFriendRequest({
    required int friendId,
  }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

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
  }

  static Future<void> removeFriend({
    required int friendId,
  }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

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
  }

  static Future<bool> uploadUserImage({required File file}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var post = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://vmi1258605.contaboserver.net/agg/api/v1/participant/upload_image'));
    var length = await file.length();
    var stream = http.ByteStream(file.openRead());

    var multiPartFile = http.MultipartFile(
      'file',
      stream,
      length,
      filename: basename(file.path),
    );
    post.files.add(multiPartFile);
    Map<String, dynamic> body = {'id': preferences.getInt('id')};
    requestHeaders(token: preferences.getString('token') ?? '')
        .forEach((key, value) {
      post.headers[key] = value;
    });
    body.forEach((key, value) {
      post.fields[key] = value;
    });
    var myRequest = await post.send();

    var response = await http.Response.fromStream(myRequest);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static upload(File imageFile) async {
    var stream = http.ByteStream(imageFile.openRead());
    var length = await imageFile.length();
    var uri = Uri.parse(
        "https://vmi1258605.contaboserver.net/agg/api/v1/participant/upload_image");
    var request = http.MultipartRequest("POST", uri);
    var multipartFile = http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));
    request.files.add(multipartFile);
    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  static Future<Uint8List> getImageDetails({required String imageUrl}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final getUserImage = await http.get(
      Uri.parse(
          'https://vmi1258605.contaboserver.net/agg/api/v1/participant/download/$imageUrl'),
      headers: {
        'Authorization': 'Bearer ${preferences.getString('token') ?? ''}'
      },
    );
    if (getUserImage.statusCode == 200) {
      Uint8List _imageData;
      _imageData = getUserImage.bodyBytes;
      return _imageData;
    } else {
      throw Exception('Failed to fetch image');
    }
  }

 static Future<bool> uploadImage(File imageFile) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
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
  }
}
