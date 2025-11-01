import 'package:job_platform/features/components/profile/data/models/skillModel.dart';
import 'package:job_platform/features/components/statusJob/data/models/StatusVacancy.dart';
import 'package:job_platform/features/components/statusJob/data/models/UserVacancies.dart';

class StatusDetailVM {
  final String? namaPerusahaan;
  final String? logoPerusahaan;
  final String? lokasiPerusahaan;
  final String? bidangPerusahaan;
  final double? gajiMin;
  final double? gajiMax;
  final String? namaPosisi;
  final String? tipePekerjaan;
  final String? sistemKerja;
  final String? lokasiKerja;
  final String? jabatan;
  final List<String>? benefit;
  final List<StatusVacancy>? userStatus;
  final UserVacancies? userVacancy;
  final int? minExperience;
  final List<SkillModel>? skill;
  final double? gajiMinNego;
  final double? gajiMaxNego;
  final String? tipePekerjaanNego;
  final String? sistemKerjaNego;
  final DateTime? updTime;
  final String? updId;
  StatusDetailVM({
    this.namaPerusahaan,
    this.logoPerusahaan,
    this.lokasiPerusahaan,
    this.bidangPerusahaan,
    this.gajiMin,
    this.gajiMax,
    this.namaPosisi,
    this.tipePekerjaan,
    this.sistemKerja,
    this.lokasiKerja,
    this.jabatan,
    this.benefit,
    this.userStatus,
    this.userVacancy,
    this.minExperience,
    this.skill,
    this.gajiMaxNego,
    this.gajiMinNego,
    this.tipePekerjaanNego,
    this.sistemKerjaNego,
    this.updTime,
    this.updId,
  });
}
