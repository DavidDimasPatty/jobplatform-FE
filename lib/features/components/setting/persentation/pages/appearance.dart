import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:job_platform/core/utils/providers/setting_provider.dart';
import 'package:job_platform/features/components/setting/data/repositories/auth_repository_impl.dart';
import 'package:job_platform/features/components/setting/domain/usecases/setting_usecase.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:job_platform/features/components/setting/domain/usecases/setting_usecase.dart';
import 'package:job_platform/features/components/setting/data/datasources/aut_remote_datasource.dart'
    show AuthRemoteDataSource;

class Appearance extends StatefulWidget {
  // final Future<void> Function(String language)? changeLanguage;
  // final Future<void> Function(
  //   String fontSizeHead,
  //   String fontSizeSubHead,
  //   String fontSizeBody,
  //   String fontSizeIcon,
  // )?
  // changeFontSize;
  // final String? language;
  // final int? fontSizeHead;
  // final int? fontSizeSubHead;
  // final int? fontSizeBody;
  // final int? fontSizeIcon;
  const Appearance({
    super.key,
    // this.changeLanguage,
    // this.changeFontSize,
    // this.language,
    // this.fontSizeHead,
    // this.fontSizeSubHead,
    // this.fontSizeBody,
    // this.fontSizeIcon,
  });

  @override
  State<Appearance> createState() => _Appearance();
}

