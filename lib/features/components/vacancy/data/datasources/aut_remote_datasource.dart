import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:job_platform/features/components/vacancy/data/models/vacancyModel.dart';
import 'package:job_platform/features/components/vacancy/data/models/vacancyRequest.dart';
import 'package:job_platform/features/components/vacancy/data/models/vacancyResponse.dart';

class AuthRemoteDataSource {
  Future<List<VacancyModel>?> getAllVacancy(String id) async {
    try {
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_COMPANY']}/api/v1/vacancy/list-vacancies',
      ).replace(queryParameters: {'id': id});
      List<VacancyModel>? data;
      final response = await http.get(url);
      print(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        //print(response.body);
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        //print('Berhasil: $jsonData');

        final List<dynamic> vacancyList = jsonData["data"];
        data = vacancyList
            .map<VacancyModel>((item) => VacancyModel.fromJson(item))
            .toList();
        //print(dataRes.id);
        return data;
      } else {
        final dataFailed = jsonDecode(response.body);
        print('Gagal: ${response.statusCode} $dataFailed');
        return null;
      }
    } catch (e) {
      print('Error during get all vacancy: $e');
      return null;
    }
  }

  Future<VacancyResponse> addVacancy(VacancyRequest vacancy) async {
    try {
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_COMPANY']}/api/v1/vacancy/add-vacancy',
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(vacancy.toJson()),
      );
      print(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        VacancyResponse vacancyResponse = VacancyResponse.fromJson(jsonData);
        return vacancyResponse;
      } else {
        final Map<String, dynamic> dataFailed = jsonDecode(response.body);

        print('Gagal: ${response.statusCode} $dataFailed');
        return VacancyResponse.fromJson(dataFailed);
      }
    } catch (e) {
      print('Error during add vacancy: $e');
      return VacancyResponse(
        responseCode: '500',
        responseMessage: 'Failed',
        data: null,
      );
    }
  }

  Future<VacancyResponse> editVacancy(VacancyRequest vacancy) async {
    try {
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_COMPANY']}/api/v1/vacancy/update-vacancy',
      );
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(vacancy.toJson()),
      );
      print(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        VacancyResponse vacancyResponse = VacancyResponse.fromJson(jsonData);
        return vacancyResponse;
      } else {
        final Map<String, dynamic> dataFailed = jsonDecode(response.body);
        print('Gagal: ${response.statusCode} $dataFailed');
        return VacancyResponse.fromJson(dataFailed);
      }
    } catch (e) {
      print('Error during edit vacancy: $e');
      return VacancyResponse(
        responseCode: '500',
        responseMessage: 'Failed',
        data: null,
      );
    }
  }

  Future<VacancyResponse> deleteVacancy(String idVacancy) async {
    try {
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_COMPANY']}/api/v1/vacancy/delete-vacancy',
      ).replace(queryParameters: {'idCompanyVacancy': idVacancy});
      final response = await http.delete(url);
      print(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        VacancyResponse vacancyResponse = VacancyResponse.fromJson(jsonData);
        return vacancyResponse;
      } else {
        final dataFailed = jsonDecode(response.body);
        print('Gagal: ${response.statusCode} $dataFailed');
        return VacancyResponse.fromJson(dataFailed);
      }
    } catch (e) {
      print('Error during delete vacancy: $e');
      return VacancyResponse(
        responseCode: '500',
        responseMessage: 'Failed',
        data: null,
      );
    }
  }
}
