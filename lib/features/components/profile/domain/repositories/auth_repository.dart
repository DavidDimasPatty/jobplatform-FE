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

abstract class AuthRepository {
  Future<ProfileModel?> profile(String id);
  // Certificate
  Future<CertificateResponse> certificateAdd(CertificateRequest certificate);
  Future<CertificateResponse> certificateEdit(CertificateRequest certificate);
  Future<CertificateResponse> certificateDelete(String id);
  // Education
  Future<EducationResponse> educationAdd(EducationRequest education);
  Future<EducationResponse> educationEdit(EducationRequest education);
  Future<EducationResponse> educationDelete(String id);
  // Work Experience
  Future<WorkExperienceResponse> experienceAdd(WorkExperienceRequest experience);
  Future<WorkExperienceResponse> experienceEdit(WorkExperienceRequest experience);
  Future<WorkExperienceResponse> experienceDelete(String id);
  // Organization
  Future<OrganizationResponse> organizationAdd(OrganizationRequest organization);
  Future<OrganizationResponse> organizationEdit(OrganizationRequest organization);
  Future<OrganizationResponse> organizationDelete(String id);
  // User Preference
  Future<PreferenceResponse> preferenceAdd(PreferenceRequest preference);
  Future<PreferenceResponse> preferenceEdit(PreferenceRequest preference);
  // Skill
  // Personal Info
}
