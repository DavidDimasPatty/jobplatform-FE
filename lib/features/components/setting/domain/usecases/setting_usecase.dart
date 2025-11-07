import '../repositories/auth_repository.dart';

class SettingUseCase {
  final AuthRepository repository;

  SettingUseCase(this.repository);

  Future<String?> change2FA(
    String userId,
    String loginAs,
    String email,
    bool isActive,
  ) async {
    return await repository.change2FA(userId, loginAs, email, isActive);
  }

  Future<String?> changeEmailAccount(
    String userId,
    String loginAs,
    String oldEmail,
    String newEmail,
  ) async {
    return await repository.changeEmailAccount(
      userId,
      loginAs,
      oldEmail,
      newEmail,
    );
  }

  Future<String?> changeExternalNotifApp(String userId, String loginAs) async {
    return await repository.changeExternalNotifApp(userId, loginAs);
  }

  Future<String?> changeFontSize(
    String userId,
    String loginAs,
    int fontSizeHead,
    int fontSizeSubHead,
    int fontSizeBody,
    int fontSizeIcon,
  ) async {
    return await repository.changeFontSize(
      userId,
      loginAs,
      fontSizeHead,
      fontSizeSubHead,
      fontSizeBody,
      fontSizeIcon,
    );
  }

  Future<String?> changeLanguage(
    String userId,
    String loginAs,
    String language,
  ) async {
    return await repository.changeLanguage(userId, loginAs, language);
  }

  Future<String?> changeNotifApp(String userId, String loginAs) async {
    return await repository.changeNotifApp(userId, loginAs);
  }

  Future<String?> logOut(String userId, String loginAs) async {
    return await repository.logOut(userId, loginAs);
  }

  Future<String?> changeThemeMode(String userId, String loginAs) async {
    return await repository.changeThemeMode(userId, loginAs);
  }

  Future<String?> deleteAccount(String userId, String loginAs) async {
    return await repository.deleteAccount(userId, loginAs);
  }

  Future<String?> upgradePlan(String userId, String loginAs) async {
    return await repository.upgradePlan(userId, loginAs);
  }

  Future<String?> validate2FA(
    String userId,
    String loginAs,
    String email,
    String otp,
    String desc,
  ) async {
    return await repository.validate2FA(userId, loginAs, email, otp, desc);
  }
}
