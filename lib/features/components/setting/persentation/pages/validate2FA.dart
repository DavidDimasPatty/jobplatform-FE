import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Validate2fa extends StatefulWidget {
  final Future<void> Function(String OTP)? validate2FA;
  final bool? isActive;
  const Validate2fa({super.key, this.isActive, this.validate2FA});

  @override
  State<Validate2fa> createState() => _Validate2fa();
}

class _Validate2fa extends State<Validate2fa> {
  bool _isLoading = false;
  TextEditingController kode1 = TextEditingController();
  TextEditingController kode2 = TextEditingController();
  TextEditingController kode3 = TextEditingController();
  TextEditingController kode4 = TextEditingController();
  void initState() {
    super.initState();
    setState(() {
      _isLoading = false;
      _isLoading = true;
    });
  }

  Widget build(BuildContext context) {
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

                        !_isLoading
                            ? CircularProgressIndicator(
                                color: Colors.blue.shade400,
                              )
                            : Form(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        TextFormField(
                                          controller: kode1,
                                          keyboardType: TextInputType.number,
                                          maxLength: 1,
                                          decoration: const InputDecoration(
                                            hintText: "*",
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        TextFormField(
                                          controller: kode2,
                                          keyboardType: TextInputType.number,
                                          maxLength: 1,
                                          decoration: const InputDecoration(
                                            hintText: "*",
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        TextFormField(
                                          controller: kode3,
                                          keyboardType: TextInputType.number,
                                          maxLength: 1,
                                          decoration: const InputDecoration(
                                            hintText: "*",
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        TextFormField(
                                          controller: kode4,
                                          keyboardType: TextInputType.number,
                                          maxLength: 1,
                                          decoration: const InputDecoration(
                                            hintText: "*",
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),

                                    !_isLoading
                                        ? CircularProgressIndicator(
                                            color: Colors.blue.shade400,
                                          )
                                        : ElevatedButton.icon(
                                            onPressed: () =>
                                                widget.validate2FA!(
                                                  kode1.text +
                                                      kode2.text +
                                                      kode3.text +
                                                      kode4.text,
                                                ),
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
