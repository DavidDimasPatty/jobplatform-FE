import 'package:flutter/material.dart';
import 'package:job_platform/features/components/cart/persentation/pages/cart.dart';
import 'package:job_platform/features/components/chat/persentasion/pages/chat.dart';
import 'package:job_platform/features/components/chat/persentasion/pages/chatDetail.dart';
import 'package:job_platform/features/components/setting/persentation/pages/setting.dart';

class Cartnav extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  Cartnav({super.key, required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (setting) {
        switch (setting.name) {
          default:
            return MaterialPageRoute(
              builder: (_) => Cart(navigatorKeys: navigatorKey),
            );
        }
      },
    );
  }
}
