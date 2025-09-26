import 'package:job_platform/features/components/profile/data/models/educationModel.dart';
import 'package:job_platform/features/components/profile/data/models/skillModel.dart';

class EducationMV {
  String id;
  String idUser;
  String idEducation;
  EducationModel education;
  List<SkillModel> skill;
  bool isActive;
  String penjurusan;
  String tingkat;
  String gpa;
  String? deskripsi;
  DateTime? startDate;
  DateTime? endDate;

  EducationMV(
    this.id,
    this.idUser,
    this.idEducation,
    this.education,
    this.skill,
    this.isActive,
    this.penjurusan,
    this.tingkat,
    this.gpa,
    this.deskripsi,
    this.startDate,
    this.endDate,
  );

  factory EducationMV.fromJson(Map<String, dynamic> json) {
    return EducationMV(
      json['userEducation']['_id'],
      json['userEducation']['idUser'],
      json['userEducation']['idEducation'],
      EducationModel.fromJson(json['education']),
      (json['userEducation']['skill'] as List<dynamic>?)
              ?.map((item) => SkillModel.fromJson(item['skill']))
              .toList() ??
          [],
      json['userEducation']['isActive'],
      json['userEducation']['penjurusan'],
      json['userEducation']['tingkat'],
      json['userEducation']['gpa'],
      json['userEducation']['deskripsi'],
      json['userEducation']['startDate'] != null ? DateTime.parse(json['userEducation']['startDate']) : null,
      json['userEducation']['endDate'] != null ? DateTime.parse(json['userEducation']['endDate']) : null,
    );
  }
}
