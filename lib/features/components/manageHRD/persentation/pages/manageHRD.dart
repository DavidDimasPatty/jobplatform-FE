import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:job_platform/features/components/cart/persentation/widgets/cartBody.dart';
import 'package:job_platform/features/components/cart/persentation/widgets/cartItems.dart';
import 'package:job_platform/features/components/chat/persentasion/widget/chat/chatBody.dart';
import 'package:job_platform/features/components/chat/persentasion/widget/chat/chatItems.dart';
import 'package:job_platform/features/components/login/persentation/widgets/loginForm.dart';
import 'package:job_platform/features/components/manageHRD/persentation/widgets/manageHRD/manageHRDBody.dart';
import 'package:job_platform/features/components/manageHRD/persentation/widgets/manageHRD/manageHRDItems.dart';
import 'package:job_platform/features/components/setting/persentation/widgets/bodySetting.dart';
import 'package:job_platform/features/components/setting/persentation/widgets/settingGroup.dart'
    show SettingsGroup;
import 'package:job_platform/features/components/setting/persentation/widgets/settingItem.dart';
import 'package:job_platform/features/components/setting/persentation/widgets/topSetting.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Managehrd extends StatefulWidget {
  Managehrd({super.key});

  @override
  State<Managehrd> createState() => _Managehrd();
}

class _Managehrd extends State<Managehrd> {
  List<Managehrditems> dataSub = [];
  // Loading state
  bool isLoading = true;
  String? errorMessage;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  Future<void> _loadProfileData() async {
    try {
      // setState(() {
      //   isLoading = true;
      //   errorMessage = null;
      // });
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // String? userId = prefs.getString('idUser');

      // if (userId != null) {
      //   var profile = await _profileUseCase.getProfile(userId);
      //   if (profile != null) {
      //     setState(() {
      //       dataUser = profile.user;
      //       dataEdu = profile.educations ?? [];
      //       dataOrg = profile.organizations ?? [];
      //       dataWork = profile.experiences ?? [];
      //       dataCertificate = profile.certificates ?? [];
      //       dataSkill = profile.skills ?? [];
      //       dataPreference = profile.preferences ?? [];
      //       isLoading = false;
      //     });
      //   }
      // } else {
      //   print("User ID not found in SharedPreferences");
      // }
      setState(() {
        isLoading = false;
        errorMessage = null;
        dataSub = [
          Managehrditems(
            url: "assets/images/BG_Pelamar.png",
            title: "Nando Witin",
            subtitle: "email@email.com",
          ),
          Managehrditems(
            url: "assets/images/BG_Pelamar.png",
            title: "Nando Sitorus",
            subtitle: "email@email.com",
          ),
          Managehrditems(
            url: "assets/images/BG_Pelamar.png",
            title: "Nando Baltwin",
            subtitle: "email@email.com",
          ),
        ];
      });
    } catch (e) {
      print("Error loading profile data: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = "Error loading profile: $e";
        });
      }
    }
  }

  void _showEmailDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text("Masukkan Email"),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                hintText: "contoh@email.com",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Email tidak boleh kosong";
                }
                final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                if (!regex.hasMatch(value)) {
                  return "Format email tidak valid";
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Email: ${_emailController.text}")),
                  );
                }
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  @override
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

    // Show error message if there's an error
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
            // ElevatedButton(onPressed: _loadProfileData, child: Text('Retry')),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Center(
        child: Container(
          width: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
              ? double.infinity
              : MediaQuery.of(context).size.width * 0.45,
          alignment: Alignment.center,
          child: ResponsiveRowColumn(
            columnCrossAxisAlignment: CrossAxisAlignment.center,
            rowMainAxisAlignment: MainAxisAlignment.center,
            columnMainAxisAlignment: MainAxisAlignment.center,
            rowCrossAxisAlignment: CrossAxisAlignment.center,
            // layout: ResponsiveBreakpoints.of(context).smallerThan(TABLET)
            //     ? ResponsiveRowColumnType.COLUMN
            //     : ResponsiveRowColumnType.ROW,
            layout: ResponsiveRowColumnType.COLUMN,
            rowSpacing: 100,
            columnSpacing: 20,
            children: [
              ResponsiveRowColumnItem(
                rowFlex: 2,
                child: Managehrdbody(items: dataSub, popup: _showEmailDialog),
              ),
              // ResponsiveRowColumnItem(rowFlex: 2, child: bodySetting()),
            ],
          ),
        ),
      ),
    );
  }
}
