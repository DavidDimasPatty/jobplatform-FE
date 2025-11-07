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
import 'package:job_platform/features/components/profile/domain/entities/CertificateMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/EducationMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/OrganizationMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/PreferenceMV.dart';
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
import 'package:job_platform/features/components/progress/persentation/pages/editVacancyCandidate.dart';
import 'package:job_platform/features/components/progress/persentation/pages/progress.dart';
import 'package:job_platform/features/components/progress/persentation/pages/progressDetail.dart';
import 'package:job_platform/features/components/setting/persentation/pages/UpgradeAccount.dart';
import 'package:job_platform/features/components/setting/persentation/pages/aboutUs.dart';
import 'package:job_platform/features/components/setting/persentation/pages/appearance.dart';
import 'package:job_platform/features/components/setting/persentation/pages/faq.dart';
import 'package:job_platform/features/components/setting/persentation/pages/setting.dart';
import 'package:job_platform/features/components/setting/persentation/pages/settingEmail.dart';
import 'package:job_platform/features/components/setting/persentation/pages/settingNotification.dart';
import 'package:job_platform/features/components/setting/persentation/pages/tos.dart';
import 'package:job_platform/features/components/signup/persentation/pages/signup.dart';
import 'package:job_platform/features/components/signup/persentation/pages/signupPelamar.dart';
import 'package:job_platform/features/components/signup/persentation/pages/signupPerusahaan.dart';
import 'package:job_platform/features/components/statusJob/data/models/CompanyVacancies.dart';
import 'package:job_platform/features/components/statusJob/data/models/UserVacancies.dart';
import 'package:job_platform/features/components/statusJob/persentation/pages/statusJob.dart';
import 'package:job_platform/features/components/statusJob/persentation/pages/statusJobDetail.dart';
import 'package:job_platform/features/components/vacancy/domain/entities/vacancyData.dart';
import 'package:job_platform/features/components/vacancy/persentation/pages/vacancy.dart';
import 'package:job_platform/features/components/vacancy/persentation/pages/vacancyAdd.dart';
import 'package:job_platform/features/components/vacancy/persentation/pages/vacancyDetail.dart';
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
      return Personalinfocompany();
    },
  ),
  GoRoute(path: '/profile', builder: (context, state) => Profile()),
  //setting
  GoRoute(path: '/setting', builder: (context, state) => Setting()),
  GoRoute(path: '/tos', builder: (context, state) => Tos()),
  GoRoute(path: "/aboutUs", builder: (context, state) => Aboutus()),
  GoRoute(path: "/faq", builder: (context, state) => FAQ()),

  GoRoute(
    path: "/appearance",
    builder: (context, state) {
      final extraData = state.extra as Map<String, dynamic>?;
      Future<void> Function(String language)? changeLanguage =
          extraData?['changeLanguage'];
      Future<void> Function(
        String fontSizeHead,
        String fontSizeSubHead,
        String fontSizeBody,
        String fontSizeIcon,
      )?
      changeFontSize = extraData?['changeFontSize'];
      final fontSizeBody = extraData?['fontSizeBody'] as int?;
      final fontSizeHead = extraData?['fontSizeHead'] as int?;
      final fontSizeIcon = extraData?['fontSizeIcon'] as int?;
      final fontSizeSubHead = extraData?['fontSizeSubHead'] as int?;
      final language = extraData?['language'] as String?;
      final Future<void> Function() reload = extraData?['reload'];
      return Appearance(
        changeFontSize: changeFontSize,
        changeLanguage: changeLanguage,
        fontSizeBody: fontSizeBody,
        fontSizeHead: fontSizeHead,
        fontSizeIcon: fontSizeIcon,
        fontSizeSubHead: fontSizeSubHead,
        language: language,
        reload: reload,
      );
    },
  ),

  GoRoute(
    path: "/setNotification",
    builder: (context, state) {
      final extraData = state.extra as Map<String, dynamic>?;
      Future<void> Function(bool value) changeExternalNotifApp =
          extraData?['changeExternalNotifApp'];
      Future<void> Function(bool value)? changeNotifApp =
          extraData?['changeNotifApp'];
      final isNotifExternal = extraData?['isNotifExternal'] as bool?;
      final isNotifInternal = extraData?['isNotifInternal'] as bool?;
      final Future<void> Function() reload = extraData?['reload'];
      return Settingnotification(
        changeExternalNotifApp: changeExternalNotifApp,
        changeNotifApp: changeNotifApp,
        isNotifExternal: isNotifExternal,
        isNotifInternal: isNotifInternal,
        reload: reload,
      );
    },
  ),

  GoRoute(
    path: "/upgradeAccount",
    builder: (context, state) {
      final extraData = state.extra as Map<String, dynamic>?;
      Future<void> Function(bool value)? upgradePlan =
          extraData?['upgradePlan'];
      final isPremium = extraData?['isPremium'] as bool?;
      final Future<void> Function() reload = extraData?['reload'];
      return Upgradeaccount(
        isPremium: isPremium,
        upgradePlan: upgradePlan,
        reload: reload,
      );
    },
  ),

  GoRoute(
    path: "/settingEmail",
    builder: (context, state) {
      final extraData = state.extra as Map<String, dynamic>?;
      Future<void> Function(String oldEmail, String newEmail)?
      changeEmailAccount = extraData?['changeEmailAccount'];
      final Future<void> Function() reload = extraData?['reload'];
      return Settingemail(
        changeEmailAccount: changeEmailAccount,
        reload: reload,
      );
    },
  ),

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
    path: '/editVacancyCandidate',
    builder: (context, state) {
      final extraData = state.extra as Map<String, dynamic>?;
      final dataVacancy = extraData?['dataVacancy'] as CompanyVacancies;
      final dataUserVacancy = extraData?['dataUserVacancy'] as UserVacancies;
      return editVacancyCandidate(
        dataUserVacancy: dataUserVacancy,
        dataVacancy: dataVacancy,
      );
    },
  ),
  GoRoute(
    path: '/progressDetail',
    builder: (context, state) {
      final extraData = state.extra as Map<String, dynamic>?;
      final dataId = extraData?['data'] as String?;
      return Progressdetail(dataId: dataId);
    },
  ),
  GoRoute(path: '/statusJob', builder: (context, state) => statusJob()),
  GoRoute(
    path: '/statusJobDetail',
    builder: (context, state) {
      final extraData = state.extra as Map<String, dynamic>?;
      final dataId = extraData?['data'] as String?;
      return Statusjobdetail(dataId: dataId);
    },
  ),
  GoRoute(path: '/vacancy', builder: (context, state) => Vacancy()),
  GoRoute(
    path: '/vacancyEdit',
    builder: (context, state) {
      final data = state.extra as VacancyData;
      return Vacancyedit(data: data);
    },
  ),
  GoRoute(
    path: '/vacancyDetail',
    builder: (context, state) {
      final data = state.extra as VacancyData;
      return VacancyDetail(data: data);
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
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => Landing()),
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
