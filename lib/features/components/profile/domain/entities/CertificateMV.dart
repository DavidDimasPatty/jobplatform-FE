class CertificateMV {
  String id;
  String idUser;
  String idCertificate;
  String nama;
  String publisher;
  DateTime publishDate;
  DateTime? expiredDate;
  String? deskripsi;
  String? code;
  String? codeURL;

  CertificateMV(
    this.id,
    this.idUser,
    this.idCertificate,
    this.nama,
    this.publisher,
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
      json['certificate']['nama'] as String,
      json['certificate']['publisher'] as String,
      DateTime.parse(json['userCertificate']['publishDate']),
      json['userCertificate']['expiredDate'] != null ? DateTime.parse(json['userCertificate']['expiredDate']) : null,
      json['userCertificate']['deskripsi'] as String?,
      json['userCertificate']['code'] as String?,
      json['userCertificate']['codeURL'] as String?,
    );
  }
}
