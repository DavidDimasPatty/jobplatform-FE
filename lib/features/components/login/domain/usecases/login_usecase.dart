import 'package:job_platform/features/components/login/data/models/loginModel.dart';

import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<loginModel?> execute(String email) {
    return repository.login(email);
  }

  Future<String?> login2FA(
    String userId,
    String email,
    String loginAs,
    String desc,
  ) {
    return repository.login2FA(userId, email, loginAs, desc);
  }
}
