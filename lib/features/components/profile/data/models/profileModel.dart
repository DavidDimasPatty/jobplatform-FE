import 'package:job_platform/features/components/profile/domain/entities/CertificateMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/EducationMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/OrganizationMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/PreferenceMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/ProfileData.dart';
import 'package:job_platform/features/components/profile/domain/entities/SkillMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/WorkExperienceMV.dart';

class ProfileModel {
  // final Profiledata? user;
  final List<PreferenceMV>? preferences;
  final List<WorkexperienceMV>? experiences;
  final List<SkillMV>? skills;
  final List<CertificateMV>? certificates;
  final List<EducationMV>? educations;
  final List<OrganizationMV>? organizations;
  // final List<CompanyMV>? companies;

  ProfileModel({
    // this.user,
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
      // user: json["data"]["user"],
      preferences: json["data"]["linkPreference"]
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

  Map<String, dynamic> toJson() {
    return {
      // "user": user,
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
