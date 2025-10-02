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
import 'package:job_platform/features/components/profile/data/models/workExperienceModel.dart';
import 'package:job_platform/features/components/profile/data/models/workExperienceRequest.dart';
import 'package:job_platform/features/components/profile/data/models/workExperienceResponse.dart';

import '../repositories/auth_repository.dart';

class ProfileUsecase {
  final AuthRepository repository;

  ProfileUsecase(this.repository);

  Future<ProfileModel?> getProfile(String id) {
    return repository.profile(id);
  }

  Future<ProfileResponse> editProfile(ProfileRequest profile){
    return repository.editProfile(profile);
  }

  Future<ProfileResponse> editProfileAvatar(ProfileRequest profile){
    return repository.editProfileAvatar(profile);
  }

  Future<ProfileResponse> editProfilePrivacy(ProfileRequest profile){
    return repository.editProfilePrivacy(profile);
  }

  // Certificate
  Future<List<CertificateModel>?> getAllCertificate(String? name){
    return repository.certificateGetAll(name);
  }

  Future<CertificateResponse> addCertificate(CertificateRequest certificate) {
    return repository.certificateAdd(certificate);
  }

  Future<CertificateResponse> editCertificate(CertificateRequest certificate) {
    return repository.certificateEdit(certificate);
  }

  Future<CertificateResponse> deleteCertificate(String id) {
    return repository.certificateDelete(id);
  }

  // Education
  Future<List<EducationModel>?> getAllEducation(String? name){
    return repository.educationGetAll(name);
  }

  Future<EducationResponse> addEducation(EducationRequest education) {
    return repository.educationAdd(education);
  }

  Future<EducationResponse> editEducation(EducationRequest education) {
    return repository.educationEdit(education);
  }

  Future<EducationResponse> deleteEducation(String id) {
    return repository.educationDelete(id);
  }

  // Work Experience
  Future<List<WorkExperienceModel>?> getAllExperience(String? name){
    return repository.experienceGetAll(name);
  }

  Future<WorkExperienceResponse> addWorkExperience(
    WorkExperienceRequest workExperience,
  ) {
    return repository.experienceAdd(workExperience);
  }

  Future<WorkExperienceResponse> editWorkExperience(
    WorkExperienceRequest workExperience,
  ) {
    return repository.experienceEdit(workExperience);
  }

  Future<WorkExperienceResponse> deleteWorkExperience(String id) {
    return repository.experienceDelete(id);
  }

  // Organization
  Future<List<OrganizationModel>?> getAllOrganization(String? name){
    return repository.organizationGetAll(name);
  }

  Future<OrganizationResponse> addOrganization(
    OrganizationRequest organization,
  ) {
    return repository.organizationAdd(organization);
  }

  Future<OrganizationResponse> editOrganization(
    OrganizationRequest organization,
  ) {
    return repository.organizationEdit(organization);
  }

  Future<OrganizationResponse> deleteOrganization(String id) {
    return repository.organizationDelete(id);
  }

  // User Preference
  Future<PreferenceResponse> addPreference(PreferenceRequest preference) {
    return repository.preferenceAdd(preference);
  }

  Future<PreferenceResponse> editPreference(PreferenceRequest preference) {
    return repository.preferenceEdit(preference);
  }

  // Skill
  Future<List<SkillModel>?> getAllSkill(String? name){
    return repository.skillGetAll(name);
  }
}
