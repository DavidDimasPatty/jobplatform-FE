import 'package:flutter/material.dart';
import 'package:job_platform/features/components/chat/persentasion/pages/chat.dart';
import 'package:job_platform/features/components/chat/persentasion/pages/chatDetail.dart';
import 'package:job_platform/features/components/setting/persentation/pages/setting.dart';

class Chatnav extends StatelessWidget {
  const Chatnav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (setting) {
        switch (setting.name) {
          case "detail-chat":
            return MaterialPageRoute(builder: (_) => ChatDetail());
          default:
            return MaterialPageRoute(builder: (_) => Chat());
        }
      },
    );
  }
}
