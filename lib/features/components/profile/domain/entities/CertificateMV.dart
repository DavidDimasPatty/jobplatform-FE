class CertificateMV {
  String id;
  String? nama;
  String? publisher;
  DateTime? publishDate;
  DateTime? expiredDate;
  String? deskripsi;
  String? code;
  String? codeURL;

  CertificateMV(
    this.id,
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
      json['certificate']['nama'] as String?,
      json['certificate']['publisher'] as String?,
      json['userCertificate']['publishDate'] != null ? DateTime.parse(json['userCertificate']['publishDate']) : null,
      json['userCertificate']['expiredDate'] != null ? DateTime.parse(json['userCertificate']['expiredDate']) : null,
      json['userCertificate']['deskripsi'] as String?,
      json['userCertificate']['code'] as String?,
      json['userCertificate']['codeURL'] as String?,
    );
  }
}
