import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Settingnotification extends StatefulWidget {
  final Future<void> Function(bool value)? changeNotifApp;
  final Future<void> Function(bool value)? changeExternalNotifApp;
  final bool? isNotifInternal;
  final bool? isNotifExternal;
  final Future<void> Function()? reload;
  const Settingnotification({
    super.key,
    this.changeNotifApp,
    this.changeExternalNotifApp,
    this.isNotifInternal,
    this.isNotifExternal,
    this.reload,
  });

  @override
  State<Settingnotification> createState() => _Settingnotification();
}

class _Settingnotification extends State<Settingnotification> {
  bool _isLoading = false;
  late bool changeNotifApp;
  late bool changeNotifExternalApp;
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
      changeNotifApp = widget.isNotifInternal!;
      changeNotifExternalApp = widget.isNotifExternal!;
      _isLoading = false;
    });
  }

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
                            'Notification',
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
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Text(
                                    "Notifikasi Internal",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    //maxLines: 2,
                                    // overflow: titleMaxLine != null
                                    //     ? overflow
                                    //     : null,
                                  ),
                                  subtitle: Text(
                                    "Notifikasi status pelamaran kerja dan chat",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium!,
                                    //maxLines: subtitleMaxLine,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: Switch.adaptive(
                                    activeColor: Colors.blue,
                                    value: changeNotifApp,
                                    onChanged: (value) async {
                                      await widget!.changeNotifApp!(value);
                                      await widget!.reload!();
                                      setState(() {
                                        changeNotifApp = value;
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
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Text(
                                    "Notifikasi External",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    // overflow: titleMaxLine != null
                                    //     ? overflow
                                    //     : null,
                                  ),
                                  subtitle: Text(
                                    "Notifikasi suggestion dari Skillen",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium!,
                                    //maxLines: subtitleMaxLine,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: Switch.adaptive(
                                    activeColor: Colors.blue,
                                    value: changeNotifExternalApp,
                                    onChanged: (value) async {
                                      await widget!.changeExternalNotifApp!(
                                        value,
                                      );
                                      await widget!.reload!();
                                      setState(() {
                                        changeNotifExternalApp = value;
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
