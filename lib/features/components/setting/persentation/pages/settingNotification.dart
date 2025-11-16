import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:job_platform/core/utils/providers/setting_provider.dart';
import 'package:job_platform/features/components/setting/data/repositories/auth_repository_impl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:job_platform/features/components/setting/domain/usecases/setting_usecase.dart';
import 'package:job_platform/features/components/setting/data/datasources/aut_remote_datasource.dart'
    show AuthRemoteDataSource;
import 'package:shared_preferences/shared_preferences.dart';

class Settingnotification extends StatefulWidget {
  const Settingnotification({super.key});

  @override
  State<Settingnotification> createState() => _Settingnotification();
}

class _Settingnotification extends State<Settingnotification> {
  bool _isLoading = true;
  late bool inChangeNotifApp;
  late bool inChangeNotifExternalApp;
  AuthRepositoryImpl? _repoSetting;
  AuthRemoteDataSource? _dataSourceSetting;
  SettingUseCase? _settingUseCase;
  late SharedPreferences prefs;
  bool isLoading = true;
  String? errorMessage;

  @override
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
        inChangeNotifApp = setting.isNotifInternal!;
        inChangeNotifExternalApp = setting.isNotifExternal!;
        isLoading = false;
        _isLoading = false;
      });
    });
  }

  Future changeNotifApp(bool value) async {
    try {
      String? id = prefs.getString('idUser');
      String? loginAs = prefs.getString('loginAs');
      if (id == null) throw Exception("User ID not found in preferences");
      String? response = await _settingUseCase!.changeNotifApp(id, loginAs!);
      if (response == 'Sukses') {
        prefs.setBool("isNotifInternal", value);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Success Change Internal Notification!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response!), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      debugPrint('Error during Change Internal Notification: $e');
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

  Future changeExternalNotifApp(bool value) async {
    try {
      String? id = prefs.getString('idUser');
      String? loginAs = prefs.getString('loginAs');
      if (id == null) throw Exception("User ID not found in preferences");
      String? response = await _settingUseCase!.changeExternalNotifApp(
        id,
        loginAs!,
      );
      if (response == 'Sukses') {
        prefs.setBool("isNotifExternal", value);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Success Change External Notification!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response!), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      debugPrint('Error during Change External Notification: $e');
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
      padding: EdgeInsets.all(20.0),
      child: Center(
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
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: Text(
                            'Notification'.tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              letterSpacing: 2,
                              color: Colors.blue,
                            ),
                          ),
                        ),

                        _isLoading
                            ? CircularProgressIndicator(
                                color: Colors.blue.shade400,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: ListTile(
                                  leading: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.lightBlueAccent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.all(5),
                                    child: Icon(
                                      Icons.notifications_active_sharp,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                    ),
                                  ),
                                  title: Text(
                                    "Notifikasi Internal".tr(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Notifikasi pelamaran kerja dan chat".tr(),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium!,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: Switch.adaptive(
                                    activeColor: Colors.blue,
                                    value: inChangeNotifApp,
                                    onChanged: (value) async {
                                      await changeNotifApp!(value);
                                      final provider = context
                                          .read<SettingProvider>();

                                      await provider.changeNotifApp(value);
                                      setState(() {
                                        inChangeNotifApp = value;
                                      });
                                    },
                                  ),
                                ),
                              ),

                        SizedBox(height: 20),

                        _isLoading
                            ? CircularProgressIndicator(
                                color: Colors.blue.shade400,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: ListTile(
                                  leading: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.lightBlueAccent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.all(5),
                                    child: Icon(
                                      Icons.notifications_active_sharp,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                    ),
                                  ),
                                  title: Text(
                                    "Notifikasi External".tr(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    // overflow: titleMaxLine != null
                                    //     ? overflow
                                    //     : null,
                                  ),
                                  subtitle: Text(
                                    "Notifikasi tawaran dari Skillen".tr(),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium!,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: Switch.adaptive(
                                    activeColor: Colors.blue,
                                    value: inChangeNotifExternalApp,
                                    onChanged: (value) async {
                                      await changeExternalNotifApp!(value);
                                      final provider = context
                                          .read<SettingProvider>();

                                      await provider.changeNotifExternalApp(
                                        value,
                                      );
                                      setState(() {
                                        inChangeNotifExternalApp = value;
                                      });
                                    },
                                  ),
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

  Widget buildTextField(
    String label,
    TextEditingController controller,
    IconData prefixIcon, {
    int maxLines = 1,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        maxLines: maxLines,
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(prefixIcon),
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: validator,
      ),
    );
  }

  Widget buildDropdownField(
    String label,
    String? value,
    List<String> items,
    void Function(String?) onChanged,
    String? Function(String?) validator,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        initialValue: value != null ? value : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.arrow_drop_down),
        ),
        items: items
            .map(
              (item) =>
                  DropdownMenuItem<String>(value: item, child: Text(item)),
            )
            .toList(),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}
