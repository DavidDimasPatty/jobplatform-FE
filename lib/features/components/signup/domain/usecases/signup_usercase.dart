import 'package:job_platform/features/components/signup/domain/entities/kota.dart';
import 'package:job_platform/features/components/signup/domain/entities/provinsi.dart';
import 'package:job_platform/features/components/signup/domain/entities/signup.dart';
import '../repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  Future<SignupModel> SignUpAction(String email, String password) {
    return repository.signup(email, password);
  }

  Future<List<ProvinsiModel>> getProvinsi() {
    return repository.getProvinsi();
  }

  Future<List<KotaModel>> getKota(String code) {
    return repository.getKota(code);
  }
}
