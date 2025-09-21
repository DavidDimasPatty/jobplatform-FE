import 'package:job_platform/features/components/profile/data/models/certificateModel.dart';
import 'package:job_platform/features/components/profile/data/models/profileModel.dart';

abstract class AuthRepository {
  Future<ProfileModel?> profile(String id);
  Future<CertificateModel?> certificateAdd(CertificateModel certificate);
  Future<CertificateModel?> certificateEdit(CertificateModel certificate);
  Future<bool> certificateDelete(String id);
}
