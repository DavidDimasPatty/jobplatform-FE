import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_platform/core/network/websocket_client.dart';
import 'package:job_platform/core/utils/providers/setting_provider.dart';
import 'package:job_platform/features/components/setting/data/datasources/aut_remote_datasource.dart';
import 'package:job_platform/features/components/setting/data/repositories/auth_repository_impl.dart';
import 'package:job_platform/features/components/setting/domain/usecases/setting_usecase.dart';
import 'package:job_platform/features/components/setting/persentation/widgets/bodySetting.dart';
import 'package:job_platform/features/components/setting/persentation/widgets/topSetting.dart';
import 'package:provider/provider.dart';
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
  bool? isPremium;
  late bool isDarkMode;
  int? profileComplete;
  final String packageName = 'com.whatsapp';
  AuthRepositoryImpl? _repoSetting;
  AuthRemoteDataSource? _dataSourceSetting;
  SettingUseCase? _settingUseCase;
  final WebSocketClientImpl _webSocketClient = WebSocketClientImpl();
  late SharedPreferences prefs;
  Future<String?> showConfirmStatus(
    BuildContext context,
    String title,
    String content,
  ) {
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
        _webSocketClient.disconnect();
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Success change theme mode!'),
            backgroundColor: Colors.green,
          ),
        );
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

  Future<String> changeEmailAccount(String oldEmail, String newEmail) async {
    try {
      String? id = prefs.getString('idUser');
      String? loginAs = prefs.getString('loginAs');
      String? oldEmail = prefs.getString('email');
      if (id == null) throw Exception("User ID not found in preferences");

      String? response = await _settingUseCase!.changeEmailAccount(
        id,
        loginAs!,
        oldEmail!,
        newEmail,
      );
      if (response == 'Sukses') {
        prefs.clear();
        return "Sukses";
      } else {
        return response!;
      }
    } catch (e) {
      throw new Exception(e);
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

  @override
  void initState() {
    super.initState();
    isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _initializeUseCase();
      final provider = context.read<SettingProvider>();
      await provider.loadSetting();
      print(Localizations.localeOf(context));
      setState(() {
        nama = provider.nama;
        loginAs = provider.loginAs;
        url = provider.url;
        profileComplete = provider.profileComplete;
        isPremium = provider.isPremium;
        is2FA = provider.is2FA;
        isDarkMode = provider.isDarkMode!;
        isLoading = false;
        errorMessage = null;
      });
    });
  }

  void _initializeUseCase() async {
    _dataSourceSetting = AuthRemoteDataSource();
    _repoSetting = AuthRepositoryImpl(_dataSourceSetting!);
    _settingUseCase = SettingUseCase(_repoSetting!);
    prefs = await SharedPreferences.getInstance();
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
                  changeEmailAccount: changeEmailAccount,
                  changeThemeMode: changeThemeMode,
                  logOut: logOut,
                  openPlayStore: openPlayStore,
                  isDarkMode: isDarkMode,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
