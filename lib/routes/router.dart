import 'package:flutter/material.dart' hide Notification;
import 'package:go_router/go_router.dart';
import 'package:job_platform/features/components/candidate/persentation/pages/candidate.dart';
import 'package:job_platform/features/components/candidate/persentation/pages/candidateDetail.dart';
import 'package:job_platform/features/components/cart/persentation/pages/cart.dart';
import 'package:job_platform/features/components/chat/persentasion/pages/chat.dart';
import 'package:job_platform/features/components/chat/persentasion/pages/chatDetail.dart';
import 'package:job_platform/features/components/error/persentation/error.dart';
import 'package:job_platform/features/components/home/persentation/pages/homePage.dart';
import 'package:job_platform/features/components/home/persentation/pages/homePageCompany.dart';
import 'package:job_platform/features/components/landing/persentation/landing.dart';
import 'package:job_platform/features/components/login/persentation/pages/login.dart';
import 'package:job_platform/features/components/manageHRD/persentation/pages/manageHRD.dart';
import 'package:job_platform/features/components/manageHRD/persentation/pages/manageHRDAdd.dart';
import 'package:job_platform/features/components/manageHRD/persentation/pages/manageHRDEdit.dart';
import 'package:job_platform/features/components/notification/persentation/page/notificationDetail.dart';
import 'package:job_platform/features/components/notification/persentation/widgets/notificationDetailBody.dart';
import 'package:job_platform/features/components/profile/domain/entities/CertificateMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/EducationMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/OrganizationMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/PreferenceMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/ProfileCompanyData.dart';
import 'package:job_platform/features/components/profile/domain/entities/ProfileData.dart';
import 'package:job_platform/features/components/profile/domain/entities/SkillMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/WorkExperienceMV.dart';
import 'package:job_platform/features/components/profile/persentation/pages/personalInfo.dart';
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
import 'package:job_platform/features/components/profile/persentation/pages/profile/skillEdit.dart';
import 'package:job_platform/features/components/profile/persentation/pages/profileCompany.dart';
import 'package:job_platform/features/components/profile/persentation/pages/profileCompany/personalInfoCompany.dart';
import 'package:job_platform/features/components/progress/persentation/pages/progress.dart';
import 'package:job_platform/features/components/progress/persentation/pages/progressDetail.dart';
import 'package:job_platform/features/components/setting/persentation/pages/setting.dart';
import 'package:job_platform/features/components/signup/persentation/pages/signup.dart';
import 'package:job_platform/features/components/signup/persentation/pages/signupPelamar.dart';
import 'package:job_platform/features/components/signup/persentation/pages/signupPerusahaan.dart';
import 'package:job_platform/features/components/statusJob/persentation/pages/statusJob.dart';
import 'package:job_platform/features/components/statusJob/persentation/pages/statusJobDetail.dart';
import 'package:job_platform/features/components/vacancy/persentation/pages/vacancy.dart';
import 'package:job_platform/features/components/vacancy/persentation/pages/vacancyAdd.dart';
import 'package:job_platform/features/components/vacancy/persentation/pages/vacancyEdit.dart';
import 'package:job_platform/features/shared/layout.dart';

