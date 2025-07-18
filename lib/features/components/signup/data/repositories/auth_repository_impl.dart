import 'package:job_platform/features/components/signup/domain/repositories/auth_repository.dart';
import '../datasources/aut_remote_datasource.dart';
import 'package:job_platform/features/components/signup/domain/entities/signup.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDataSource;
  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<SignupModel> signup(String email, String password) async {
    final userModel = await remoteDataSource.signup(email, password);
    return SignupModel(
      status: userModel.status,
      responseMessages: userModel.responseMessages,
    );
  }
}
