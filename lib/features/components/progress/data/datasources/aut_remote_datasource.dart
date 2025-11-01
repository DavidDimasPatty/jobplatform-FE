import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:job_platform/features/components/login/data/models/loginModel.dart';
import 'package:job_platform/features/components/progress/data/models/AllProgressModel.dart';
import 'package:job_platform/features/components/progress/data/models/DetailProgressModel.dart';

class AuthRemoteDataSource {
  Future<List<AllProgressModel>?> getAllProgress(String id) async {
    try {
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_USER']}/api/v1/Progress/get-all-progress',
      ).replace(queryParameters: {'idUser': id});
      List<AllProgressModel>? data;
      final response = await http.get(url);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        if (jsonData["responseCode"].toString()!.contains("200")) {
          data = List<AllProgressModel>.from(
            jsonData["data"].map((x) => AllProgressModel.fromJson(x)),
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

  Future<DetailProgressModel?> getDetailProgress(String id) async {
    try {
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_USER']}/api/v1/Progress/get-detail-progress',
      ).replace(queryParameters: {'idUserVacancy': id});
      DetailProgressModel? data;
      final response = await http.get(url);
      print(response.body.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        if (jsonData["responseCode"].toString()!.contains("200")) {
          data = DetailProgressModel.fromJson(jsonData["data"]);
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

  Future<String?> validateProgress(
    String idUserVacancy,
    bool status,
    String? alasanReject,
    String? idUser,
  ) async {
    try {
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_USER']}/api/v1/Progress/validate-progress',
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
        if (jsonData["responseCode"].toString()!.contains("200")) {
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

  Future<String?> editVacancyCandidate(
    String idUserVacancy,
    String idUser,
    String? tipeKerja,
    String? sistemKerja,
    double? gajiMin,
    double? gajiMax,
  ) async {
    try {
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_USER']}/api/v1/Progress/edit-vacancy-candidate',
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "idUserVacancy": idUserVacancy,
          "idUser": idUser,
          "gajiMin": gajiMin,
          "gajiMax": gajiMax,
          "sistemKerja": sistemKerja,
          "tipeKerja": tipeKerja,
        }),
      );
      print(response.body.toString());
      final Map<String, dynamic> jsonData;
      if (response.statusCode == 200 || response.statusCode == 201) {
        jsonData = jsonDecode(response.body);
        if (jsonData["responseCode"].toString()!.contains("200")) {
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