final List<GoRoute> _layoutRoutes = [
  GoRoute(path: '/home', builder: (context, state) => HomePage()),
  GoRoute(path: '/homeCompany', builder: (context, state) => HomePageCompany()),
  GoRoute(path: '/candidate', builder: (context, state) => Candidate()),
  GoRoute(
    path: '/candidateDetail',
    builder: (context, state) {
      final data = state.extra as String?;
      return Candidatedetail(dataId: data);
    },
  ),
  GoRoute(
    path: '/profileCompany',
    builder: (context, state) => ProfileCompany(),
  ),
  GoRoute(
    path: '/personalInfoCompany',
    builder: (context, state) {
      final data = state.extra as ProfileCompanydata;
      return Personalinfocompany(dataCompany: data);
    },
  ),
  GoRoute(path: '/profile', builder: (context, state) => Profile()),
  GoRoute(path: '/setting', builder: (context, state) => Setting()),
  GoRoute(
    path: '/edit-profile',
    builder: (context, state) {
      final data = state.extra as Profiledata;
      return Personalinfo(userProfile: data);
    },
  ),
  GoRoute(
    path: '/add-certificate',
    builder: (context, state) => CertificateAdd(),
  ),
  GoRoute(
    path: '/edit-certificate',
    builder: (context, state) {
      final data = state.extra as CertificateMV;
      return CertificateEdit(certificate: data);
    },
  ),
  GoRoute(
    path: '/add-education',
    builder: (context, state) => EducationalAdd(),
  ),
  GoRoute(
    path: '/edit-education',
    builder: (context, state) {
      final data = state.extra as EducationMV;
      return EducationalEdit(education: data);
    },
  ),
  GoRoute(
    path: '/add-experience',
    builder: (context, state) => ExperienceAdd(),
  ),
  GoRoute(
    path: '/edit-experience',
    builder: (context, state) {
      final data = state.extra as WorkexperienceMV;
      return ExperienceEdit(experience: data);
    },
  ),
  GoRoute(
    path: '/add-organization',
    builder: (context, state) => OrganizationAdd(),
  ),
  GoRoute(
    path: '/edit-organization',
    builder: (context, state) {
      final data = state.extra as OrganizationMV;
      return OrganizationEdit(organization: data);
    },
  ),
  GoRoute(
    path: '/edit-skill',
    builder: (context, state) {
      final data = state.extra as List<SkillMV>;
      return SkillEdit(skills: data);
    },
  ),
  GoRoute(
    path: '/add-preference',
    builder: (context, state) => PreferenceAdd(),
  ),
  GoRoute(
    path: '/edit-preference',
    builder: (context, state) {
      final data = state.extra as PreferenceMV;
      return PreferenceEdit(preference: data);
    },
  ),
  GoRoute(path: '/cart', builder: (context, state) => Cart()),
  GoRoute(path: '/chat', builder: (context, state) => Chat()),
  GoRoute(path: '/chatDetail', builder: (context, state) => ChatDetail()),
  GoRoute(path: '/progress', builder: (context, state) => Progress()),
  GoRoute(
    path: '/progressDetail',
    builder: (context, state) {
      final data = state.extra as String?;
      return Progressdetail(dataId: data);
    },
  ),
  GoRoute(path: '/statusJob', builder: (context, state) => statusJob()),
  GoRoute(
    path: '/statusJobDetail',
    builder: (context, state) {
      final data = state.extra as String?;
      return Statusjobdetail(dataId: data);
    },
  ),
  GoRoute(path: '/vacancy', builder: (context, state) => Vacancy()),
  GoRoute(
    path: '/vacancyEdit',
    builder: (context, state) {
      final data = state.extra as PreferenceMV;
      return Vacancyedit(data: data);
    },
  ),
  GoRoute(path: '/vacancyAdd', builder: (context, state) => Vacancyadd()),
  GoRoute(path: '/manageHRD', builder: (context, state) => Managehrd()),
  GoRoute(path: '/manageHRDAdd', builder: (context, state) => Managehrdadd()),
  GoRoute(
    path: '/manageHRDEdit',
    builder: (context, state) {
      final data = state.extra as PreferenceMV;
      return Managehrdedit(data: data);
    },
  ),
  GoRoute(
    path: '/notificationDetail',
    builder: (context, state) => NotificationDetail(),
  ),
];

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/landing', builder: (context, state) => Landing()),
    GoRoute(path: '/login', builder: (context, state) => Login()),
    GoRoute(
      path: '/signUp',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>?;
        final email = data?['email'];
        final name = data?['name'];
        final photoUrl = data?["photoUrl"];
        final token = data?["token"];
        return SignUp(name, email, photoUrl, token);
      },
    ),
    GoRoute(
      path: '/signUpPerusahaan',
      builder: (context, state) {
        final email = state.extra as String;
        return SignUpPerusahaan(email);
      },
    ),
    GoRoute(
      path: '/signUpPelamar',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>?;
        final email = data?['email'];
        final name = data?['name'];
        final photoUrl = data?["photoUrl"];
        final token = data?["token"];
        return SignUpPelamar(name, email, photoUrl, token);
      },
    ),
    ShellRoute(
      builder: (context, state, child) {
        return Layout(child: child);
      },
      routes: _layoutRoutes,
    ),
  ],
  errorBuilder: (context, state) {
    return ErrorPage();
  },
);
