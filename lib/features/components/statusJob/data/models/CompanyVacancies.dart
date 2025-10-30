import 'package:job_platform/features/components/profile/data/models/skillModel.dart';

class CompanyVacancies {
  final String? id;
  final String? idCompany;
  final String? namaPosisi;
  final double? gajiMin;
  final double? gajiMax;
  final String? sistemKerja;
  final String? tipeKerja;
  final String? jabatan;
  final String? lokasi;
  final DateTime? addTime;
  final DateTime? updTime;
  final List<SkillModel>? skill;
  final int? minExperience;

  CompanyVacancies({
    this.id,
    this.idCompany,
    this.namaPosisi,
    this.gajiMin,
    this.gajiMax,
    this.sistemKerja,
    this.tipeKerja,
    this.jabatan,
    this.lokasi,
    this.addTime,
    this.updTime,
    this.skill,
    this.minExperience,
  });

  factory CompanyVacancies.fromJson(Map<String, dynamic> json) {
    return CompanyVacancies(
      id: json["_id"] ?? null,
      idCompany: json["idCompany"] ?? null,
      namaPosisi: json["namaPosisi"] ?? null,
      gajiMin: json["gajiMin"] != null
          ? double.parse(json["gajiMin"].toString())
          : null,
      gajiMax: json["gajiMax"] != null
          ? double.parse(json["gajiMax"].toString())
          : null,
      sistemKerja: json["sistemKerja"] ?? null,
      tipeKerja: json["tipeKerja"] ?? null,
      jabatan: json["jabatan"] ?? null,
      lokasi: json["lokasi"] ?? null,
      addTime: json["addTime"] != null ? DateTime.parse(json["addTime"]) : null,
      updTime: json["updTime"] != null ? DateTime.parse(json["updTime"]) : null,
      skill: json["skills"] != null
          ? List<SkillModel>.from(
              json["skills"].map((x) => SkillModel.fromJson(x)),
            )
          : null,
      minExperience: json["minExperience"] != null
          ? int.tryParse(json["minExperience"].toString())
          : 0,
    );
  }
}
