import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:job_platform/features/components/profile/data/models/certificateRequest.dart';
import 'package:job_platform/features/components/profile/data/models/certificateResponse.dart';
import 'package:job_platform/features/components/profile/data/models/educationRequest.dart';
import 'package:job_platform/features/components/profile/data/models/educationResponse.dart';
import 'package:job_platform/features/components/profile/data/models/profileModel.dart';
import 'package:job_platform/features/components/profile/data/models/workExperienceRequest.dart';
import 'package:job_platform/features/components/profile/data/models/workExperienceResponse.dart';

class AuthRemoteDataSource {
  // General
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
    CertificateRequest certificate,
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
    CertificateRequest certificate,
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
      ).replace(queryParameters: {'idUserCertificate': id});
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
  Future<EducationResponse> educationAdd(EducationRequest education) async {
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

  Future<EducationResponse> educationEdit(EducationRequest education) async {
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
      ).replace(queryParameters: {'idUserEducation': id});
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

  // Work Experience
  Future<WorkExperienceResponse> workExperienceAdd(
    WorkExperienceRequest workExperience,
  ) async {
    try {
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_USER']}/api/v1/profile-management/add-experience',
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(workExperience.toJson()),
      );
      print(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        WorkExperienceResponse workExperienceResponse =
            WorkExperienceResponse.fromJson(jsonData);
        return workExperienceResponse;
      } else {
        final Map<String, dynamic> dataFailed = jsonDecode(response.body);

        print('Gagal: ${response.statusCode} $dataFailed');
        return WorkExperienceResponse.fromJson(dataFailed);
      }
    } catch (e) {
      print('Error during add work experience: $e');
      return WorkExperienceResponse(
        responseCode: '500',
        responseMessage: 'Failed',
        data: null,
      );
    }
  }

  Future<WorkExperienceResponse> workExperienceEdit(
    WorkExperienceRequest workExperience,
  ) async {
    try {
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_USER']}/api/v1/profile-management/update-experience',
      );
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(workExperience.toJson()),
      );
      print(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        WorkExperienceResponse workExperienceResponse =
            WorkExperienceResponse.fromJson(jsonData);
        return workExperienceResponse;
      } else {
        final Map<String, dynamic> dataFailed = jsonDecode(response.body);
        print('Gagal: ${response.statusCode} $dataFailed');
        return WorkExperienceResponse.fromJson(dataFailed);
      }
    } catch (e) {
      print('Error during edit work experience: $e');
      return WorkExperienceResponse(
        responseCode: '500',
        responseMessage: 'Failed',
        data: null,
      );
    }
  }

  Future<WorkExperienceResponse> workExperienceDelete(String id) async {
    try {
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_USER']}/api/v1/profile-management/delete-experience',
      ).replace(queryParameters: {'idUserExperience': id});
      final response = await http.delete(url);
      print(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        WorkExperienceResponse workExperienceResponse =
            WorkExperienceResponse.fromJson(jsonData);
        return workExperienceResponse;
      } else {
        final dataFailed = jsonDecode(response.body);
        print('Gagal: ${response.statusCode} $dataFailed');
        return WorkExperienceResponse.fromJson(dataFailed);
      }
    } catch (e) {
      print('Error during delete work experience: $e');
      return WorkExperienceResponse(
        responseCode: '500',
        responseMessage: 'Failed',
        data: null,
      );
    }
  }
}
