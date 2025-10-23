import 'package:job_platform/features/components/profile/data/models/certificateModel.dart';
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
import 'package:job_platform/features/components/statusJob/data/models/CompanyVacancies.dart';
import 'package:job_platform/features/components/statusJob/data/models/StatusVacancy.dart';
import 'package:job_platform/features/components/statusJob/data/models/UserVacancies.dart';

class DetailProgressModel {
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

  DetailProgressModel({
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

  factory DetailProgressModel.fromJson(Map<String, dynamic> json) {
    return DetailProgressModel(
      dataUser: json["user"] != null
          ? ProfileModel.fromJson(json["user"])
          : null,
      dataVacancy: json["vacancy"] != null
          ? CompanyVacancies.fromJson(json["vacancy"])
          : null,
      dataUserVacancy: json["userVacancy"] != null
          ? UserVacancies.fromJson(json["userVacancy"])
          : null,
      dataStatusVacancy: json["status"] != null
          ? List<StatusVacancy>.from(
              json["status"].map((x) => StatusVacancy.fromJson(x)),
            )
          : null,
      dataSkill: json["linkSkill"] != null
          ? List<SkillProgressModel>.from(
              json["linkSkill"].map((x) => SkillProgressModel.fromJson(x)),
            )
          : null,
      dataCertificate: json["certificate"] != null
          ? List<CertificateProgressModel>.from(
              json["certificate"].map(
                (x) => CertificateProgressModel.fromJson(x),
              ),
            )
          : null,
      dataEducation: json["education"] != null
          ? List<EducationProgressModel>.from(
              json["education"].map((x) => EducationProgressModel.fromJson(x)),
            )
          : null,
      dataOrganization: json["organization"] != null
          ? List<OrganizationProgressModel>.from(
              json["organization"].map(
                (x) => OrganizationProgressModel.fromJson(x),
              ),
            )
          : null,
      dataExperience: json["experience"] != null
          ? List<WorkExperienceProgressModel>.from(
              json["experience"].map(
                (x) => WorkExperienceProgressModel.fromJson(x),
              ),
            )
          : null,
      dataPreference: json["preference"] != null
          ? List<PreferenceProgressModel>.from(
              json["preference"].map(
                (x) => PreferenceProgressModel.fromJson(x),
              ),
            )
          : null,
    );
  }
}
