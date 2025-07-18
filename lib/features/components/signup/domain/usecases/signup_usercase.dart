import 'package:job_platform/features/components/signup/domain/entities/signup.dart';
import '../repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  Future<SignupModel> SignUpAction(String email, String password) {
    return repository.signup(email, password);
  }
}
