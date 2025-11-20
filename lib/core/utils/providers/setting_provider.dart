import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingProvider extends ChangeNotifier {
  FlutterSecureStorage storage = const FlutterSecureStorage();
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
      nama = await storage.read(key: 'nama');
      loginAs = await storage.read(key: 'loginAs');
      url = await storage.read(key: 'urlAva');

      final profileStr = await storage.read(key: 'profileComplete');
      profileComplete = profileStr != null ? int.parse(profileStr) : null;

      isPremium = (await storage.read(key: "isPremium")) == "true";
      is2FA = (await storage.read(key: "is2FA")) == "true";
      isNotifInternal = (await storage.read(key: "isNotifInternal")) == "true";
      isNotifExternal = (await storage.read(key: "isNotifExternal")) == "true";
      isDarkMode = (await storage.read(key: "isDarkMode")) == "true";

      language = await storage.read(key: "language");

      fontSizeHead = int.tryParse(
        await storage.read(key: "fontSizeHead") ?? "",
      );
      fontSizeSubHead = int.tryParse(
        await storage.read(key: "fontSizeSubHead") ?? "",
      );
      fontSizeBody = int.tryParse(
        await storage.read(key: "fontSizeBody") ?? "",
      );
      fontSizeIcon = int.tryParse(
        await storage.read(key: "fontSizeIcon") ?? "",
      );

      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> changeLanguage(String lang) async {
    language = lang;
    await storage.write(key: "language", value: lang);
    notifyListeners();
  }

  Future<void> changePremium(bool isPremiumInput) async {
    isPremium = isPremiumInput;
    await storage.write(key: "isPremium", value: isPremiumInput.toString());
    notifyListeners();
  }

  Future<void> changeNotifApp(bool notifApp) async {
    isNotifInternal = notifApp;
    await storage.write(key: "isNotifInternal", value: notifApp.toString());
    notifyListeners();
  }

  Future<void> changeNotifExternalApp(bool notifExApp) async {
    isNotifExternal = notifExApp;
    await storage.write(key: "isNotifExternal", value: notifExApp.toString());
    notifyListeners();
  }

  Future<void> changeFontSize(
    String fontSizeHead,
    String fontSizeSubHead,
    String fontSizeBody,
    String fontSizeIcon,
  ) async {
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

    await storage.write(
      key: "fontSizeHead",
      value: this.fontSizeHead.toString(),
    );
    await storage.write(
      key: "fontSizeSubHead",
      value: this.fontSizeSubHead.toString(),
    );
    await storage.write(
      key: "fontSizeBody",
      value: this.fontSizeBody.toString(),
    );
    await storage.write(
      key: "fontSizeIcon",
      value: this.fontSizeIcon.toString(),
    );

    notifyListeners();
  }
}
