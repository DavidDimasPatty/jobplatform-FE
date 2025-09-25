import 'package:flutter/material.dart';
import 'package:job_platform/features/components/profile/domain/entities/CertificateMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/EducationMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/OrganizationMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/PreferenceMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/WorkExperienceMV.dart';
import 'package:job_platform/features/components/profile/persentation/pages/profile.dart';
import 'package:job_platform/features/components/profile/persentation/pages/profile/certificateAdd.dart';
import 'package:job_platform/features/components/profile/persentation/pages/profile/certificateEdit.dart';
import 'package:job_platform/features/components/profile/persentation/pages/profile/educationalAdd.dart';
import 'package:job_platform/features/components/profile/persentation/pages/profile/educationalEdit.dart';
import 'package:job_platform/features/components/profile/persentation/pages/profile/experienceAdd.dart';
import 'package:job_platform/features/components/profile/persentation/pages/profile/experienceEdit.dart';
import 'package:job_platform/features/components/profile/persentation/pages/profile/organizationAdd.dart';
import 'package:job_platform/features/components/profile/persentation/pages/profile/organizationEdit.dart';
import 'package:job_platform/features/components/profile/persentation/pages/profile/preferenceAdd.dart';
import 'package:job_platform/features/components/profile/persentation/pages/profile/preferenceEdit.dart';

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
            final data = setting.arguments as CertificateMV;
            return MaterialPageRoute(
              builder: (_) => CertificateEdit(certificate: data),
            );
          case '/add-education':
            return MaterialPageRoute(builder: (_) => EducationalAdd());
          case '/edit-education':
            final data = setting.arguments as EducationMV;
            return MaterialPageRoute(
              builder: (_) => EducationalEdit(education: data),
            );
          case '/add-experience':
            return MaterialPageRoute(builder: (_) => ExperienceAdd());
          case '/edit-experience':
            final data = setting.arguments as WorkexperienceMV;
            return MaterialPageRoute(
              builder: (_) => ExperienceEdit(experience: data),
            );
          case '/add-organization':
            return MaterialPageRoute(builder: (_) => OrganizationAdd());
          case '/edit-organization':
            final data = setting.arguments as OrganizationMV;
            return MaterialPageRoute(
              builder: (_) => OrganizationEdit(organization: data),
            );
          case '/add-preference':
            return MaterialPageRoute(builder: (_) => PreferenceAdd());
          case '/edit-preference':
            final data = setting.arguments as PreferenceMV;
            return MaterialPageRoute(
              builder: (_) => PreferenceEdit(preference: data),
            );
          default:
            return MaterialPageRoute(builder: (_) => Profile());
        }
      },
    );
  }
}
