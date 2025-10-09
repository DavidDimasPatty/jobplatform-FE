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
import 'package:job_platform/features/components/profile/data/models/profileCompanyRequest.dart';
import 'package:job_platform/features/components/profile/data/models/profileModel.dart';
import 'package:job_platform/features/components/profile/data/models/profileRequest.dart';
import 'package:job_platform/features/components/profile/data/models/profileResponse.dart';
import 'package:job_platform/features/components/profile/data/models/skillModel.dart';
import 'package:job_platform/features/components/profile/data/models/skillRequest.dart';
import 'package:job_platform/features/components/profile/data/models/skillResponse.dart';
import 'package:job_platform/features/components/profile/data/models/workExperienceModel.dart';
import 'package:job_platform/features/components/profile/data/models/workExperienceRequest.dart';
import 'package:job_platform/features/components/profile/data/models/workExperienceResponse.dart';
import 'package:job_platform/features/components/profile/domain/entities/ProfileCompanyData.dart';
import 'package:job_platform/features/components/profile/persentation/pages/profile/skillEdit.dart';
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

  @override
  Future<ProfileCompanydata?> profileCompany(String id) async {
    final profileModel = await remoteDataSource.profileCompanyGet(id);
    // print(profileModel);
    return profileModel;
  }

  @override
  Future<ProfileResponse> editProfile(ProfileRequest profile) async {
    final result = await remoteDataSource.profileEdit(profile);
    return result;
  }

  @override
  Future<ProfileResponse> editProfileCompany(
    ProfileCompanyRequest profile,
  ) async {
    final result = await remoteDataSource.profileEditCompany(profile);
    return result;
  }

  @override
  Future<ProfileResponse> editProfileAvatar(ProfileRequest profile) async {
    final result = await remoteDataSource.profileAvatarEdit(profile);
    return result;
  }

  @override
  Future<ProfileResponse> editProfileAvatarCompany(
    ProfileCompanyRequest profile,
  ) async {
    final result = await remoteDataSource.profileAvatarCompanyEdit(profile);
    return result;
  }

  @override
  Future<ProfileResponse> editProfilePrivacy(ProfileRequest profile) async {
    final result = await remoteDataSource.profilePrivacyEdit(profile);
    return result;
  }

  // Certificate
  @override
  Future<List<CertificateModel>?> certificateGetAll(String? name) async {
    final result = await remoteDataSource.certificateGet(name);
    return result;
  }

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
  Future<List<EducationModel>?> educationGetAll(String? name) async {
    final result = await remoteDataSource.educationGet(name);
    return result;
  }

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
  Future<List<WorkExperienceModel>?> experienceGetAll(String? name) async {
    final result = await remoteDataSource.workExperienceGet(name);
    return result;
  }

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
  Future<List<OrganizationModel>?> organizationGetAll(String? name) async {
    final result = await remoteDataSource.organizationGet(name);
    return result;
  }

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
  Future<PreferenceResponse> preferenceAdd(PreferenceRequest preference) async {
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

  // Skill
  @override
  Future<List<SkillModel>?> skillGetAll(String? name) async {
    final result = await remoteDataSource.skillGet(name);
    return result;
  }

  @override
  Future<SkillResponse> skillEdit(SkillRequest skill) async {
    final result = await remoteDataSource.skillEdit(skill);
    return result;
  }
}
