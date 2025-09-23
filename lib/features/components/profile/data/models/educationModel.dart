import 'package:job_platform/features/components/profile/data/models/skillModel.dart';

class EducationModel {
  String idUser;
  String? idUserEducation;
  String? idEducation;
  String nama;
  String lokasi;
  List<SkillModel> skill;
  bool isActive;
  String penjurusan;
  String tingkat;
  String gpa;
  String? deskripsi;
  DateTime startDate;
  DateTime endDate;

  EducationModel({
    required this.idUser,
    this.idUserEducation,
    this.idEducation,
    required this.nama,
    required this.lokasi,
    required this.skill,
    this.isActive = true,
    required this.penjurusan,
    required this.tingkat,
    this.gpa = '0.0',
    this.deskripsi,
    required this.startDate,
    required this.endDate,
  });

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      idUser: json['idUser'],
      idUserEducation: json['idUserEducation'],
      idEducation: json['education'] != null ? json['education']['idEducation'] : null,
      nama: json['nama'],
      lokasi: json['lokasi'],
      skill:
          (json['skill'] as List<dynamic>?)
              ?.map((item) => SkillModel.fromJson(item))
              .toList() ??
          [],
      isActive: json['isActive'] ?? true,
      gpa: json['gpa'] ?? '0.0',
      penjurusan: json['penjurusan'] ?? '',
      tingkat: json['tingkat'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      startDate: DateTime.parse(json['startDate'] ?? ''),
      endDate: DateTime.parse(json['endDate'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUser': idUser,
      'idUserEducation': idUserEducation,
      'education': {
        'idEducation': idEducation,
        'nama': nama,
        'lokasi': lokasi,
      },
      'skill': skill,
      'isActive': isActive,
      'penjurusan': penjurusan,
      'tingkat': tingkat,
      'gpa': gpa,
      'deskripsi': deskripsi,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }
}
