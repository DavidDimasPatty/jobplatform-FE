import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_platform/features/components/setting/data/datasources/aut_remote_datasource.dart';
import 'package:job_platform/features/components/setting/data/repositories/auth_repository_impl.dart';
import 'package:job_platform/features/components/setting/domain/usecases/setting_usecase.dart';
import 'package:job_platform/features/components/setting/persentation/widgets/bodySetting.dart';
import 'package:job_platform/features/components/setting/persentation/widgets/topSetting.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _Setting();
}

class _Setting extends State<Setting> {
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
  final String packageName = 'com.whatsapp';
  AuthRepositoryImpl? _repoSetting;
  AuthRemoteDataSource? _dataSourceSetting;
  SettingUseCase? _settingUseCase;
  late SharedPreferences prefs;
  Future<void> _loadSetting() async {
    try {
      prefs = await SharedPreferences.getInstance();
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
      setState(() {
        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      print("Error loading profile data: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = "Error loading profile: $e";
        });
      }
    }
  }

  Future<String?> showConfirmStatus(
    BuildContext context,
    String title,
    String content,
  ) {
    final TextEditingController alasanController = TextEditingController();

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(null),
              child: Text('Batal'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop("CONFIRM"),
              child: Text('Konfirmasi'),
            ),
          ],
        );
      },
    );
  }

  Future deleteAccount() async {
    try {
      String? id = prefs.getString('idUser');
      String? loginAs = prefs.getString('loginAs');
      if (id == null) throw Exception("User ID not found in preferences");

      final result = await showConfirmStatus(
        context,
        "Konfirmasi Delete Account",
        "Yakin ingin menghapus akun ini?",
      );
      if (result == null) return;

      setState(() {
        isLoading = true;
      });

      String? response = await _settingUseCase!.deleteAccount(id, loginAs!);
      if (response == 'Sukses') {
        setState(() {
          isLoading = false;
          prefs.clear();
          context.go("/");
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response!), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Error during delete account: $e');
      if (mounted) {
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Internal Error"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future logOut() async {
    try {
      String? id = prefs.getString('idUser');
      String? loginAs = prefs.getString('loginAs');
      if (id == null) throw Exception("User ID not found in preferences");

      final result = await showConfirmStatus(
        context,
        "Konfirmasi Log Out",
        "Yakin ingin log out dari aplikasi?",
      );
      if (result == null) return;

      setState(() {
        isLoading = true;
      });

      String? response = await _settingUseCase!.logOut(id, loginAs!);
      if (response == 'Sukses') {
        setState(() {
          isLoading = false;
        });
        prefs.clear();
        context.go("/");
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response!), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Error during delete account: $e');
      if (mounted) {
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Internal Error"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future changeThemeMode(bool value) async {
    try {
      String? id = prefs.getString('idUser');
      String? loginAs = prefs.getString('loginAs');
      if (id == null) throw Exception("User ID not found in preferences");

      String? response = await _settingUseCase!.changeThemeMode(id, loginAs!);
      if (response == 'Sukses') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Success change theme mode!')));
        setState(() {
          prefs.setBool("isDarkMode", value);
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response!), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Error during delete account: $e');
      if (mounted) {
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Internal Error"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> openPlayStore() async {
    final Uri androidUri = Uri.parse('market://details?id=$packageName');
    final Uri webUri = Uri.parse(
      'https://play.google.com/store/apps/details?id=$packageName',
    );

    try {
      if (await canLaunchUrl(androidUri)) {
        await launchUrl(androidUri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }

  Future upgradePlan(bool value) async {
    try {
      String? id = prefs.getString('idUser');
      String? loginAs = prefs.getString('loginAs');
      if (id == null) throw Exception("User ID not found in preferences");

      // final result = await showConfirmStatus(
      //   context,
      //   "Yakin ingin upgrade plan?",
      //   "Upgrade Plan Rp. 250.000/ bulan",
      // );
      // if (result == null) return;

      // setState(() {
      //   isLoading = true;
      // });

      String? response = await _settingUseCase!.upgradePlan(id, loginAs!);
      if (response == 'Sukses') {
        prefs.setBool("isPremium", value);
        // context.go("/setting");
        // ScaffoldMessenger.of(
        //   context,
        // ).showSnackBar(SnackBar(content: Text('Success Upgrade Plan!')));
        // setState(() {
        //   isLoading = false;
        // });
      } else {
        // setState(() {
        //   isLoading = false;
        // });
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(response!), backgroundColor: Colors.red),
        // );
      }
    } catch (e) {
      // setState(() {
      //   isLoading = false;
      // });
      // debugPrint('Error during delete account: $e');
      // if (mounted) {
      //   return ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text("Internal Error"),
      //       backgroundColor: Colors.red,
      //     ),
      //   );
      // }
    }
  }

  Future changeNotifApp(bool value) async {
    try {
      String? id = prefs.getString('idUser');
      String? loginAs = prefs.getString('loginAs');
      if (id == null) throw Exception("User ID not found in preferences");

      // setState(() {
      //   isLoading = true;
      // });

      String? response = await _settingUseCase!.changeNotifApp(id, loginAs!);
      if (response == 'Sukses') {
        prefs.setBool("isNotifInternal", value);
        // ScaffoldMessenger.of(
        //   context,
        // ).showSnackBar(SnackBar(content: Text('Success Change Notification!')));
        // setState(() {
        //   isLoading = false;
        // });
      } else {
        // setState(() {
        //   isLoading = false;
        // });
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(response!), backgroundColor: Colors.red),
        // );
      }
    } catch (e) {
      // setState(() {
      //   isLoading = false;
      // });
      // debugPrint('Error during delete account: $e');
      // if (mounted) {
      //   return ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text("Internal Error"),
      //       backgroundColor: Colors.red,
      //     ),
      //   );
      // }
    }
  }

  Future changeExternalNotifApp(bool value) async {
    try {
      String? id = prefs.getString('idUser');
      String? loginAs = prefs.getString('loginAs');
      if (id == null) throw Exception("User ID not found in preferences");

      // setState(() {
      //   isLoading = true;
      // });

      String? response = await _settingUseCase!.changeExternalNotifApp(
        id,
        loginAs!,
      );
      if (response == 'Sukses') {
        prefs.setBool("isNotifExternal", value);
        // ScaffoldMessenger.of(
        //   context,
        // ).showSnackBar(SnackBar(content: Text('Success Change Notification!')));
        // setState(() {
        //   isLoading = false;
        // });
      } else {
        // setState(() {
        //   isLoading = false;
        // });
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(response!), backgroundColor: Colors.red),
        // );
      }
    } catch (e) {
      // setState(() {
      //   isLoading = false;
      // });
      // debugPrint('Error during delete account: $e');
      // if (mounted) {
      //   return ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text("Internal Error"),
      //       backgroundColor: Colors.red,
      //     ),
      //   );
      // }
    }
  }

  Future changeEmailAccount(String oldEmail, String newEmail) async {
    try {
      String? id = prefs.getString('idUser');
      String? loginAs = prefs.getString('loginAs');
      String? oldEmail = prefs.getString('email');
      if (id == null) throw Exception("User ID not found in preferences");

      // final result = await showConfirmStatus(
      //   context,
      //   "Change Email",
      //   "Yakin ingin mengganti email sekarang?",
      // );
      // if (result == null) return;

      // setState(() {
      //   isLoading = true;
      // });

      String? response = await _settingUseCase!.changeEmailAccount(
        id,
        loginAs!,
        oldEmail!,
        newEmail,
      );
      if (response == 'Sukses') {
        prefs.clear();
        //   ScaffoldMessenger.of(
        //     context,
        //   ).showSnackBar(SnackBar(content: Text('Success Change Email')));
        //   setState(() {
        //     isLoading = false;
        //   });
        //   prefs.setString('email', newEmail);
        // } else {
        //   setState(() {
        //     isLoading = false;
        //   });
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text(response!), backgroundColor: Colors.red),
        //   );
        await logOut();
      }
    } catch (e) {
      // setState(() {
      //   isLoading = false;
      // });
      // debugPrint('Error during delete account: $e');
      // if (mounted) {
      //   return ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text("Internal Error"),
      //       backgroundColor: Colors.red,
      //     ),
      //   );
      // }
    }
  }

  Future change2FA(bool isActive) async {
    try {
      String? id = prefs.getString('idUser');
      String? loginAs = prefs.getString('loginAs');
      String? email = prefs.getString('email');
      if (id == null) throw Exception("User ID not found in preferences");

      final result = await showConfirmStatus(context, "Ganti 2FA", "Yakin?");
      if (result == null) return;

      setState(() {
        isLoading = true;
      });

      String? response = await _settingUseCase!.change2FA(
        id,
        loginAs!,
        email!,
        isActive,
      );
      if (response == 'Sukses') {
        setState(() {
          isLoading = false;
          context.go("/validate2FA");
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response!), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Error during delete account: $e');
      if (mounted) {
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Internal Error"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future validate2FA(bool isActive, String OTP) async {
    try {
      String? id = prefs.getString('idUser');
      String? loginAs = prefs.getString('loginAs');
      String? email = prefs.getString('email');
      if (id == null) throw Exception("User ID not found in preferences");

      // final result = await showConfirmStatus(context);
      // if (result == null) return;

      setState(() {
        isLoading = true;
      });

      String? response = await _settingUseCase!.validate2FA(
        id,
        loginAs!,
        email!,
        OTP,
        isActive ? "activate" : "deactivate",
      );
      if (response == 'Sukses') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Success Validate 2FA Account!')),
        );
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response!), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Error during delete account: $e');
      if (mounted) {
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Internal Error"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future changeLanguage(String language) async {
    try {
      String? id = prefs.getString('idUser');
      String? loginAs = prefs.getString('loginAs');
      if (id == null) throw Exception("User ID not found in preferences");

      // setState(() {
      //   isLoading = true;
      // });

      String? response = await _settingUseCase!.changeLanguage(
        id,
        loginAs!,
        language,
      );
      if (response == 'Sukses') {
        prefs.setString("language", language);
        // ScaffoldMessenger.of(
        //   context,
        // ).showSnackBar(SnackBar(content: Text('Success Change Language!')));
        // setState(() {
        //   isLoading = false;
        // });
      } else {
        // setState(() {
        //   isLoading = false;
        // });
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(response!), backgroundColor: Colors.red),
        // );
      }
    } catch (e) {
      // setState(() {
      //   isLoading = false;
      // });
      debugPrint('Error during change language: $e');
      if (mounted) {
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Internal Error"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future changeFontSize(
    String fontSizeHead,
    String fontSizeSubHead,
    String fontSizeBody,
    String fontSizeIcon,
  ) async {
    try {
      //if (!mounted) return;

      String? id = prefs.getString('idUser');
      String? loginAs = prefs.getString('loginAs');
      if (id == null) throw Exception("User ID not found in preferences");

      // setState(() {
      //   isLoading = true;
      // });

      String? response = await _settingUseCase!.changeFontSize(
        id,
        loginAs!,
        fontSizeHead == "big"
            ? 22
            : fontSizeHead == "medium"
            ? 18
            : 14,
        fontSizeSubHead == "big"
            ? 20
            : fontSizeHead == "medium"
            ? 16
            : 12,
        fontSizeBody == "big"
            ? 18
            : fontSizeHead == "medium"
            ? 14
            : 10,
        fontSizeIcon == "big"
            ? 16
            : fontSizeHead == "medium"
            ? 12
            : 8,
      );
      if (response == 'Sukses') {
        // ScaffoldMessenger.of(
        //   context,
        // ).showSnackBar(SnackBar(content: Text('Success Change Font Size!')));
        // setState(() {
        //   isLoading = false;
        // });
        prefs.setInt(
          "fontSizeHead",
          fontSizeHead == "big"
              ? 22
              : fontSizeHead == "medium"
              ? 18
              : 14,
        );
        prefs.setInt(
          "fontSizeSubHead",
          fontSizeSubHead == "big"
              ? 20
              : fontSizeSubHead == "medium"
              ? 16
              : 12,
        );
        prefs.setInt(
          "fontSizeBody",
          fontSizeBody == "big"
              ? 18
              : fontSizeBody == "medium"
              ? 14
              : 10,
        );
        prefs.setInt(
          "fontSizeIcon",
          fontSizeIcon == "big"
              ? 16
              : fontSizeIcon == "medium"
              ? 12
              : 8,
        );
      } else {
        // setState(() {
        //   isLoading = false;
        // });
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(response!), backgroundColor: Colors.red),
        // );
      }
    } catch (e) {
      // setState(() {
      //   isLoading = false;
      // });
      debugPrint('Error during change font: $e');
      if (mounted) {
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Internal Error"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSetting();
    _initializeUseCase();
  }

  void _initializeUseCase() {
    _dataSourceSetting = AuthRemoteDataSource();
    _repoSetting = AuthRepositoryImpl(_dataSourceSetting!);
    _settingUseCase = SettingUseCase(_repoSetting!);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading Setting data...'),
          ],
        ),
      );
    }

    // Show error message if there's an error
    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red),
            SizedBox(height: 16),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 16),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Center(
        child: Container(
          width: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
              ? double.infinity
              : MediaQuery.of(context).size.width * 0.45,
          alignment: Alignment.center,
          child: ResponsiveRowColumn(
            columnCrossAxisAlignment: CrossAxisAlignment.center,
            rowMainAxisAlignment: MainAxisAlignment.center,
            columnMainAxisAlignment: MainAxisAlignment.center,
            rowCrossAxisAlignment: CrossAxisAlignment.center,
            layout: ResponsiveRowColumnType.COLUMN,
            rowSpacing: 100,
            columnSpacing: 20,
            children: [
              ResponsiveRowColumnItem(
                rowFlex: 2,
                child: topSetting(
                  nama: nama ?? "",
                  isPremium: isPremium ?? false,
                  loginAs: loginAs ?? "user",
                  profileComplete: profileComplete ?? 0,
                  url: url ?? "",
                ),
              ),
              ResponsiveRowColumnItem(
                rowFlex: 2,
                child: bodySetting(
                  deleteAccount: deleteAccount,
                  change2FA: change2FA,
                  changeEmailAccount: changeEmailAccount,
                  changeExternalNotifApp: changeExternalNotifApp,
                  changeFontSize: changeFontSize,
                  changeLanguage: changeLanguage,
                  changeNotifApp: changeNotifApp,
                  changeThemeMode: changeThemeMode,
                  logOut: logOut,
                  openPlayStore: openPlayStore,
                  upgradePlan: upgradePlan,
                  validate2FA: validate2FA,
                  is2FA: is2FA,
                  isDarkMode: isDarkMode,
                  isNotifExternal: isNotifExternal,
                  isNotifInternal: isNotifInternal,
                  isPremium: isPremium,
                  language: language,
                  fontSizeHead: fontSizeHead,
                  fontSizeSubHead: fontSizeSubHead,
                  fontSizeBody: fontSizeBody,
                  fontSizeIcon: fontSizeIcon,
                  reload: _loadSetting,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
