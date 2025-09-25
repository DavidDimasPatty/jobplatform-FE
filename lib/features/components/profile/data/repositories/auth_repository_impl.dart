import 'package:job_platform/features/components/profile/data/models/certificateRequest.dart';
import 'package:job_platform/features/components/profile/data/models/certificateResponse.dart';
import 'package:job_platform/features/components/profile/data/models/educationRequest.dart';
import 'package:job_platform/features/components/profile/data/models/educationResponse.dart';
import 'package:job_platform/features/components/profile/data/models/organizationRequest.dart';
import 'package:job_platform/features/components/profile/data/models/organizationResponse.dart';
import 'package:job_platform/features/components/profile/data/models/preferenceRequest.dart';
import 'package:job_platform/features/components/profile/data/models/preferenceResponse.dart';
import 'package:job_platform/features/components/profile/data/models/profileModel.dart';
import 'package:job_platform/features/components/profile/data/models/workExperienceRequest.dart';
import 'package:job_platform/features/components/profile/data/models/workExperienceResponse.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/aut_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<ProfileModel?> profile(String id) async {
    final profileModel = await remoteDataSource.profileGet(id);
    // print(profileModel);
    return profileModel;
  }

  // Certificate
  @override
  Future<CertificateResponse> certificateAdd(
    CertificateRequest certificate,
  ) async {
    final result = await remoteDataSource.certificateAdd(certificate);
    return result;
  }

  @override
  Future<CertificateResponse> certificateEdit(
    CertificateRequest certificate,
  ) async {
    final result = await remoteDataSource.certificateEdit(certificate);
    return result;
  }

  @override
  Future<CertificateResponse> certificateDelete(String id) async {
    final result = await remoteDataSource.certificateDelete(id);
    return result;
  }

  // Education
  @override
  Future<EducationResponse> educationAdd(EducationRequest education) async {
    final result = await remoteDataSource.educationAdd(education);
    return result;
  }

  @override
  Future<EducationResponse> educationEdit(EducationRequest education) async {
    final result = await remoteDataSource.educationEdit(education);
    return result;
  }

  @override
  Future<EducationResponse> educationDelete(String id) async {
    final result = await remoteDataSource.educationDelete(id);
    return result;
  }

  // Work Experience
  @override
  Future<WorkExperienceResponse> experienceAdd(
    WorkExperienceRequest workExperience,
  ) async {
    final result = await remoteDataSource.workExperienceAdd(workExperience);
    return result;
  }

  @override
  Future<WorkExperienceResponse> experienceEdit(
    WorkExperienceRequest workExperience,
  ) async {
    final result = await remoteDataSource.workExperienceEdit(workExperience);
    return result;
  }

  @override
  Future<WorkExperienceResponse> experienceDelete(String id) async {
    final result = await remoteDataSource.workExperienceDelete(id);
    return result;
  }

  // Organization
  @override
  Future<OrganizationResponse> organizationAdd(
    OrganizationRequest organization,
  ) async {
    final result = await remoteDataSource.organizationAdd(organization);
    return result;
  }

  @override
  Future<OrganizationResponse> organizationEdit(
    OrganizationRequest organization,
  ) async {
    final result = await remoteDataSource.organizationEdit(organization);
    return result;
  }

  @override
  Future<OrganizationResponse> organizationDelete(String id) async {
    final result = await remoteDataSource.organizationDelete(id);
    return result;
  }

  // User Preference
  @override
  Future<PreferenceResponse> preferenceAdd(
    PreferenceRequest preference,
  ) async {
    final result = await remoteDataSource.preferenceAdd(preference);
    return result;
  }

  @override
  Future<PreferenceResponse> preferenceEdit(
    PreferenceRequest preference,
  ) async {
    final result = await remoteDataSource.preferenceEdit(preference);
    return result;
  }
}
