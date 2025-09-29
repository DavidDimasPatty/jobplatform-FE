import 'package:job_platform/features/components/profile/data/models/certificateModel.dart';
import 'package:job_platform/features/components/profile/data/models/skillModel.dart';

class CertificateMV {
  String id;
  String idUser;
  String idCertificate;
  CertificateModel certificate;
  List<SkillModel> skill;
  DateTime publishDate;
  DateTime? expiredDate;
  String? deskripsi;
  String? code;
  String? codeURL;

  CertificateMV(
    this.id,
    this.idUser,
    this.idCertificate,
    this.certificate,
    this.skill,
    this.publishDate,
    this.expiredDate,
    this.deskripsi,
    this.code,
    this.codeURL,
  );

  factory CertificateMV.fromJson(Map<String, dynamic> json) {
    return CertificateMV(
      json['userCertificate']['_id'] as String,
      json['userCertificate']['idUser'] as String,
      json['userCertificate']['idCertificate'] as String,
      CertificateModel.fromJson(json['certificate']),
      (json['userCertificate']['skill'] as List<dynamic>?)
              ?.map((item) => SkillModel.fromJson(item['skill']))
              .toList() ??
          [],
      DateTime.parse(json['userCertificate']['publishDate']),
      json['userCertificate']['expiredDate'] != null
          ? DateTime.parse(json['userCertificate']['expiredDate'])
          : null,
      json['userCertificate']['deskripsi'] as String?,
      json['userCertificate']['code'] as String?,
      json['userCertificate']['codeURL'] as String?,
    );
  }
}
