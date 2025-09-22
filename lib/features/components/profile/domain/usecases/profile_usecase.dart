import 'package:job_platform/features/components/profile/data/models/certificateModel.dart';
import 'package:job_platform/features/components/profile/data/models/certificateResponse.dart';
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

  Future<bool> deleteCertificate(String id) {
    return repository.certificateDelete(id);
  }
}
