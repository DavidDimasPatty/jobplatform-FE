import 'package:job_platform/features/components/profile/data/models/certificateModel.dart';
import 'package:job_platform/features/components/profile/data/models/certificateResponse.dart';
import 'package:job_platform/features/components/profile/data/models/educationModel.dart';
import 'package:job_platform/features/components/profile/data/models/educationResponse.dart';
import 'package:job_platform/features/components/profile/data/models/profileModel.dart';

abstract class AuthRepository {
  Future<ProfileModel?> profile(String id);
  // Certificate
  Future<CertificateResponse> certificateAdd(CertificateModel certificate);
  Future<CertificateResponse> certificateEdit(CertificateModel certificate);
  Future<CertificateResponse> certificateDelete(String id);
  // Education
  Future<EducationResponse> educationAdd(EducationModel education);
  Future<EducationResponse> educationEdit(EducationModel education);
  Future<EducationResponse> educationDelete(String id);
}
