import 'package:job_platform/features/components/profile/data/models/profileModel.dart';
import 'package:job_platform/features/components/progress/data/models/certificateProgressModel.dart';
import 'package:job_platform/features/components/progress/data/models/educationProgressModel.dart';
import 'package:job_platform/features/components/progress/data/models/organizationProgressModel.dart';
import 'package:job_platform/features/components/progress/data/models/preferenceProgressModel.dart';
import 'package:job_platform/features/components/progress/data/models/skillProgressModel.dart';
import 'package:job_platform/features/components/progress/data/models/workExperienceProgressModel.dart';
import 'package:job_platform/features/components/statusJob/data/models/CompanyVacancies.dart';
import 'package:job_platform/features/components/statusJob/data/models/StatusVacancy.dart';
import 'package:job_platform/features/components/statusJob/data/models/UserVacancies.dart';

class ProgressDetailVM {
  final ProfileModel? dataUser;
  final CompanyVacancies? dataVacancy;
  final UserVacancies? dataUserVacancy;
  final List<StatusVacancy>? dataStatusVacancy;
  final List<SkillProgressModel>? dataSkill;
  final List<PreferenceProgressModel>? dataPreference;
  final List<OrganizationProgressModel>? dataOrganization;
  final List<WorkExperienceProgressModel>? dataExperience;
  final List<EducationProgressModel>? dataEducation;
  final List<CertificateProgressModel>? dataCertificate;
  ProgressDetailVM({
    this.dataUser,
    this.dataVacancy,
    this.dataUserVacancy,
    this.dataStatusVacancy,
    this.dataSkill,
    this.dataPreference,
    this.dataOrganization,
    this.dataExperience,
    this.dataEducation,
    this.dataCertificate,
  });
}
