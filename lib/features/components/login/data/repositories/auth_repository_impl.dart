import 'package:job_platform/features/components/login/data/models/loginModel.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/aut_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<loginModel?> login(String email) async {
    final userModel = await remoteDataSource.login(email);
    //print(userModel);
    return userModel;
  }

  @override
  Future<String?> login2FA(
    String userId,
    String email,
    String loginAs,
    String desc,
  ) async {
    final result = await remoteDataSource.login2FA(
      userId,
      email,
      loginAs,
      desc,
    );
    return result;
  }
}
