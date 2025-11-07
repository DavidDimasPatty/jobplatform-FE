import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:job_platform/features/components/manageHRD/data/models/GetAllHRDTransaction.dart';
import 'package:job_platform/features/components/manageHRD/domain/entities/ManageHRDResponse.dart';

class AuthRemoteDataSource {
  Future<List<GetAllHRDTransaction?>?> getAllDataHRD(String idCompany) async {
    try {
      // Dummy API simulation
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_COMPANY']}/api/v1/manage-hrd/GetAllHRD',
      ).replace(queryParameters: {'id': idCompany});
      List<GetAllHRDTransaction?>? data;
      final response = await http.get(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        data = (jsonData["data"] as List)
            .map((e) => GetAllHRDTransaction.fromJson(e))
            .toList();
        return data;
      } else {
        final dataFailed = jsonDecode(response.body);
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<ManageHRDResponse?> deleteHRD(GetAllHRDTransaction profile) async {
    try {
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_COMPANY']}/api/v1/manage-hrd/DeleteHRD',
      );
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(profile.toJsonDeleteHRD()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        ManageHRDResponse profileResponse = ManageHRDResponse.fromJson(
          jsonData,
        );
        return profileResponse;
      } else {
        final Map<String, dynamic> dataFailed = jsonDecode(response.body);
        return ManageHRDResponse.fromJson(dataFailed);
      }
    } catch (e) {
      return ManageHRDResponse(
        responseCode: '500',
        responseMessage: 'Failed',
        data: null,
      );
    }
  }

  Future<ManageHRDResponse?> addHRD(
    GetAllHRDTransaction profile,
    String email,
  ) async {
    try {
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_COMPANY']}/api/v1/manage-hrd/AddHRD',
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(profile.toJsonAddHRD(email)),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        ManageHRDResponse profileResponse = ManageHRDResponse.fromJson(
          jsonData,
        );
        return profileResponse;
      } else {
        final Map<String, dynamic> dataFailed = jsonDecode(response.body);
        return ManageHRDResponse.fromJson(dataFailed);
      }
    } catch (e) {
      return ManageHRDResponse(
        responseCode: '500',
        responseMessage: 'Failed',
        data: null,
      );
    }
  }
}
