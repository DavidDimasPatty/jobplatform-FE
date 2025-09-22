import 'package:job_platform/features/components/profile/data/models/skillModel.dart';

class CertificateModel {
  String idUser;
  String? idUserCertificate;
  String? idCertificate;
  String nama;
  String publisher;
  List<SkillModel> skill;
  String code;
  String codeURL;
  String? deskripsi;
  DateTime publishDate;
  DateTime expiredDate;

  CertificateModel({
    required this.idUser,
    this.idUserCertificate,
    this.idCertificate,
    required this.nama,
    required this.publisher,
    required this.skill,
    required this.code,
    required this.codeURL,
    this.deskripsi,
    required this.publishDate,
    required this.expiredDate,
  });

  factory CertificateModel.fromJson(Map<String, dynamic> json) {
    return CertificateModel(
      idUser: json['idUser'],
      nama: json['nama'],
      publisher: json['publisher'],
      skill:
          (json['skill'] as List<dynamic>?)
              ?.map((item) => SkillModel.fromJson(item))
              .toList() ??
          [],
      code: json['code'] ?? '',
      codeURL: json['codeURL'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      publishDate: DateTime.parse(json['publishDate'] ?? ''),
      expiredDate: DateTime.parse(json['expiredDate'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUser': idUser,
      'idUserCertificate': idUserCertificate,
      'certificate': {
        'idCertificate': idCertificate,
        'nama': nama,
        'publisher': publisher,
      },
      'skill': skill,
      'code': code,
      'codeURL': codeURL,
      'deskripsi': deskripsi,
      'publishDate': publishDate.toIso8601String(),
      'expiredDate': expiredDate.toIso8601String(),
    };
  }
}
