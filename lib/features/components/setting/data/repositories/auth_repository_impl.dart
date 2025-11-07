import 'package:job_platform/features/components/login/data/models/loginModel.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/aut_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<String?> change2FA(
    String userId,
    String loginAs,
    String email,
    bool isActive,
  ) async {
    final result = await remoteDataSource.change2FA(
      userId,
      loginAs,
      email,
      isActive,
    );
    return result;
  }

  @override
  Future<String?> changeEmailAccount(
    String userId,
    String loginAs,
    String oldEmail,
    String newEmail,
  ) async {
    final result = await remoteDataSource.changeEmailAccount(
      userId,
      loginAs,
      oldEmail,
      newEmail,
    );
    return result;
  }

  @override
  Future<String?> changeExternalNotifApp(String userId, String loginAs) async {
    final result = await remoteDataSource.changeExternalNotifApp(
      userId,
      loginAs,
    );
    return result;
  }

  @override
  Future<String?> logOut(String userId, String loginAs) async {
    final result = await remoteDataSource.logOut(userId, loginAs);
    return result;
  }

  @override
  Future<String?> changeFontSize(
    String userId,
    String loginAs,
    int fontSizeHead,
    int fontSizeSubHead,
    int fontSizeBody,
    int fontSizeIcon,
  ) async {
    final result = await remoteDataSource.changeFontSize(
      userId,
      loginAs,
      fontSizeHead,
      fontSizeSubHead,
      fontSizeBody,
      fontSizeIcon,
    );
    return result;
  }

  @override
  Future<String?> changeLanguage(
    String userId,
    String loginAs,
    String language,
  ) async {
    final result = await remoteDataSource.changeLanguage(
      userId,
      loginAs,
      language,
    );
    return result;
  }

  @override
  Future<String?> changeNotifApp(String userId, String loginAs) async {
    final result = await remoteDataSource.changeNotifApp(userId, loginAs);
    return result;
  }

  @override
  Future<String?> changeThemeMode(String userId, String loginAs) async {
    final result = await remoteDataSource.changeThemeMode(userId, loginAs);
    return result;
  }

  @override
  Future<String?> deleteAccount(String userId, String loginAs) async {
    final result = await remoteDataSource.deleteAccount(userId, loginAs);
    return result;
  }

  @override
  Future<String?> upgradePlan(String userId, String loginAs) async {
    final result = await remoteDataSource.upgradePlan(userId, loginAs);
    return result;
  }

  @override
  Future<String?> validate2FA(
    String userId,
    String loginAs,
    String email,
    String otp,
    String desc,
  ) async {
    final result = await remoteDataSource.validate2FA(
      userId,
      loginAs,
      email,
      otp,
      desc,
    );
    return result;
  }
}
