import 'package:job_platform/features/components/login/data/models/loginModel.dart';

import '../entities/loginData.dart';

abstract class AuthRepository {
  Future<loginModel?> login(String email);
}
