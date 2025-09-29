import 'package:job_platform/features/components/profile/data/models/certificateModel.dart';
import 'package:job_platform/features/components/profile/data/models/skillModel.dart';

class CertificateRequest {
  String idUser;
  String? idUserCertificate;
  CertificateModel certificate;
  List<SkillModel> skill;
  String code;
  String codeURL;
  String? deskripsi;
  DateTime publishDate;
  DateTime? expiredDate;

  CertificateRequest({
    required this.idUser,
    this.idUserCertificate,
    required this.certificate,
    required this.skill,
    required this.code,
    required this.codeURL,
    this.deskripsi,
    required this.publishDate,
    this.expiredDate,
  });

  factory CertificateRequest.fromJson(Map<String, dynamic> json) {
    return CertificateRequest(
      idUser: json['idUser'],
      idUserCertificate: json['idUserCertificate'],
      certificate: CertificateModel.fromJson(json['certificate']),
      skill:
          (json['skill'] as List<dynamic>?)
              ?.map((item) => SkillModel.fromJson(item))
              .toList() ??
          [],
      code: json['code'],
      codeURL: json['codeURL'],
      deskripsi: json['deskripsi'],
      publishDate: DateTime.parse(json['publishDate']),
      expiredDate: DateTime.parse(json['expiredDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUser': idUser,
      'idUserCertificate': idUserCertificate,
      'certificate': certificate.toJson(),
      'skill': skill,
      'code': code,
      'codeURL': codeURL,
      'deskripsi': deskripsi,
      'publishDate': publishDate.toIso8601String(),
      'expiredDate': expiredDate?.toIso8601String(),
    };
  }
}
