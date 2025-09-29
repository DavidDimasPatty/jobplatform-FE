import 'package:job_platform/features/components/profile/data/models/skillModel.dart';
import 'package:job_platform/features/components/profile/data/models/workExperienceModel.dart';

class WorkExperienceRequest {
  String idUser;
  String? idUserExperience;
  WorkExperienceModel experience;
  List<SkillModel> skill;
  bool isActive;
  String bidang;
  String? deskripsi;
  String namaJabatan;
  String sistemKerja;
  String tipeKaryawan;
  DateTime startDate;
  DateTime? endDate;

  WorkExperienceRequest({
    required this.idUser,
    this.idUserExperience,
    required this.experience,
    required this.skill,
    this.isActive = true,
    required this.bidang,
    this.deskripsi,
    required this.namaJabatan,
    required this.sistemKerja,
    required this.tipeKaryawan,
    required this.startDate,
    this.endDate,
  });

  factory WorkExperienceRequest.fromJson(Map<String, dynamic> json) {
    return WorkExperienceRequest(
      idUser: json['idUser'],
      idUserExperience: json['idUserExperience'],
      experience: WorkExperienceModel.fromJson(json['experience']),
      skill:
          (json['skill'] as List<dynamic>?)
              ?.map((item) => SkillModel.fromJson(item))
              .toList() ??
          [],
      isActive: json['isActive'],
      bidang: json['bidang'],
      deskripsi: json['deskripsi'],
      namaJabatan: json['namaJabatan'],
      sistemKerja: json['sistemKerja'],
      tipeKaryawan: json['tipeKaryawan'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "idUser": idUser,
      "idUserExperience": idUserExperience,
      "experience": experience.toJson(),
      "skill": skill,
      "isActive": isActive,
      "bidang": bidang,
      "deskripsi": deskripsi,
      "namaJabatan": namaJabatan,
      "sistemKerja": sistemKerja,
      "tipeKaryawan": tipeKaryawan,
      "startDate": startDate.toIso8601String(),
      "endDate": endDate?.toIso8601String(),
    };
  }
}
