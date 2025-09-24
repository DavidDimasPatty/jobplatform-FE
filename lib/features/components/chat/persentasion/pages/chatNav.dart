import 'package:flutter/material.dart';
import 'package:job_platform/features/components/chat/persentasion/pages/chat.dart';
import 'package:job_platform/features/components/chat/persentasion/pages/chatDetail.dart';
import 'package:job_platform/features/components/setting/persentation/pages/setting.dart';

class Chatnav extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const Chatnav({super.key, required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (setting) {
        switch (setting.name) {
          case "detail-chat":
            return MaterialPageRoute(
              builder: (_) => ChatDetail(navigatorKeys: navigatorKey),
            );
          default:
            return MaterialPageRoute(
              builder: (_) => Chat(navigatorKeys: navigatorKey),
            );
        }
      },
    );
  }
}
