import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_platform/core/utils/providers/setting_provider.dart';
import 'package:job_platform/features/components/setting/domain/usecases/setting_usecase.dart';
import 'package:job_platform/features/components/setting/data/datasources/aut_remote_datasource.dart'
    show AuthRemoteDataSource;
import 'package:job_platform/features/components/setting/data/repositories/auth_repository_impl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Upgradeaccount extends StatefulWidget {
  const Upgradeaccount({super.key});

  @override
  State<Upgradeaccount> createState() => _Upgradeaccount();
}

class _Upgradeaccount extends State<Upgradeaccount> {
  bool _isLoading = false;
  String? errorMessage;
  late bool? inIsPremium;
  AuthRepositoryImpl? _repoSetting;
  AuthRemoteDataSource? _dataSourceSetting;
  SettingUseCase? _settingUseCase;
  late SharedPreferences prefs;
  bool isLoading = true;
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

  Future upgradePlan(bool value) async {
    try {
      String? id = prefs.getString('idUser');
      String? loginAs = prefs.getString('loginAs');
      if (id == null) throw Exception("User ID not found in preferences");

      final result = await showConfirmStatus(
        context,
        "Yakin ingin upgrade plan?",
        "Upgrade Plan Rp. 250.000 /bulan",
      );
      if (result == null) return;

      setState(() {
        isLoading = true;
      });

      String? response = await _settingUseCase!.upgradePlan(id, loginAs!);
      if (response == 'Sukses') {
        prefs.setBool("isPremium", value);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Success Upgrade Plan!'),
            backgroundColor: Colors.green,
          ),
        );

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(20),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 40),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 53, 115, 183),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/premium_success.png',
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Anda Sudah Premium!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Terima kasih telah berpartisipasi untuk menjadi premium.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("Tutup"),
                        ),
                      ],
                    ),
                  ),

                  // --- Bintang di atas popup ---
                  Positioned(
                    top: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.blue.shade300,
                        child: const Icon(
                          Icons.star_rounded,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );

        //await Future.delayed(Duration(seconds: 3));
        //context.go("/setting");
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

  void initState() {
    super.initState();
    Future.microtask(() async {
      _dataSourceSetting = AuthRemoteDataSource();
      _repoSetting = AuthRepositoryImpl(_dataSourceSetting!);
      _settingUseCase = SettingUseCase(_repoSetting!);
      prefs = await SharedPreferences.getInstance();
      final setting = context.read<SettingProvider>();
      await setting.loadSetting();

      setState(() {
        inIsPremium = setting.isPremium!;
        _isLoading = true;
        isLoading = false;
      });
    });
  }

  Widget build(BuildContext build) {
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
      padding: EdgeInsets.all(20.0),
      child: Center(
        child: Container(
          constraints: BoxConstraints(minHeight: 400),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                spreadRadius: 2,
                offset: Offset(3, 3),
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          width: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
              ? double.infinity
              : MediaQuery.of(context).size.width * 0.45,
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
                child: Form(
                  // key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: Text(
                            'Upgrade Premium',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              letterSpacing: 2,
                              color: Colors.blue,
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        !_isLoading
                            ? CircularProgressIndicator(
                                color: Colors.blue.shade400,
                              )
                            : inIsPremium != true
                            ? ElevatedButton.icon(
                                onPressed: () async {
                                  await upgradePlan(true);
                                  final provider = context
                                      .read<SettingProvider>();
                                  await provider.changePremium(true);
                                },
                                label: Text("Upgrade Now"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                ),
                              )
                            : Text('Akun anda Sudah Premium!'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
