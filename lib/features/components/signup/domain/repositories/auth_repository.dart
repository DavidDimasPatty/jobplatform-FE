import 'package:job_platform/features/components/signup/domain/entities/kota.dart';
import 'package:job_platform/features/components/signup/domain/entities/provinsi.dart';
import 'package:job_platform/features/components/signup/domain/entities/signUpRequest.dart';
import 'package:job_platform/features/components/signup/domain/entities/signupResponse.dart';

abstract class AuthRepository {
  Future<SignupResponseModel> signup(SignupRequestModel data);
  Future<List<ProvinsiModel>> getProvinsi();
  Future<List<KotaModel>> getKota(String code);
}
