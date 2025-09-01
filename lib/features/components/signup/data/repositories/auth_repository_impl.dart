import 'package:job_platform/features/components/signup/domain/entities/kota.dart';
import 'package:job_platform/features/components/signup/domain/entities/provinsi.dart';
import 'package:job_platform/features/components/signup/domain/entities/signUpRequest.dart';
import 'package:job_platform/features/components/signup/domain/entities/userData.dart';
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
      responseCode: userModel.responseCode,
      responseMessages: userModel.responseMessages,
      user: userModel.user != null
          ? UserData(
              id: userModel.user!.id,
              nama: userModel.user!.nama,
              email: userModel.user!.email,
              tanggalLahir: userModel.user!.tanggalLahir,
              tempatLahir: userModel.user!.tempatLahir,
              jenisKelamin: userModel.user!.jenisKelamin,
              lastLogin: userModel.user!.lastLogin,
              statusAccount: userModel.user!.statusAccount,
              addTime: userModel.user!.addTime,
              updTime: userModel.user!.updTime,
              noTelp: userModel.user!.noTelp,
            )
          : null,
    );
  }

  @override
  Future<List<ProvinsiModel>> getProvinsi() async {
    final provinsiModel = await remoteDataSource.getProvinsi();
    return provinsiModel
        .map((e) => ProvinsiModel(id: e.id, nama: e.nama))
        .toList();
  }

  @override
  Future<List<KotaModel>> getKota(String code) async {
    final kotaModel = await remoteDataSource.getKota(code);
    return kotaModel.map((e) => KotaModel(id: e.id, nama: e.nama)).toList();
  }
}
