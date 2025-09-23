import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:job_platform/features/components/profile/data/models/certificateModel.dart';
import 'package:job_platform/features/components/profile/data/models/certificateResponse.dart';
import 'package:job_platform/features/components/profile/data/models/educationModel.dart';
import 'package:job_platform/features/components/profile/data/models/educationResponse.dart';
import 'package:job_platform/features/components/profile/data/models/profileModel.dart';

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
  Future<CertificateResponse> certificateAdd(
    CertificateModel certificate,
  ) async {
    try {
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_USER']}/api/v1/profile-management/add-certificate',
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(certificate.toJson()),
      );
      print(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        CertificateResponse certificateResponse = CertificateResponse.fromJson(
          jsonData,
        );
        return certificateResponse;
      } else {
        final Map<String, dynamic> dataFailed = jsonDecode(response.body);

        print('Gagal: ${response.statusCode} $dataFailed');
        return CertificateResponse.fromJson(dataFailed);
      }
    } catch (e) {
      print('Error during add certificate: $e');
      return CertificateResponse(
        responseCode: '500',
        responseMessage: 'Failed',
        data: null,
      );
    }
  }

  Future<CertificateResponse> certificateEdit(
    CertificateModel certificate,
  ) async {
    try {
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_USER']}/api/v1/profile-management/update-certificate',
      );
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(certificate.toJson()),
      );
      print(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        CertificateResponse certificateResponse = CertificateResponse.fromJson(
          jsonData,
        );
        return certificateResponse;
      } else {
        final Map<String, dynamic> dataFailed = jsonDecode(response.body);
        print('Gagal: ${response.statusCode} $dataFailed');
        return CertificateResponse.fromJson(dataFailed);
      }
    } catch (e) {
      print('Error during edit certificate: $e');
      return CertificateResponse(
        responseCode: '500',
        responseMessage: 'Failed',
        data: null,
      );
    }
  }

  Future<CertificateResponse> certificateDelete(String id) async {
    try {
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_USER']}/api/v1/profile-management/delete-certificate',
      ).replace(queryParameters: {'id': id});
      final response = await http.delete(url);
      print(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        CertificateResponse certificateResponse = CertificateResponse.fromJson(
          jsonData,
        );
        return certificateResponse;
      } else {
        final dataFailed = jsonDecode(response.body);
        print('Gagal: ${response.statusCode} $dataFailed');
        return CertificateResponse.fromJson(dataFailed);
      }
    } catch (e) {
      print('Error during delete certificate: $e');
      return CertificateResponse(
        responseCode: '500',
        responseMessage: 'Failed',
        data: null,
      );
    }
  }

  // Education
  Future<EducationResponse> educationAdd(EducationModel education) async {
    try {
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_USER']}/api/v1/profile-management/add-education',
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(education.toJson()),
      );
      print(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        EducationResponse educationResponse = EducationResponse.fromJson(
          jsonData,
        );
        return educationResponse;
      } else {
        final Map<String, dynamic> dataFailed = jsonDecode(response.body);

        print('Gagal: ${response.statusCode} $dataFailed');
        return EducationResponse.fromJson(dataFailed);
      }
    } catch (e) {
      print('Error during add education: $e');
      return EducationResponse(
        responseCode: '500',
        responseMessage: 'Failed',
        data: null,
      );
    }
  }

  Future<EducationResponse> educationEdit(EducationModel education) async {
    try {
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_USER']}/api/v1/profile-management/update-education',
      );
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(education.toJson()),
      );
      print(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        EducationResponse educationResponse = EducationResponse.fromJson(
          jsonData,
        );
        return educationResponse;
      } else {
        final Map<String, dynamic> dataFailed = jsonDecode(response.body);
        print('Gagal: ${response.statusCode} $dataFailed');
        return EducationResponse.fromJson(dataFailed);
      }
    } catch (e) {
      print('Error during edit education: $e');
      return EducationResponse(
        responseCode: '500',
        responseMessage: 'Failed',
        data: null,
      );
    }
  }

  Future<EducationResponse> educationDelete(String id) async {
    try {
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_USER']}/api/v1/profile-management/delete-education',
      ).replace(queryParameters: {'id': id});
      final response = await http.delete(url);
      print(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        EducationResponse educationResponse = EducationResponse.fromJson(
          jsonData,
        );
        return educationResponse;
      } else {
        final dataFailed = jsonDecode(response.body);
        print('Gagal: ${response.statusCode} $dataFailed');
        return EducationResponse.fromJson(dataFailed);
      }
    } catch (e) {
      print('Error during delete education: $e');
      return EducationResponse(
        responseCode: '500',
        responseMessage: 'Failed',
        data: null,
      );
    }
  }
}
