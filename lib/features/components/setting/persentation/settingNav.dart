import 'package:flutter/material.dart';
import 'package:job_platform/features/components/setting/persentation/pages/setting.dart';

class Settingnav extends StatelessWidget {
  const Settingnav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (setting) {
        switch (setting.name) {
          default:
            return MaterialPageRoute(builder: (_) => Setting());
        }
      },
    );
  }
}
