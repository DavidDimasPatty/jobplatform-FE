import 'package:job_platform/features/components/profile/data/models/organizationModel.dart';
import 'package:job_platform/features/components/profile/data/models/skillModel.dart';

class OrganizationRequest {
  String idUser;
  String? idUserOrganization;
  OrganizationModel organization;
  List<SkillModel> skill;
  bool isActive;
  String? deskripsi;
  String jabatan;
  DateTime startDate;
  DateTime? endDate;

  OrganizationRequest({
    required this.idUser,
    this.idUserOrganization,
    required this.organization,
    required this.skill,
    this.isActive = true,
    this.deskripsi,
    required this.jabatan,
    required this.startDate,
    this.endDate,
  });

  factory OrganizationRequest.fromJson(Map<String, dynamic> json) {
    return OrganizationRequest(
      idUser: json['idUser'],
      idUserOrganization: json['idUserOrganization'],
      organization: OrganizationModel.fromJson(json['organization']),
      skill:
          (json['skill'] as List<dynamic>?)
              ?.map((item) => SkillModel.fromJson(item))
              .toList() ??
          [],
      isActive: json['isActive'],
      deskripsi: json['deskripsi'],
      jabatan: json['jabatan'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "idUser": idUser,
      "idUserOrganization": idUserOrganization,
      "organization": organization.toJson(),
      "skill": skill,
      "isActive": isActive,
      "deskripsi": deskripsi,
      "jabatan": jabatan,
      "startDate": startDate.toIso8601String(),
      "endDate": endDate?.toIso8601String(),
    };
  }
}
