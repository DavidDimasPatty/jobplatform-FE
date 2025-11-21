import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:job_platform/core/utils/storage/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingProvider extends ChangeNotifier {
  var storage = StorageService();
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
      nama = await storage.get('nama');
      loginAs = await storage.get('loginAs');
      url = await storage.get('urlAva');

      final profileStr = await storage.get('profileComplete');
      profileComplete = profileStr != null ? int.parse(profileStr) : null;

      isPremium = (await storage.get("isPremium")) == "true";
      is2FA = (await storage.get("is2FA")) == "true";
      isNotifInternal = (await storage.get("isNotifInternal")) == "true";
      isNotifExternal = (await storage.get("isNotifExternal")) == "true";
      isDarkMode = (await storage.get("isDarkMode")) == "true";

      language = await storage.get("language");

      fontSizeHead = int.tryParse(await storage.get("fontSizeHead") ?? "");
      fontSizeSubHead = int.tryParse(
        await storage.get("fontSizeSubHead") ?? "",
      );
      fontSizeBody = int.tryParse(await storage.get("fontSizeBody") ?? "");
      fontSizeIcon = int.tryParse(await storage.get("fontSizeIcon") ?? "");

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
    await storage.save("language", lang);
    notifyListeners();
  }

  Future<void> changePremium(bool isPremiumInput) async {
    isPremium = isPremiumInput;
    await storage.save("isPremium", isPremiumInput.toString());
    notifyListeners();
  }

  Future<void> changeNotifApp(bool notifApp) async {
    isNotifInternal = notifApp;
    await storage.save("isNotifInternal", notifApp.toString());
    notifyListeners();
  }

  Future<void> changeNotifExternalApp(bool notifExApp) async {
    isNotifExternal = notifExApp;
    await storage.save("isNotifExternal", notifExApp.toString());
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

    await storage.save("fontSizeHead", this.fontSizeHead.toString());
    await storage.save("fontSizeSubHead", this.fontSizeSubHead.toString());
    await storage.save("fontSizeBody", this.fontSizeBody.toString());
    await storage.save("fontSizeIcon", this.fontSizeIcon.toString());

    notifyListeners();
  }
}
