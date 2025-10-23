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
  });
}
