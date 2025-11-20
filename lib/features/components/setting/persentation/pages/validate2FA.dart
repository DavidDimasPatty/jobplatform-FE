import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:job_platform/features/components/setting/data/datasources/aut_remote_datasource.dart';
import 'package:job_platform/features/components/setting/data/repositories/auth_repository_impl.dart';
import 'package:job_platform/features/components/setting/domain/usecases/setting_usecase.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Validate2fa extends StatefulWidget {
  final String? email;
  final String? userId;
  final String? loginAs;
  const Validate2fa({super.key, this.email, this.userId, this.loginAs});

  @override
  State<Validate2fa> createState() => _Validate2fa();
}

class _Validate2fa extends State<Validate2fa> {
  late bool _isLoading;
  TextEditingController kode1 = TextEditingController();
  TextEditingController kode2 = TextEditingController();
  TextEditingController kode3 = TextEditingController();
  TextEditingController kode4 = TextEditingController();
  AuthRepositoryImpl? _repoSetting;
  AuthRemoteDataSource? _dataSourceSetting;
  SettingUseCase? _settingUseCase;

  void _initializeUseCase() async {
    _dataSourceSetting = AuthRemoteDataSource();
    _repoSetting = AuthRepositoryImpl(_dataSourceSetting!);
    _settingUseCase = SettingUseCase(_repoSetting!);
  }

  Future validate2FA(String OTP) async {
    try {
      setState(() {
        _isLoading = true;
      });

      String? response = await _settingUseCase!.validate2FA(
        widget.userId!,
        widget.loginAs!,
        widget.email!,
        OTP,
        "login",
      );
      if (response == 'Sukses') {
        setState(() {
          _isLoading = false;
          if (widget.loginAs == "user") {
            context.go("/home");
          } else {
            context.go("/homeCompany");
          }
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response!), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
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
    _isLoading = true;
    _initializeUseCase();
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: Colors.blue));
    }

    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
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
                            'Kode OTP',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              letterSpacing: 2,
                              color: Colors.blue,
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        _isLoading
                            ? CircularProgressIndicator(
                                color: Colors.blue.shade400,
                              )
                            : Form(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 20),
                                      child: Text(
                                        "Masukan Kode 2 FA",
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      spacing: 20,
                                      children: [
                                        otpBox(kode1),
                                        otpBox(kode2),
                                        otpBox(kode3),
                                        otpBox(kode4),
                                      ],
                                    ),
                                    SizedBox(height: 20),

                                    _isLoading
                                        ? CircularProgressIndicator(
                                            color: Colors.blue.shade400,
                                          )
                                        : ElevatedButton.icon(
                                            onPressed: () async {
                                              await validate2FA(
                                                kode1.text +
                                                    kode2.text +
                                                    kode3.text +
                                                    kode4.text,
                                              );
                                            },
                                            label: Text("Submit"),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Theme.of(
                                                context,
                                              ).colorScheme.secondary,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
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

Widget otpBox(TextEditingController c) {
  return SizedBox(
    width: 60,
    child: TextFormField(
      controller: c,
      keyboardType: TextInputType.number,
      maxLength: 1,
      textAlign: TextAlign.center,
      decoration: const InputDecoration(
        counterText: "",
        border: OutlineInputBorder(),
      ),
    ),
  );
}
