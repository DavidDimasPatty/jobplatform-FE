import 'package:job_platform/features/components/profile/data/models/skillModel.dart';

class WorkExperienceRequest {
  String idUser;
  String? idUserExperience;
  String? idExperience;
  String namaPerusahaan;
  String industri;
  String lokasi;
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
    this.idExperience,
    required this.namaPerusahaan,
    required this.industri,
    required this.lokasi,
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
      namaPerusahaan: json['namaPerusahaan'],
      industri: json['industri'],
      lokasi: json['lokasi'],
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
      "experience": {
        "idExperience": idExperience,
        "namaPerusahaan": namaPerusahaan,
        "industri": industri,
        "lokasi": lokasi,
      },
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
