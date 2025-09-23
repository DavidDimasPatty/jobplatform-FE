import 'package:job_platform/features/components/profile/data/models/certificateModel.dart';
import 'package:job_platform/features/components/profile/data/models/certificateResponse.dart';
import 'package:job_platform/features/components/profile/data/models/educationModel.dart';
import 'package:job_platform/features/components/profile/data/models/educationResponse.dart';
import 'package:job_platform/features/components/profile/data/models/profileModel.dart';
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
    CertificateModel certificate,
  ) async {
    final result = await remoteDataSource.certificateAdd(certificate);
    return result;
  }

  @override
  Future<CertificateResponse> certificateEdit(
    CertificateModel certificate,
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
  Future<EducationResponse> educationAdd(EducationModel education) async {
    final result = await remoteDataSource.educationAdd(education);
    return result;
  }

  @override
  Future<EducationResponse> educationEdit(EducationModel education) async {
    final result = await remoteDataSource.educationEdit(education);
    return result;
  }

  @override
  Future<EducationResponse> educationDelete(String id) async {
    final result = await remoteDataSource.educationDelete(id);
    return result;
  }
}