class _Appearance extends State<Appearance> {
  final _formKeyChangeFont = GlobalKey<FormState>();
  final _formKeyChangeLanguage = GlobalKey<FormState>();
  AuthRepositoryImpl? _repoSetting;
  AuthRemoteDataSource? _dataSourceSetting;
  SettingUseCase? _settingUseCase;
  late SharedPreferences prefs;
  String? _fontSizeHeadController;
  String? _fontSizeSubHeadController;
  String? _fontSizeBodyController;
  String? _fontSizeIconontroller;
  String? _languageController;
  List<String> fontType = ["big", "medium", "small"];
  List<String> language = ["ENG", "IND"];
  bool _isLoading = false;

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
        _fontSizeHeadController = setting.fontSizeHead == 22
            ? "big"
            : setting.fontSizeHead == 18
            ? "medium"
            : "small";
        _fontSizeSubHeadController = setting.fontSizeSubHead == 20
            ? "big"
            : setting.fontSizeSubHead == 16
            ? "medium"
            : "small";
        _fontSizeBodyController = setting.fontSizeBody == 18
            ? "big"
            : setting.fontSizeBody == 14
            ? "medium"
            : "small";
        _fontSizeIconontroller = setting.fontSizeIcon == 16
            ? "big"
            : setting.fontSizeIcon == 12
            ? "medium"
            : "small";
        _languageController = setting.language;
        _isLoading = true;
      });
    });
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
            : fontSizeSubHead == "medium"
            ? 16
            : 12,
        fontSizeBody == "big"
            ? 18
            : fontSizeBody == "medium"
            ? 14
            : 10,
        fontSizeIcon == "big"
            ? 16
            : fontSizeIcon == "medium"
            ? 12
            : 8,
      );
      if (response == 'Sukses') {
        // final provider = context.read<SettingProvider>();

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
      } else {}
    } catch (e) {
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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.0),
      child: Center(
        child: Container(
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
                  key: _formKeyChangeFont,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: Text(
                            'Font Size',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              letterSpacing: 2,
                              color: Colors.blue,
                            ),
                          ),
                        ),

                        !_isLoading
                            ? CircularProgressIndicator(
                                color: Colors.blue.shade400,
                              )
                            : buildDropdownField(
                                'Font Size Head',
                                _fontSizeHeadController != null
                                    ? fontType!.contains(
                                            _fontSizeHeadController,
                                          )
                                          ? _fontSizeHeadController
                                          : fontType![1]
                                    : fontType![1],
                                fontType!,
                                (value) {
                                  setState(() {
                                    _fontSizeHeadController = value;
                                  });
                                },
                                (value) {
                                  return null;
                                },
                              ),

                        !_isLoading
                            ? CircularProgressIndicator(
                                color: Colors.blue.shade400,
                              )
                            : buildDropdownField(
                                'Font Size Sub Head',
                                _fontSizeSubHeadController != null
                                    ? fontType!.contains(
                                            _fontSizeSubHeadController,
                                          )
                                          ? _fontSizeSubHeadController
                                          : fontType![1]
                                    : fontType![1],
                                fontType!,
                                (value) {
                                  setState(() {
                                    _fontSizeSubHeadController = value;
                                  });
                                },
                                (value) {
                                  return null;
                                },
                              ),

                        !_isLoading
                            ? CircularProgressIndicator(
                                color: Colors.blue.shade400,
                              )
                            : buildDropdownField(
                                'Font Size Body',
                                _fontSizeBodyController != null
                                    ? fontType!.contains(
                                            _fontSizeBodyController,
                                          )
                                          ? _fontSizeBodyController
                                          : fontType![1]
                                    : fontType![1],
                                fontType!,
                                (value) {
                                  setState(() {
                                    _fontSizeBodyController = value;
                                  });
                                },
                                (value) {
                                  return null;
                                },
                              ),

                        !_isLoading
                            ? CircularProgressIndicator(
                                color: Colors.blue.shade400,
                              )
                            : buildDropdownField(
                                'Font Size Icon',
                                _fontSizeIconontroller != null
                                    ? fontType!.contains(_fontSizeIconontroller)
                                          ? _fontSizeIconontroller
                                          : fontType![1]
                                    : fontType![1],
                                fontType!,
                                (value) {
                                  setState(() {
                                    _fontSizeIconontroller = value;
                                  });
                                },
                                (value) {
                                  return null;
                                },
                              ),

                        SizedBox(height: 20),
                        !_isLoading
                            ? CircularProgressIndicator()
                            : ElevatedButton.icon(
                                onPressed: () async {
                                  await changeFontSize(
                                    _fontSizeHeadController!,
                                    _fontSizeSubHeadController!,
                                    _fontSizeBodyController!,
                                    _fontSizeIconontroller!,
                                  );
                                  final provider = context
                                      .read<SettingProvider>();

                                  provider.changeFontSize(
                                    _fontSizeHeadController!,
                                    _fontSizeSubHeadController!,
                                    _fontSizeBodyController!,
                                    _fontSizeIconontroller!,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text(
                                        'Success Change Font Size!',
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.check),
                                iconAlignment: IconAlignment.end,
                                label: Text('Submit'),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.blue,
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),

              ResponsiveRowColumnItem(
                rowFlex: 2,
                child: Form(
                  key: _formKeyChangeLanguage,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: Text(
                            'Pengaturan Bahasa',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              letterSpacing: 2,
                              color: Colors.blue,
                            ),
                          ),
                        ),

                        !_isLoading
                            ? CircularProgressIndicator(
                                color: Colors.blue.shade400,
                              )
                            : buildDropdownField(
                                'Language',
                                _languageController != null
                                    ? language!.contains(_languageController)
                                          ? _languageController
                                          : language![1]
                                    : language![1],
                                language!,
                                (value) => _languageController = value,
                                (value) {
                                  return null;
                                },
                              ),

                        SizedBox(height: 20),
                        !_isLoading
                            ? CircularProgressIndicator()
                            : ElevatedButton.icon(
                                onPressed: () async {
                                  await changeLanguage(_languageController!);

                                  final provider = context
                                      .read<SettingProvider>();

                                  provider.changeLanguage(_languageController!);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text('Success Change Language!'),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.check),
                                iconAlignment: IconAlignment.end,
                                label: Text('Submit'),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.blue,
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
        key: ValueKey(label),
        value: value,
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
