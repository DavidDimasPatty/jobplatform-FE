import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Appearance extends StatefulWidget {
  final Future<void> Function(String? language)? changeLanguage;
  final Future<void> Function(
    String? fontSizeHead,
    String? fontSizeSubHead,
    String? fontSizeBody,
    String? fontSizeIcon,
  )?
  changeFontSize;
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
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      fontType = ["big", "medium", "small"];
      language = ["EN", "IND"];
      _fontSizeHeadController = widget.fontSizeHead == 22
          ? "big"
          : widget.fontSizeHead == 18
          ? "medium"
          : "small";

      _fontSizeSubHeadController = widget.fontSizeSubHead == 22
          ? "big"
          : widget.fontSizeSubHead == 18
          ? "medium"
          : "small";

      _fontSizeBodyController = widget.fontSizeBody == 22
          ? "big"
          : widget.fontSizeBody == 18
          ? "medium"
          : "small";

      _fontSizeIconontroller = widget.fontSizeIcon == 22
          ? "big"
          : widget.fontSizeIcon == 18
          ? "medium"
          : "small";

      _languageController = widget.language;
      _isLoading = true;
    });
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
                                _fontSizeHeadController,
                                fontType!,
                                (value) => _fontSizeHeadController = value,
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
                                _fontSizeSubHeadController,
                                fontType!,
                                (value) => _fontSizeSubHeadController = value,
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
                                _fontSizeBodyController,
                                fontType!,
                                (value) => _fontSizeBodyController = value,
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
                                _fontSizeIconontroller,
                                fontType!,
                                (value) => _fontSizeIconontroller = value,
                                (value) {
                                  return null;
                                },
                              ),

                        SizedBox(height: 20),
                        _isLoading
                            ? CircularProgressIndicator()
                            : ElevatedButton.icon(
                                onPressed: () => widget.changeFontSize!(
                                  _fontSizeHeadController ?? null,
                                  _fontSizeSubHeadController ?? null,
                                  _fontSizeBodyController ?? null,
                                  _fontSizeIconontroller ?? null,
                                )!,
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
                                _languageController,
                                fontType!,
                                (value) => _languageController = value,
                                (value) {
                                  return null;
                                },
                              ),

                        SizedBox(height: 20),
                        _isLoading
                            ? CircularProgressIndicator()
                            : ElevatedButton.icon(
                                onPressed: () => widget.changeLanguage!(
                                  _languageController ?? null,
                                )!,
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
        value: value != null ? value : null,
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
