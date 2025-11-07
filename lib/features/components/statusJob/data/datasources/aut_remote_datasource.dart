import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:job_platform/features/components/login/data/models/loginModel.dart';
import 'package:job_platform/features/components/statusJob/data/models/AllStatusModel.dart';
import 'package:job_platform/features/components/statusJob/data/models/DetailStatusModel.dart';

class AuthRemoteDataSource {
  Future<List<AllStatusModel>?> getAllStatus(String id) async {
    try {
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_USER']}/api/v1/status/get-all-status',
      ).replace(queryParameters: {'idUser': id});
      List<AllStatusModel>? data;
      final response = await http.get(url);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        if (jsonData["responseCode"].toString().contains("200")) {
          data = List<AllStatusModel>.from(
            jsonData["data"].map((x) => AllStatusModel.fromJson(x)),
          );
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

  Future<DetailStatusModel?> getDetailStatus(String id) async {
    try {
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_USER']}/api/v1/status/get-detail-status',
      ).replace(queryParameters: {'idUserVacancy': id});
      DetailStatusModel? data;
      final response = await http.get(url);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        if (jsonData["responseCode"].toString().contains("200")) {
          data = DetailStatusModel.fromJson(jsonData["data"]);
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

  Future<String?> validateVacancy(
    String idUserVacancy,
    bool status,
    String? alasanReject,
    String? idUser,
  ) async {
    try {
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_USER']}/api/v1/status/validate-vacancy',
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "idUserVacancy": idUserVacancy,
          "status": status,
          "alasanReject": alasanReject,
          "idUser": idUser,
        }),
      );
      print(response.body.toString());
      final Map<String, dynamic> jsonData;
      if (response.statusCode == 200 || response.statusCode == 201) {
        jsonData = jsonDecode(response.body);
        if (jsonData["responseCode"].toString().contains("200")) {
          return jsonData["responseMessage"].toString();
        } else {
          return "Gagal : ${jsonData["responseMessage"]}";
        }
      } else {
        jsonData = jsonDecode(response.body);
        print('Gagal : ${response.statusCode} ${jsonData}');
        return "Gagal : ${jsonData["ressponseMessage"]}";
      }
    } catch (e) {
      print('Error: $e');
      return "Gagal $e";
    }
  }
}
