import 'package:job_platform/features/components/profile/data/models/skillModel.dart';
import 'package:job_platform/features/components/profile/data/models/workExperienceModel.dart';

class WorkexperienceMV {
  String id;
  String idUser;
  String idExperience;
  WorkExperienceModel experience;
  List<SkillModel> skill;
  String? namaJabatan;
  String? deskripsi;
  String? bidang;
  String? sistemKerja;
  String? tipeKaryawan;
  DateTime? startDate;
  DateTime? endDate;

  WorkexperienceMV(
    this.id,
    this.idUser,
    this.idExperience,
    this.experience,
    this.skill,
    this.namaJabatan,
    this.deskripsi,
    this.bidang,
    this.sistemKerja,
    this.tipeKaryawan,
    this.startDate,
    this.endDate,
  );

  factory WorkexperienceMV.fromJson(Map<String, dynamic> json) {
    return WorkexperienceMV(
      json['userExperience']['_id'],
      json['userExperience']['idUser'],
      json['userExperience']['idExperience'],
      WorkExperienceModel.fromJson(json['experience']),
      (json['userExperience']['skill'] as List<dynamic>?)
              ?.map((item) => SkillModel.fromJson(item['skill']))
              .toList() ??
          [],
      json['userExperience']['namaJabatan'],
      json['userExperience']['deskripsi'],
      json['userExperience']['bidang'],
      json['userExperience']['sistemKerja'],
      json['userExperience']['tipeKaryawan'],
      json['userExperience']['startDate'] != null ? DateTime.parse(json['userExperience']['startDate']) : null,
      json['userExperience']['endDate'] != null ? DateTime.parse(json['userExperience']['endDate']) : null,
    );
  }
}
