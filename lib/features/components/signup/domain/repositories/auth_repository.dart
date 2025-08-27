import 'package:job_platform/features/components/signup/domain/entities/kota.dart';
import 'package:job_platform/features/components/signup/domain/entities/provinsi.dart';
import 'package:job_platform/features/components/signup/domain/entities/signup.dart';

abstract class AuthRepository {
  Future<SignupModel> signup(String email, String password);
  Future<List<ProvinsiModel>> getProvinsi();
  Future<List<KotaModel>> getKota(String code);
}
