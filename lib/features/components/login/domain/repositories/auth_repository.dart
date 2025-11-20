import 'package:job_platform/features/components/login/data/models/loginModel.dart';

abstract class AuthRepository {
  Future<loginModel?> login(String email);
  Future<String?> login2FA(
    String userId,
    String email,
    String loginAs,
    String desc,
  );
}
