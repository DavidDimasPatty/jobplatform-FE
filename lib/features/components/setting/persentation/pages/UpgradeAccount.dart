import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_platform/core/utils/providers/setting_provider.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Upgradeaccount extends StatefulWidget {
  final Future<void> Function(bool value)? upgradePlan;
  final bool? isPremium;
  const Upgradeaccount({super.key, this.upgradePlan, this.isPremium});

  @override
  State<Upgradeaccount> createState() => _Upgradeaccount();
}

class _Upgradeaccount extends State<Upgradeaccount> {
  bool _isLoading = false;
  late bool? inIsPremium;

  // Future upgradePlan(bool value) async {
  //   try {
  //     String? id = prefs.getString('idUser');
  //     String? loginAs = prefs.getString('loginAs');
  //     if (id == null) throw Exception("User ID not found in preferences");

  //     // final result = await showConfirmStatus(
  //     //   context,
  //     //   "Yakin ingin upgrade plan?",
  //     //   "Upgrade Plan Rp. 250.000/ bulan",
  //     // );
  //     // if (result == null) return;

  //     // setState(() {
  //     //   isLoading = true;
  //     // });

  //     String? response = await _settingUseCase!.upgradePlan(id, loginAs!);
  //     if (response == 'Sukses') {
  //       prefs.setBool("isPremium", value);
  //       // context.go("/setting");
  //       // ScaffoldMessenger.of(
  //       //   context,
  //       // ).showSnackBar(SnackBar(content: Text('Success Upgrade Plan!')));
  //       // setState(() {
  //       //   isLoading = false;
  //       // });
  //     } else {
  //       // setState(() {
  //       //   isLoading = false;
  //       // });
  //       // ScaffoldMessenger.of(context).showSnackBar(
  //       //   SnackBar(content: Text(response!), backgroundColor: Colors.red),
  //       // );
  //     }
  //   } catch (e) {
  //     // setState(() {
  //     //   isLoading = false;
  //     // });
  //     // debugPrint('Error during delete account: $e');
  //     // if (mounted) {
  //     //   return ScaffoldMessenger.of(context).showSnackBar(
  //     //     SnackBar(
  //     //       content: Text("Internal Error"),
  //     //       backgroundColor: Colors.red,
  //     //     ),
  //     //   );
  //     // }
  //   }
  // }

  void initState() {
    super.initState();
    Future.microtask(() async {
      final setting = context.read<SettingProvider>();
      await setting.loadSetting();

      setState(() {
        inIsPremium = setting.isPremium!;
        _isLoading = true;
      });
    });
  }

  Widget build(BuildContext build) {
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
                                  await widget.upgradePlan!(true);
                                  final provider = context
                                      .read<SettingProvider>();

                                  await provider.changePremium(true);
                                  context.go("/setting");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text('Success Upgrade Plan!'),
                                    ),
                                  );
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
