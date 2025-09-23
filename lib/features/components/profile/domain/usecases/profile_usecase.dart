import 'package:job_platform/features/components/profile/data/models/certificateModel.dart';
import 'package:job_platform/features/components/profile/data/models/certificateResponse.dart';
import 'package:job_platform/features/components/profile/data/models/educationModel.dart';
import 'package:job_platform/features/components/profile/data/models/educationResponse.dart';
import 'package:job_platform/features/components/profile/data/models/profileModel.dart';

import '../repositories/auth_repository.dart';

class ProfileUsecase {
  final AuthRepository repository;

  ProfileUsecase(this.repository);

  Future<ProfileModel?> getProfile(String id) {
    return repository.profile(id);
  }

  // Certificate
  Future<CertificateResponse> addCertificate(CertificateModel certificate) {
    return repository.certificateAdd(certificate);
  }

  Future<CertificateResponse> editCertificate(CertificateModel certificate) {
    return repository.certificateEdit(certificate);
  }

  Future<CertificateResponse> deleteCertificate(String id) {
    return repository.certificateDelete(id);
  }

  // Education
  Future<EducationResponse> addEducation(EducationModel education) {
    return repository.educationAdd(education);
  }

  Future<EducationResponse> editEducation(EducationModel education) {
    return repository.educationEdit(education);
  }
  
  Future<EducationResponse> deleteEducation(String id) {
    return repository.educationDelete(id);
  }
}
