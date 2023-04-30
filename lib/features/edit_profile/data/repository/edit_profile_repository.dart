import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provision/core/widgets/no_internet_widget.dart';
import 'package:provision/features/home/data/repository/home_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../auth/sign_up/data/model/all_compamies_model.dart';
import '../../../auth/sign_up/data/model/all_industry_model.dart';
import '../../../auth/sign_up/data/model/get_all_country_model.dart';
import '../../../event/data/model/get_all_participants_model.dart';

class EditProfileRepository {
  static Map<String, String> requestHeaders({required String token}) {
    return {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
  }

  static Future<List<GetAllCountryModel>> getAllCountry(
      BuildContext context) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (await HomeRepository.checkIsConnected()) {
      final post = await http.get(
        Uri.parse(
            'https://vmi1258605.contaboserver.net/agg/api/v1/country/allCountries'),
        headers: requestHeaders,
      );
      if (post.statusCode == 200) {
        List<GetAllCountryModel> getAllCountry = json
            .decode(post.body)
            .map<GetAllCountryModel>((e) => GetAllCountryModel.fromJson(e))
            .toList();
        return getAllCountry;
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

  static Future<List<GetAllCompanyModel>> getAllCompany(
      BuildContext context) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (await HomeRepository.checkIsConnected()) {
      final post = await http.get(
        Uri.parse(
            'https://vmi1258605.contaboserver.net/agg/api/v1/company/allCompanies'),
        headers: requestHeaders,
      );
      if (post.statusCode == 200) {
        List<GetAllCompanyModel> country = json
            .decode(post.body)
            .map<GetAllCompanyModel>((e) => GetAllCompanyModel.fromJson(e))
            .toList();
        return country;
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

  static Future<List<GetAllIndustryModel>> getAllIndustry(
      BuildContext context) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (await HomeRepository.checkIsConnected()) {
      final post = await http.get(
        Uri.parse(
            'https://vmi1258605.contaboserver.net/agg/api/v1/industry/allIndustries'),
        headers: requestHeaders,
      );
      if (post.statusCode == 200) {
        List<GetAllIndustryModel> industry = json
            .decode(post.body)
            .map<GetAllIndustryModel>((e) => GetAllIndustryModel.fromJson(e))
            .toList();
        return industry;
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

  static Future<bool> editInfo(
    BuildContext context, {
    required String name,
    required String email,
    required String mobileNumber,
    required String company,
    required String country,
    required String jobTitle,
    required String industry,
    required String connectionStatus,
    required String image,
  }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (await HomeRepository.checkIsConnected()) {
      final searchParticipant = await http.put(
          Uri.parse(
              'https://vmi1258605.contaboserver.net/agg/api/v1/participant/updateParticipant'),
          headers: requestHeaders(token: preferences.getString('token') ?? ''),
          body: json.encode({
            "id": preferences.getInt('id'),
            "name": name,
            "email": email,
            "mobileNo": mobileNumber,
            "company": company,
            "country": country,
            "jobTitle": jobTitle,
            "industry": industry,
            "connectionStatus": connectionStatus,
            "image": image,
            "chatId": 0,
          }));
      if (searchParticipant.statusCode == 200) {
        log('================================= Ok');
        return true;
      } else {
        log('================================= Error');
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
