import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:job_platform/features/components/home/data/models/HomePageCompany.dart';
import 'package:job_platform/features/components/home/data/models/HomePageHR.dart';
import 'package:job_platform/features/components/home/data/models/HomePageUser.dart';
import 'dart:convert';

class HomeRemoteDataSource {
  Future<HomePageUser?> getHomePageUser(String id) async {
    try {
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV']}/api/v1/homepage/getHomePagePelamar',
      ).replace(queryParameters: {'userId': id, "loginAs": "user"});
      HomePageUser? data;
      final response = await http.get(url);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        if (jsonData["responseCode"].toString().contains("200")) {
          data = HomePageUser.fromJson(jsonData["data"]);
          return data;
        } else {
          return null;
        }
      } else {
        final dataFailed = jsonDecode(response.body);
        print('Gagal: ${response.statusCode} $dataFailed');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<HomePageHR?> getHomePageHR(String id) async {
    try {
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV']}/api/v1/homepage/getHomePageHR',
      ).replace(queryParameters: {'userId': id, "loginAs": "HR"});
      HomePageHR? data;
      final response = await http.get(url);
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        if (jsonData["responseCode"].toString().contains("200")) {
          data = HomePageHR.fromJson(jsonData["data"]);
          return data;
        } else {
          return null;
        }
      } else {
        final dataFailed = jsonDecode(response.body);
        print('Gagal: ${response.statusCode} $dataFailed');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<HomePageCompany?> getHomePageCompany(String id) async {
    try {
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV']}/api/v1/homepage/getHomePageCompany',
      ).replace(queryParameters: {'userId': id, "loginAs": "company"});
      HomePageCompany? data;
      final response = await http.get(url);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        if (jsonData["responseCode"].toString().contains("200")) {
          data = HomePageCompany.fromJson(jsonData["data"]);
          return data;
        } else {
          return null;
        }
      } else {
        final dataFailed = jsonDecode(response.body);
        print('Gagal: ${response.statusCode} $dataFailed');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
