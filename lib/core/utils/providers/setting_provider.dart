import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingProvider extends ChangeNotifier {
  bool isLoading = true;
  String? errorMessage;
  String? nama;
  String? loginAs;
  String? url;
  bool? is2FA;
  bool? isNotifInternal;
  bool? isNotifExternal;
  bool? isPremium;
  bool? isDarkMode;
  String? language;
  int? fontSizeHead;
  int? fontSizeSubHead;
  int? fontSizeBody;
  int? fontSizeIcon;
  int? profileComplete;

  Future<void> loadSetting() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      nama = prefs.getString('nama');
      loginAs = prefs.getString('loginAs');
      url = prefs.getString('urlAva');
      profileComplete = prefs.getInt("profileComplete");
      isPremium = prefs.getBool("isPremium");
      is2FA = prefs.getBool("is2FA");
      isNotifInternal = prefs.getBool("isNotifInternal");
      isNotifExternal = prefs.getBool("isNotifExternal");
      isDarkMode = prefs.getBool("isDarkMode");
      language = prefs.getString("language");
      fontSizeHead = prefs.getInt("fontSizeHead");
      fontSizeSubHead = prefs.getInt("fontSizeSubHead");
      fontSizeBody = prefs.getInt("fontSizeBody");
      fontSizeIcon = prefs.getInt("fontSizeIcon");

      notifyListeners();
    } catch (e) {
      notifyListeners();
    }
  }

  Future<void> changeLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    language = lang;
    await prefs.setString("language", lang);
    notifyListeners();
  }

  Future<void> changePremium(bool isPremiumInput) async {
    final prefs = await SharedPreferences.getInstance();
    isPremium = isPremiumInput;
    await prefs.setBool("isPremium", isPremiumInput);
    notifyListeners();
  }

  Future<void> changeNotifApp(bool notifApp) async {
    final prefs = await SharedPreferences.getInstance();
    isNotifInternal = notifApp;
    await prefs.setBool("isNotifInternal", notifApp);
    notifyListeners();
  }

  Future<void> changeNotifExternalApp(bool notifExApp) async {
    final prefs = await SharedPreferences.getInstance();
    isNotifExternal = notifExApp;
    await prefs.setBool("isNotifExternal", notifExApp);
    notifyListeners();
  }

  Future<void> changeFontSize(
    String fontSizeHead,
    String fontSizeSubHead,
    String fontSizeBody,
    String fontSizeIcon,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    this.fontSizeHead = fontSizeHead == "big"
        ? 22
        : fontSizeHead == "medium"
        ? 18
        : 14;
    this.fontSizeSubHead = fontSizeSubHead == "big"
        ? 20
        : fontSizeSubHead == "medium"
        ? 16
        : 12;
    this.fontSizeBody = fontSizeBody == "big"
        ? 18
        : fontSizeBody == "medium"
        ? 14
        : 10;
    this.fontSizeIcon = fontSizeIcon == "big"
        ? 16
        : fontSizeIcon == "medium"
        ? 12
        : 8;

    await prefs.setInt("fontSizeHead", this.fontSizeHead!);
    await prefs.setInt("fontSizeSubHead", this.fontSizeSubHead!);
    await prefs.setInt("fontSizeBody", this.fontSizeBody!);
    await prefs.setInt("fontSizeIcon", this.fontSizeIcon!);

    notifyListeners();
  }
}
