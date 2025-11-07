abstract class AuthRepository {
  Future<String?> deleteAccount(String userId, String loginAs);
  Future<String?> changeThemeMode(String userId, String loginAs);
  Future<String?> upgradePlan(String userId, String loginAs);
  Future<String?> changeNotifApp(String userId, String loginAs);
  Future<String?> logOut(String userId, String loginAs);
  Future<String?> changeExternalNotifApp(String userId, String loginAs);
  Future<String?> changeEmailAccount(
    String userId,
    String loginAs,
    String oldEmail,
    String newEmail,
  );

  Future<String?> change2FA(
    String userId,
    String loginAs,
    String email,
    bool isActive,
  );

  Future<String?> validate2FA(
    String userId,
    String loginAs,
    String email,
    String otp,
    String desc,
  );

  Future<String?> changeLanguage(
    String userId,
    String loginAs,
    String language,
  );

  Future<String?> changeFontSize(
    String userId,
    String loginAs,
    int fontSizeHead,
    int fontSizeSubHead,
    int fontSizeBody,
    int fontSizeIcon,
  );
}
