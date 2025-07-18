import 'package:job_platform/features/components/signup/domain/entities/signup.dart';

abstract class AuthRepository {
  Future<SignupModel> signup(String email, String password);
}
