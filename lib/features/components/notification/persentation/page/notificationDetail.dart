import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:job_platform/features/components/cart/persentation/widgets/cartBody.dart';
import 'package:job_platform/features/components/cart/persentation/widgets/cartItems.dart';
import 'package:job_platform/features/components/chat/persentasion/widget/chat/chatBody.dart';
import 'package:job_platform/features/components/chat/persentasion/widget/chat/chatItems.dart';
import 'package:job_platform/features/components/login/persentation/widgets/loginForm.dart';
import 'package:job_platform/features/components/notification/persentation/widgets/notificationDetailBody.dart';
import 'package:job_platform/features/components/notification/persentation/widgets/notificationDetailItems.dart';
import 'package:job_platform/features/components/setting/persentation/widgets/bodySetting.dart';
import 'package:job_platform/features/components/setting/persentation/widgets/settingGroup.dart'
    show SettingsGroup;
import 'package:job_platform/features/components/setting/persentation/widgets/settingItem.dart';
import 'package:job_platform/features/components/setting/persentation/widgets/topSetting.dart';
import 'package:job_platform/features/shared/Notification/Notification.dart';
import 'package:responsive_framework/responsive_framework.dart';

class NotificationDetail extends StatefulWidget {
  NotificationDetail({super.key});

  @override
  State<NotificationDetail> createState() => _NotificationDetail();
}

class _NotificationDetail extends State<NotificationDetail> {
  List<NotificationDetailitems> dataSub = [];
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
          NotificationDetailitems(
            icon: Icons.warning,
            iconColor: Colors.yellowAccent,
            title: "HRD has seen your profile!🤗",
            subtitle: "Let's we hope for the best!😇",
            bgColor: Colors.yellow.shade200,
            about: "job",
          ),
          NotificationDetailitems(
            icon: Icons.dangerous,
            iconColor: Colors.redAccent,
            title: "You have been rejected from PT. Indomarco Prismatama!🥺🥺",
            subtitle:
                "We are really sorry to inform you, that you have been rejected at Interview Proses in PT. Indomarco Prismatama",
            bgColor: Colors.red.shade200,
            about: "job",
          ),
          NotificationDetailitems(
            icon: Icons.dangerous,
            iconColor: Colors.redAccent,
            title: "You have been rejected from PT. Inti Dunia Sukses!🥺🥺",
            subtitle:
                "We are really sorry to inform you, that you have been rejected at Interview Proses in PT. Inti Dunia Sukses",
            bgColor: Colors.red.shade200,
            about: "job",
          ),
          NotificationDetailitems(
            icon: Icons.tag_faces_rounded,
            iconColor: Colors.greenAccent,
            title:
                "Anda Telah Ditambahkan menjadi HRD PT.Indomaret Group! 🥳🥳",
            subtitle: "Perlu Konfirmasi Anda (Memerlukan login ulang)!💪",
            bgColor: Colors.green.shade200,
            about: "offer",
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
                child: NotificationDetailbody(items: dataSub),
              ),
              // ResponsiveRowColumnItem(rowFlex: 2, child: bodySetting()),
            ],
          ),
        ),
      ),
    );
  }
}
