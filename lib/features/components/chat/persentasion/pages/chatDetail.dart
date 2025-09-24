import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:job_platform/features/components/chat/domain/entities/ChatDetailItems.dart';
import 'package:job_platform/features/components/chat/persentasion/widget/chat/chatBody.dart';
import 'package:job_platform/features/components/chat/persentasion/widget/chat/chatItems.dart';
import 'package:job_platform/features/components/chat/persentasion/widget/chatDetail/chatDetailBody.dart';
import 'package:job_platform/features/components/chat/persentasion/widget/chatDetail/chatDetailBottom.dart';
import 'package:job_platform/features/components/chat/persentasion/widget/chatDetail/chatDetailTop.dart';
import 'package:job_platform/features/components/login/persentation/widgets/loginForm.dart';
import 'package:job_platform/features/components/setting/persentation/widgets/bodySetting.dart';
import 'package:job_platform/features/components/setting/persentation/widgets/settingGroup.dart'
    show SettingsGroup;
import 'package:job_platform/features/components/setting/persentation/widgets/settingItem.dart';
import 'package:job_platform/features/components/setting/persentation/widgets/topSetting.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ChatDetail extends StatefulWidget {
  Key navigatorKeys;
  ChatDetail({super.key, required this.navigatorKeys});

  @override
  State<ChatDetail> createState() => _ChatDetail();
}

class _ChatDetail extends State<ChatDetail> {
  List<Chatdetailitems> dataChat = [];
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
        dataChat = [
          Chatdetailitems(
            id: "1",
            addDate: DateTime.parse("2025-05-05 04:04:30"),
            message: "Halo David",
            nama: "HRD",
          ),
          Chatdetailitems(
            id: "1",
            addDate: DateTime.parse("2025-05-05 04:04:30"),
            message: "Halo Bu",
            nama: "David",
          ),
          Chatdetailitems(
            id: "1",
            addDate: DateTime.parse("2025-05-05 04:04:30"),
            message: "Gimana Kabar?",
            nama: "HRD",
          ),
          Chatdetailitems(
            id: "1",
            addDate: DateTime.parse("2025-05-05 04:04:30"),
            message: "Baik",
            nama: "David",
          ),
          Chatdetailitems(
            id: "1",
            addDate: DateTime.parse("2025-05-05 04:04:30"),
            message: "Halo David",
            nama: "HRD",
          ),
          Chatdetailitems(
            id: "1",
            addDate: DateTime.parse("2025-05-05 04:04:30"),
            message: "Halo Bu",
            nama: "David",
          ),
          Chatdetailitems(
            id: "1",
            addDate: DateTime.parse("2025-05-05 04:04:30"),
            message: "Gimana Kabar?",
            nama: "HRD",
          ),
          Chatdetailitems(
            id: "1",
            addDate: DateTime.parse("2025-05-05 04:04:30"),
            message: "Baik",
            nama: "David",
          ),
          Chatdetailitems(
            id: "1",
            addDate: DateTime.parse("2025-05-05 04:04:30"),
            message: "Halo David",
            nama: "HRD",
          ),
          Chatdetailitems(
            id: "1",
            addDate: DateTime.parse("2025-05-05 04:04:30"),
            message: "Halo Bu",
            nama: "David",
          ),
          Chatdetailitems(
            id: "1",
            addDate: DateTime.parse("2025-05-05 04:04:30"),
            message: "Gimana Kabar?",
            nama: "HRD",
          ),
          Chatdetailitems(
            id: "1",
            addDate: DateTime.parse("2025-05-05 04:04:30"),
            message: "Baik",
            nama: "David",
          ),
          Chatdetailitems(
            id: "1",
            addDate: DateTime.parse("2025-05-05 04:04:30"),
            message: "Halo David",
            nama: "HRD",
          ),
          Chatdetailitems(
            id: "1",
            addDate: DateTime.parse("2025-05-05 04:04:30"),
            message: "Halo Bu",
            nama: "David",
          ),
          Chatdetailitems(
            id: "1",
            addDate: DateTime.parse("2025-05-05 04:04:30"),
            message: "Gimana Kabar?",
            nama: "HRD",
          ),
          Chatdetailitems(
            id: "1",
            addDate: DateTime.parse("2025-05-05 04:04:30"),
            message: "Baik",
            nama: "David",
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

    return Center(
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        width: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
            ? double.infinity
            : MediaQuery.of(context).size.width * 0.45,
        alignment: Alignment.center,
        child: ResponsiveRowColumn(
          columnCrossAxisAlignment: CrossAxisAlignment.start,
          rowMainAxisAlignment: MainAxisAlignment.start,
          columnMainAxisAlignment: MainAxisAlignment.start,
          rowCrossAxisAlignment: CrossAxisAlignment.start,
          // layout: ResponsiveBreakpoints.of(context).smallerThan(TABLET)
          //     ? ResponsiveRowColumnType.COLUMN
          //     : ResponsiveRowColumnType.ROW,
          layout: ResponsiveRowColumnType.COLUMN,
          rowSpacing: 100,
          columnSpacing: 20,

          children: [
            ResponsiveRowColumnItem(
              rowFlex: 2,
              child: Chatdetailtop(dataChat: dataChat[0]),
            ),
            ResponsiveRowColumnItem(
              rowFlex: 2,
              child: Expanded(child: Chatdetailbody(dataChat: dataChat)),
            ),
            ResponsiveRowColumnItem(rowFlex: 2, child: Chatdetailbottom()),
            // ResponsiveRowColumnItem(rowFlex: 2, child: bodySetting()),
          ],
        ),
      ),
    );
  }
}
