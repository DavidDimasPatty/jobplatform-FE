import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/aut_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<User?> login(String email, String password) async {
    final userModel = await remoteDataSource.login(email, password);
    print(userModel!.id);
    if (userModel == null || userModel.id == null) {
      return null;
    }

    //print(userModel);
    return User(id: userModel.id!, nama: userModel.nama ?? '');
  }
}
