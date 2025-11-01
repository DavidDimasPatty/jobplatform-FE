import 'package:job_platform/features/components/profile/domain/entities/CertificateMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/EducationMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/OrganizationMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/PreferenceMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/ProfileData.dart';
import 'package:job_platform/features/components/profile/domain/entities/SkillMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/WorkExperienceMV.dart';

class ProfileModel {
  final Profiledata? user;
  final List<PreferenceMV>? preferences;
  final List<WorkexperienceMV>? experiences;
  final List<SkillMV>? skills;
  final List<CertificateMV>? certificates;
  final List<EducationMV>? educations;
  final List<OrganizationMV>? organizations;
  // final List<CompanyMV>? companies;

  ProfileModel({
    this.user,
    this.preferences,
    this.experiences,
    this.skills,
    this.certificates,
    this.educations,
    this.organizations,
    // this.companies,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      user: json["data"]["user"] != null
          ? Profiledata.fromJson(json["data"]["user"])
          : null,
      preferences: json["data"]["preference"]
          .map<PreferenceMV>((item) => PreferenceMV.fromJson(item))
          .toList()
          .cast<PreferenceMV>(),
      experiences: json["data"]["linkExperience"]
          .map<WorkexperienceMV>((item) => WorkexperienceMV.fromJson(item))
          .toList()
          .cast<WorkexperienceMV>(),
      certificates: json["data"]["linkCertificate"]
          .map<CertificateMV>((item) => CertificateMV.fromJson(item))
          .toList()
          .cast<CertificateMV>(),
      skills: json["data"]["linkSkill"]
          .map<SkillMV>((item) => SkillMV.fromJson(item))
          .toList()
          .cast<SkillMV>(),
      educations: json["data"]["linkEducation"]
          .map<EducationMV>((item) => EducationMV.fromJson(item))
          .toList()
          .cast<EducationMV>(),
      organizations: json["data"]["linkOrganization"]
          .map<OrganizationMV>((item) => OrganizationMV.fromJson(item))
          .toList()
          .cast<OrganizationMV>(),
      // companies: json["data"]["linkCompany"],
    );
  }

  factory ProfileModel.fromJsonProgress(Map<String, dynamic> json) {
    return ProfileModel(
      user: json["user"] != null ? Profiledata.fromJson(json["user"]) : null,
      preferences: json["preference"] != null
          ? List<PreferenceMV>.from(
              json["preference"].map((x) => PreferenceMV.fromJson(x)),
            )
          : null,
      experiences: json["experience"] != null
          ? List<WorkexperienceMV>.from(
              json["experience"].map((x) => WorkexperienceMV.fromJson(x)),
            )
          : null,
      certificates: json["certificate"] != null
          ? List<CertificateMV>.from(
              json["certificate"].map((x) => CertificateMV.fromJson(x)),
            )
          : null,
      skills: json["linkSkill"] != null
          ? List<SkillMV>.from(
              json["linkSkill"].map((x) => SkillMV.fromJson(x)),
            )
          : null,
      educations: json["education"] != null
          ? List<EducationMV>.from(
              json["education"].map((x) => EducationMV.fromJson(x)),
            )
          : null,
      organizations: json["organization"] != null
          ? List<OrganizationMV>.from(
              json["organization"].map((x) => OrganizationMV.fromJson(x)),
            )
          : null,
      // companies: json["data"]["linkCompany"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "user": user ?? {},
      "certificates": certificates ?? [],
      "educations": educations ?? [],
      "experiences": experiences ?? [],
      "organizations": organizations ?? [],
      "preferences": preferences ?? [],
      "skills": skills ?? [],
      // "companies": companies ?? [],
    };
  }
}
