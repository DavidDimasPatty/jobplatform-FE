import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Upgradeaccount extends StatefulWidget {
  final Future<void> Function(bool value)? upgradePlan;
  final bool? isPremium;
  final Future<void> Function()? reload;
  const Upgradeaccount({
    super.key,
    this.upgradePlan,
    this.isPremium,
    this.reload,
  });

  @override
  State<Upgradeaccount> createState() => _Upgradeaccount();
}

class _Upgradeaccount extends State<Upgradeaccount> {
  bool _isLoading = false;
  void initState() {
    setState(() {
      _isLoading = false;
      _isLoading = true;
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
                            : ElevatedButton.icon(
                                onPressed: () async {
                                  await widget.upgradePlan!(true);
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
