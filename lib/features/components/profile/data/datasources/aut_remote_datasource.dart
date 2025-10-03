import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:job_platform/features/components/profile/data/models/certificateModel.dart';
import 'package:job_platform/features/components/profile/data/models/certificateRequest.dart';
import 'package:job_platform/features/components/profile/data/models/certificateResponse.dart';
import 'package:job_platform/features/components/profile/data/models/educationModel.dart';
import 'package:job_platform/features/components/profile/data/models/educationRequest.dart';
import 'package:job_platform/features/components/profile/data/models/educationResponse.dart';
import 'package:job_platform/features/components/profile/data/models/organizationModel.dart';
import 'package:job_platform/features/components/profile/data/models/organizationRequest.dart';
import 'package:job_platform/features/components/profile/data/models/organizationResponse.dart';
import 'package:job_platform/features/components/profile/data/models/preferenceRequest.dart';
import 'package:job_platform/features/components/profile/data/models/preferenceResponse.dart';
import 'package:job_platform/features/components/profile/data/models/profileModel.dart';
import 'package:job_platform/features/components/profile/data/models/profileRequest.dart';
import 'package:job_platform/features/components/profile/data/models/profileResponse.dart';
import 'package:job_platform/features/components/profile/data/models/skillModel.dart';
import 'package:job_platform/features/components/profile/data/models/skillRequest.dart';
import 'package:job_platform/features/components/profile/data/models/skillResponse.dart';
import 'package:job_platform/features/components/profile/data/models/workExperienceModel.dart';
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
      // print(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        data = ProfileModel.fromJson(jsonData);
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

  Future<ProfileResponse> profileEdit(ProfileRequest profile) async {
    try {
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_USER']}/api/v1/profile-management/update-personal-info',
      );
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(profile.toJson()),
      );
      print(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        ProfileResponse profileResponse = ProfileResponse.fromJson(jsonData);
        return profileResponse;
      } else {
        final Map<String, dynamic> dataFailed = jsonDecode(response.body);
        print('Gagal: ${response.statusCode} $dataFailed');
        return ProfileResponse.fromJson(dataFailed);
      }
    } catch (e) {
      print('Error during edit profile: $e');
      return ProfileResponse(
        responseCode: '500',
        responseMessage: 'Failed',
        data: null,
      );
    }
  }

  Future<ProfileResponse> profileAvatarEdit(ProfileRequest profile) async {
    try {
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_USER']}/api/v1/profile-management/update-photo',
      );
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(profile.toJsonAvatar()),
      );
      print(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        ProfileResponse profileResponse = ProfileResponse.fromJson(jsonData);
        return profileResponse;
      } else {
        final Map<String, dynamic> dataFailed = jsonDecode(response.body);
        print('Gagal: ${response.statusCode} $dataFailed');
        return ProfileResponse.fromJson(dataFailed);
      }
    } catch (e) {
      print('Error during edit profile: $e');
      return ProfileResponse(
        responseCode: '500',
        responseMessage: 'Failed',
        data: null,
      );
    }
  }

  Future<ProfileResponse> profilePrivacyEdit(ProfileRequest profile) async {
    try {
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_USER']}/api/v1/profile-management/update-privacy',
      );
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(profile.toJsonPrivacy()),
      );
      print(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        ProfileResponse profileResponse = ProfileResponse.fromJson(jsonData);
        return profileResponse;
      } else {
        final Map<String, dynamic> dataFailed = jsonDecode(response.body);
        print('Gagal: ${response.statusCode} $dataFailed');
        return ProfileResponse.fromJson(dataFailed);
      }
    } catch (e) {
      print('Error during edit profile: $e');
      return ProfileResponse(
        responseCode: '500',
        responseMessage: 'Failed',
        data: null,
      );
    }
  }

  // Certificate
  Future<List<CertificateModel>?> certificateGet(String? nama) async {
    try {
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV']}/api/v1/account/GetCertificateAll',
      ).replace(queryParameters: {'nama': nama});
      List<CertificateModel>? data;
      final response = await http.get(url);
      print(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        final List<dynamic> orgList = jsonData["data"]["data"];
        data = orgList
            .map<CertificateModel>((item) => CertificateModel.fromJson(item))
            .toList();
        return data;
      } else {
        final dataFailed = jsonDecode(response.body);
        print('Gagal: ${response.statusCode} $dataFailed');
        return null;
      }
    } catch (e) {
      print('Error during get all certificate data: $e');
      return null;
    }
  }

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
  Future<List<EducationModel>?> educationGet(String? nama) async {
    try {
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV']}/api/v1/account/GetEducationAll',
      ).replace(queryParameters: {'nama': nama});
      List<EducationModel>? data;
      final response = await http.get(url);
      print(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        final List<dynamic> orgList = jsonData["data"]["data"];
        data = orgList
            .map<EducationModel>((item) => EducationModel.fromJson(item))
            .toList();
        return data;
      } else {
        final dataFailed = jsonDecode(response.body);
        print('Gagal: ${response.statusCode} $dataFailed');
        return null;
      }
    } catch (e) {
      print('Error during get all education data: $e');
      return null;
    }
  }

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
  Future<List<WorkExperienceModel>?> workExperienceGet(String? nama) async {
    try {
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV']}/api/v1/account/GetExperienceAll',
      ).replace(queryParameters: {'nama': nama});
      List<WorkExperienceModel>? data;
      final response = await http.get(url);
      print(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        final List<dynamic> orgList = jsonData["data"]["data"];
        data = orgList
            .map<WorkExperienceModel>(
              (item) => WorkExperienceModel.fromJson(item),
            )
            .toList();
        return data;
      } else {
        final dataFailed = jsonDecode(response.body);
        print('Gagal: ${response.statusCode} $dataFailed');
        return null;
      }
    } catch (e) {
      print('Error during get all certificate data: $e');
      return null;
    }
  }

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

  // Organization
  Future<List<OrganizationModel>?> organizationGet(String? nama) async {
    try {
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV']}/api/v1/account/GetOrganizationAll',
      ).replace(queryParameters: {'nama': nama});
      List<OrganizationModel>? data;
      final response = await http.get(url);
      print(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        final List<dynamic> orgList = jsonData["data"]["data"];
        data = orgList
            .map<OrganizationModel>((item) => OrganizationModel.fromJson(item))
            .toList();
        return data;
      } else {
        final dataFailed = jsonDecode(response.body);
        print('Gagal: ${response.statusCode} $dataFailed');
        return null;
      }
    } catch (e) {
      print('Error during get all organization data: $e');
      return null;
    }
  }

  Future<OrganizationResponse> organizationAdd(
    OrganizationRequest organization,
  ) async {
    try {
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_USER']}/api/v1/profile-management/add-organization',
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(organization.toJson()),
      );
      print(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        OrganizationResponse organizationResponse =
            OrganizationResponse.fromJson(jsonData);
        return organizationResponse;
      } else {
        final Map<String, dynamic> dataFailed = jsonDecode(response.body);

        print('Gagal: ${response.statusCode} $dataFailed');
        return OrganizationResponse.fromJson(dataFailed);
      }
    } catch (e) {
      print('Error during add organization: $e');
      return OrganizationResponse(
        responseCode: '500',
        responseMessage: 'Failed',
        data: null,
      );
    }
  }

  Future<OrganizationResponse> organizationEdit(
    OrganizationRequest organization,
  ) async {
    try {
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_USER']}/api/v1/profile-management/update-organization',
      );
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(organization.toJson()),
      );
      print(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        OrganizationResponse organizationResponse =
            OrganizationResponse.fromJson(jsonData);
        return organizationResponse;
      } else {
        final Map<String, dynamic> dataFailed = jsonDecode(response.body);
        print('Gagal: ${response.statusCode} $dataFailed');
        return OrganizationResponse.fromJson(dataFailed);
      }
    } catch (e) {
      print('Error during edit organization: $e');
      return OrganizationResponse(
        responseCode: '500',
        responseMessage: 'Failed',
        data: null,
      );
    }
  }

  Future<OrganizationResponse> organizationDelete(String id) async {
    try {
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_USER']}/api/v1/profile-management/delete-organization',
      ).replace(queryParameters: {'idUserOrganization': id});
      final response = await http.delete(url);
      print(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        OrganizationResponse organizationResponse =
            OrganizationResponse.fromJson(jsonData);
        return organizationResponse;
      } else {
        final dataFailed = jsonDecode(response.body);
        print('Gagal: ${response.statusCode} $dataFailed');
        return OrganizationResponse.fromJson(dataFailed);
      }
    } catch (e) {
      print('Error during delete organization: $e');
      return OrganizationResponse(
        responseCode: '500',
        responseMessage: 'Failed',
        data: null,
      );
    }
  }

  // User Preference
  Future<PreferenceResponse> preferenceAdd(PreferenceRequest preference) async {
    try {
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_USER']}/api/v1/profile-management/add-preference',
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(preference.toJson()),
      );
      print(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        PreferenceResponse preferenceResponse = PreferenceResponse.fromJson(
          jsonData,
        );
        return preferenceResponse;
      } else {
        final Map<String, dynamic> dataFailed = jsonDecode(response.body);

        print('Gagal: ${response.statusCode} $dataFailed');
        return PreferenceResponse.fromJson(dataFailed);
      }
    } catch (e) {
      print('Error during add preference: $e');
      return PreferenceResponse(
        responseCode: '500',
        responseMessage: 'Failed',
        data: null,
      );
    }
  }

  Future<PreferenceResponse> preferenceEdit(
    PreferenceRequest preference,
  ) async {
    try {
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_USER']}/api/v1/profile-management/update-preference',
      );
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(preference.toJson()),
      );
      print(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        PreferenceResponse preferenceResponse = PreferenceResponse.fromJson(
          jsonData,
        );
        return preferenceResponse;
      } else {
        final Map<String, dynamic> dataFailed = jsonDecode(response.body);

        print('Gagal: ${response.statusCode} $dataFailed');
        return PreferenceResponse.fromJson(dataFailed);
      }
    } catch (e) {
      print('Error during edit preference: $e');
      return PreferenceResponse(
        responseCode: '500',
        responseMessage: 'Failed',
        data: null,
      );
    }
  }

  // Skill
  Future<List<SkillModel>?> skillGet(String? nama) async {
    try {
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV']}/api/v1/account/GetSkillAll',
      ).replace(queryParameters: {'nama': nama});
      List<SkillModel>? data;
      final response = await http.get(url);
      print(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        final List<dynamic> orgList = jsonData["data"]["data"];
        data = orgList
            .map<SkillModel>((item) => SkillModel.fromJson(item))
            .toList();
        return data;
      } else {
        final dataFailed = jsonDecode(response.body);
        print('Gagal: ${response.statusCode} $dataFailed');
        return null;
      }
    } catch (e) {
      print('Error during get all skill data: $e');
      return null;
    }
  }

  Future<SkillResponse> skillEdit(SkillRequest skill) async {
    try {
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_USER']}/api/v1/profile-management/update-skill',
      );
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(skill.toJson()),
      );
      print(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        SkillResponse skillResponse = SkillResponse.fromJson(jsonData);
        return skillResponse;
      } else {
        final Map<String, dynamic> dataFailed = jsonDecode(response.body);

        print('Gagal: ${response.statusCode} $dataFailed');
        return SkillResponse.fromJson(dataFailed);
      }
    } catch (e) {
      print('Error during edit skills: $e');
      return SkillResponse(
        responseCode: '500',
        responseMessage: 'Failed',
        data: null,
      );
    }
  }
}
