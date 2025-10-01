import 'package:flutter/material.dart';
import 'package:job_platform/features/components/candidate/persentation/pages/candidate.dart';
import 'package:job_platform/features/components/candidate/persentation/pages/candidateDetail.dart';
import 'package:job_platform/features/components/chat/persentasion/pages/chat.dart';
import 'package:job_platform/features/components/chat/persentasion/pages/chatDetail.dart';
import 'package:job_platform/features/components/setting/persentation/pages/setting.dart';

class Candidatenav extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  Candidatenav({super.key, required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (setting) {
        switch (setting.name) {
          case "detail-candidate":
            final data = setting.arguments as String;
            return MaterialPageRoute(
              builder: (_) =>
                  Candidatedetail(navigatorKeys: navigatorKey, dataId: data),
            );
          default:
            return MaterialPageRoute(builder: (_) => Candidate());
        }
      },
    );
  }
}
