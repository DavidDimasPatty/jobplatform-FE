import 'package:job_platform/features/components/login/data/models/loginModel.dart';

import '../entities/loginData.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<loginModel?> execute(String email) {
    return repository.login(email);
  }
}
