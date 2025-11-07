import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Appearance extends StatefulWidget {
  final Future<void> Function(String language)? changeLanguage;
  final Future<void> Function(
    String fontSizeHead,
    String fontSizeSubHead,
    String fontSizeBody,
    String fontSizeIcon,
  )?
  changeFontSize;
  final Future<void> Function()? reload;
  final String? language;
  final int? fontSizeHead;
  final int? fontSizeSubHead;
  final int? fontSizeBody;
  final int? fontSizeIcon;
  const Appearance({
    super.key,
    this.changeLanguage,
    this.changeFontSize,
    this.language,
    this.fontSizeHead,
    this.fontSizeSubHead,
    this.fontSizeBody,
    this.fontSizeIcon,
    this.reload,
  });

  @override
  State<Appearance> createState() => _Appearance();
}

class _Appearance extends State<Appearance> {
  String? _fontSizeHeadController;
  String? _fontSizeSubHeadController;
  String? _fontSizeBodyController;
  String? _fontSizeIconontroller;
  String? _languageController;
  List<String>? fontType;
  List<String>? language;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    fontType = ["big", "medium", "small"];
    language = ["ENG", "IND"];
    _fontSizeHeadController = widget.fontSizeHead == 22
        ? "big"
        : widget.fontSizeHead == 18
        ? "medium"
        : "small";

    _fontSizeSubHeadController = widget.fontSizeSubHead == 20
        ? "big"
        : widget.fontSizeSubHead == 16
        ? "medium"
        : "small";

    _fontSizeBodyController = widget.fontSizeBody == 18
        ? "big"
        : widget.fontSizeBody == 14
        ? "medium"
        : "small";

    _fontSizeIconontroller = widget.fontSizeIcon == 16
        ? "big"
        : widget.fontSizeIcon == 12
        ? "medium"
        : "small";

    _languageController = widget.language;
    _isLoading = true;
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
                  // key: _formKey,
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
                                  await widget.changeFontSize!(
                                    _fontSizeHeadController!,
                                    _fontSizeSubHeadController!,
                                    _fontSizeBodyController!,
                                    _fontSizeIconontroller!,
                                  );
                                  await widget!.reload!();
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
                  // key: _formKey,
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
                                  await widget.changeLanguage!(
                                    _languageController!,
                                  );

                                  await widget!.reload!();

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
