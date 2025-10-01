import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:job_platform/features/components/cart/persentation/widgets/cartBody.dart';
import 'package:job_platform/features/components/cart/persentation/widgets/cartItems.dart';
import 'package:job_platform/features/components/chat/persentasion/widget/chat/chatBody.dart';
import 'package:job_platform/features/components/chat/persentasion/widget/chat/chatItems.dart';
import 'package:job_platform/features/components/login/persentation/widgets/loginForm.dart';
import 'package:job_platform/features/components/setting/persentation/widgets/bodySetting.dart';
import 'package:job_platform/features/components/setting/persentation/widgets/settingGroup.dart'
    show SettingsGroup;
import 'package:job_platform/features/components/setting/persentation/widgets/settingItem.dart';
import 'package:job_platform/features/components/setting/persentation/widgets/topSetting.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Cart extends StatefulWidget {
  Cart({super.key});

  @override
  State<Cart> createState() => _Cart();
}

class _Cart extends State<Cart> {
  List<Cartitems> dataSub = [];
  // Loading state
  bool isLoading = true;
  String? errorMessage;
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
          Cartitems(
            url: "assets/images/BG_Pelamar.png",
            title: "Nando Witin (25)",
            subtitle: "Back End Developer",
          ),
          Cartitems(
            url: "assets/images/BG_Pelamar.png",
            title: "Nando Sitorus (25)",
            subtitle: "Back End Developer",
          ),
          Cartitems(
            url: "assets/images/BG_Pelamar.png",
            title: "Nando Baltwin (25)",
            subtitle: "Front End Developer",
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
                child: Cartbody(items: dataSub),
              ),
              // ResponsiveRowColumnItem(rowFlex: 2, child: bodySetting()),
            ],
          ),
        ),
      ),
    );
  }
}
