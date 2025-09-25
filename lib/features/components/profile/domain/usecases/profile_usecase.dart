import 'package:job_platform/features/components/profile/data/models/certificateRequest.dart';
import 'package:job_platform/features/components/profile/data/models/certificateResponse.dart';
import 'package:job_platform/features/components/profile/data/models/educationModel.dart';
import 'package:job_platform/features/components/profile/data/models/educationRequest.dart';
import 'package:job_platform/features/components/profile/data/models/educationResponse.dart';
import 'package:job_platform/features/components/profile/data/models/profileModel.dart';
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

  // Certificate
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
}
