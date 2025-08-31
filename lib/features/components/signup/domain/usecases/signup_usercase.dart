import 'package:job_platform/features/components/signup/domain/entities/kota.dart';
import 'package:job_platform/features/components/signup/domain/entities/provinsi.dart';
import 'package:job_platform/features/components/signup/domain/entities/signUpRequest.dart';
import 'package:job_platform/features/components/signup/domain/entities/signupResponse.dart';
import '../repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  Future<SignupResponseModel> SignUpAction(SignupRequestModel data) {
    return repository.signup(data);
  }

  Future<List<ProvinsiModel>> getProvinsi() {
    return repository.getProvinsi();
  }

  Future<List<KotaModel>> getKota(String code) {
    return repository.getKota(code);
  }
}
