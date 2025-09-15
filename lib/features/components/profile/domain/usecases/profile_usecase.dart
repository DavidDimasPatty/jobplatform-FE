import 'package:job_platform/features/components/login/data/models/loginModel.dart';

import '../repositories/auth_repository.dart';

class ProfileUsecase {
  final AuthRepository repository;

  ProfileUsecase(this.repository);

  Future<loginModel?> execute(String email) {
    return repository.login(email);
  }
}
