import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:job_platform/features/components/profile/data/models/certificateModel.dart';
import 'package:job_platform/features/components/profile/data/models/profileModel.dart';
import 'package:job_platform/features/components/profile/domain/entities/CertificateMV.dart';

class AuthRemoteDataSource {
  Future<ProfileModel?> profileGet(String id) async {
    try {
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_USER']}/api/v1/profile-management/detail',
      ).replace(queryParameters: {'id': id});
      ProfileModel? data;
      final response = await http.get(url);
      print(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        //print(response.body);
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        // print('Berhasil: $jsonData');

        data = ProfileModel.fromJson(jsonData);
        // print(data.certificates);
        return data;
      } else {
        final dataFailed = jsonDecode(response.body);
        print('Gagal: ${response.statusCode} $dataFailed');
        return null;
      }
    } catch (e) {
      print('Error during get profile: $e');
      return null;
    }
  }

  // Certificate
  Future<CertificateModel?> certificateAdd(CertificateModel certificate) async {
    try {
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_USER']}/api/v1/profile-management/add-certificate',
      );
      CertificateModel? data;
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(certificate.toJson()),
      );
      print(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        //print(response.body);
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        // print('Berhasil: $jsonData');

        data = CertificateModel.fromJson(jsonData);
        // print(data.certificates);
        return data;
      } else {
        final dataFailed = jsonDecode(response.body);
        print('Gagal: ${response.statusCode} $dataFailed');
        return null;
      }
    } catch (e) {
      print('Error during add certificate: $e');
      return null;
    }
  }

  Future<CertificateModel?> certificateEdit(
    CertificateModel certificate,
  ) async {
    try {
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_USER']}/api/v1/profile-management/update-certificate',
      );
      CertificateModel? data;
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(certificate.toJson()),
      );
      print(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        //print(response.body);
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        // print('Berhasil: $jsonData');

        data = CertificateModel.fromJson(jsonData);
        // print(data.certificates);
        return data;
      } else {
        final dataFailed = jsonDecode(response.body);
        print('Gagal: ${response.statusCode} $dataFailed');
        return null;
      }
    } catch (e) {
      print('Error during edit certificate: $e');
      return null;
    }
  }

  Future<bool> certificateDelete(String id) async {
    try {
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_USER']}/api/v1/profile-management/delete-certificate',
      ).replace(queryParameters: {'id': id});
      final response = await http.delete(url);
      print(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        //print(response.body);
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        print('Berhasil: $jsonData');

        return true;
      } else {
        final dataFailed = jsonDecode(response.body);
        print('Gagal: ${response.statusCode} $dataFailed');
        return false;
      }
    } catch (e) {
      print('Error during delete certificate: $e');
      return false;
    }
  }
}
