import 'package:job_platform/features/components/profile/data/models/certificateModel.dart';
import 'package:job_platform/features/components/profile/data/models/certificateRequest.dart';
import 'package:job_platform/features/components/profile/data/models/educationModel.dart';
import 'package:job_platform/features/components/profile/data/models/educationRequest.dart';
import 'package:job_platform/features/components/profile/data/models/organizationModel.dart';
import 'package:job_platform/features/components/profile/data/models/organizationRequest.dart';
import 'package:job_platform/features/components/profile/data/models/preferenceRequest.dart';
import 'package:job_platform/features/components/profile/data/models/profileModel.dart';
import 'package:job_platform/features/components/profile/data/models/skillModel.dart';
import 'package:job_platform/features/components/profile/data/models/skillRequest.dart';
import 'package:job_platform/features/components/profile/data/models/workExperienceModel.dart';
import 'package:job_platform/features/components/profile/data/models/workExperienceRequest.dart';
import 'package:job_platform/features/components/progress/data/models/certificateProgressModel.dart';
import 'package:job_platform/features/components/progress/data/models/educationProgressModel.dart';
import 'package:job_platform/features/components/progress/data/models/organizationProgressModel.dart';
import 'package:job_platform/features/components/progress/data/models/preferenceProgressModel.dart';
import 'package:job_platform/features/components/progress/data/models/skillProgressModel.dart';
import 'package:job_platform/features/components/progress/data/models/workExperienceProgressModel.dart';
import 'package:job_platform/features/components/progress/persentation/widgets/detail/educationProgress.dart';
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
