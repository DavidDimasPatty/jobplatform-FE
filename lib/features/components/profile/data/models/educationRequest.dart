import 'package:job_platform/features/components/profile/data/models/educationModel.dart';
import 'package:job_platform/features/components/profile/data/models/skillModel.dart';

class EducationRequest {
  String idUser;
  String? idUserEducation;
  EducationModel education;
  List<SkillModel> skill;
  bool isActive;
  String penjurusan;
  String tingkat;
  String gpa;
  String? deskripsi;
  DateTime startDate;
  DateTime? endDate;

  EducationRequest({
    required this.idUser,
    this.idUserEducation,
    required this.education,
    required this.skill,
    this.isActive = true,
    required this.penjurusan,
    required this.tingkat,
    this.gpa = '0.0',
    this.deskripsi,
    required this.startDate,
    this.endDate,
  });

  factory EducationRequest.fromJson(Map<String, dynamic> json) {
    return EducationRequest(
      idUser: json['idUser'],
      idUserEducation: json['idUserEducation'],
      education: EducationModel.fromJson(json['education']),
      skill:
          (json['skill'] as List<dynamic>?)
              ?.map((item) => SkillModel.fromJson(item))
              .toList() ??
          [],
      isActive: json['isActive'],
      gpa: json['gpa'],
      penjurusan: json['penjurusan'],
      tingkat: json['tingkat'],
      deskripsi: json['deskripsi'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUser': idUser,
      'idUserEducation': idUserEducation,
      'education': education.toJson(),
      'skill': skill,
      'isActive': isActive,
      'penjurusan': penjurusan,
      'tingkat': tingkat,
      'gpa': gpa,
      'deskripsi': deskripsi,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }
}
