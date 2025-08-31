import 'package:job_platform/features/components/signup/domain/entities/kota.dart';
import 'package:job_platform/features/components/signup/domain/entities/provinsi.dart';
import 'package:job_platform/features/components/signup/domain/entities/signUpRequest.dart';
import 'package:job_platform/features/components/signup/domain/repositories/auth_repository.dart';
import '../datasources/aut_remote_datasource.dart';
import 'package:job_platform/features/components/signup/domain/entities/signupResponse.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDataSource;
  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<SignupResponseModel> signup(SignupRequestModel data) async {
    final userModel = await remoteDataSource.signup(data);
    return SignupResponseModel(
      responseCode: userModel.status,
      responseMessages: userModel.responseMessages,
    );
  }

  @override
  Future<List<ProvinsiModel>> getProvinsi() async {
    final provinsiModel = await remoteDataSource.getProvinsi();
    return provinsiModel
        .map((e) => ProvinsiModel(code: e.code, nama: e.nama))
        .toList();
  }

  @override
  Future<List<KotaModel>> getKota(String code) async {
    final kotaModel = await remoteDataSource.getKota(code);
    return kotaModel.map((e) => KotaModel(code: e.code, nama: e.nama)).toList();
  }
}
