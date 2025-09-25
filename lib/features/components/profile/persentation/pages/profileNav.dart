import 'package:flutter/material.dart';
import 'package:job_platform/features/components/profile/domain/entities/CertificateMV.dart';
import 'package:job_platform/features/components/profile/persentation/pages/profile.dart';
import 'package:job_platform/features/components/profile/persentation/pages/profile/certificateAdd.dart';
import 'package:job_platform/features/components/profile/persentation/pages/profile/certificateEdit.dart';

class ProfileNav extends StatelessWidget {
  const ProfileNav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (setting) {
        switch (setting.name) {
          case '/':
          case null:
            return MaterialPageRoute(
              builder: (_) => Profile(),
              settings: RouteSettings(name: '/'),
            );
          case '/add-certificate':
            return MaterialPageRoute(builder: (_) => CertificateAdd());
          case '/edit-certificate':
            final certId = setting.arguments as CertificateMV;
            return MaterialPageRoute(builder: (_) => CertificateEdit(certificate: certId));
          default:
            return MaterialPageRoute(builder: (_) => Profile());
        }
      },
    );
  }
}
