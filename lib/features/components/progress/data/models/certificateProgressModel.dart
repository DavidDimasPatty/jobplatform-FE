class CertificateProgressModel {
  String? idCertificate;
  String? nama;
  String? publisher;
  String? codeURL;
  String? code;
  DateTime? publishDate;
  DateTime? expiredDate;

  CertificateProgressModel({
    this.idCertificate,
    this.nama,
    this.publisher,
    this.code,
    this.codeURL,
    this.publishDate,
    this.expiredDate,
  });

  factory CertificateProgressModel.fromJson(Map<String, dynamic> json) {
    return CertificateProgressModel(
      idCertificate: json['certificate'] != null
          ? json['certificate']['id'] ?? null
          : null,
      nama: json['certificate'] != null
          ? json['certificate']['nama'] ?? null
          : null,
      publisher: json['certificate'] != null
          ? json['certificate']['publisher'] ?? null
          : null,
      code: json['userCertificate'] != null
          ? json['userCertificate']['code'] ?? null
          : null,
      codeURL: json['userCertificate'] != null
          ? json['userCertificate']['codeURL'] ?? null
          : null,
      expiredDate: json['userCertificate'] != null
          ? DateTime.tryParse(json['userCertificate']['expiredDate']) ?? null
          : null,
      publishDate: json['userCertificate'] != null
          ? DateTime.tryParse(json['userCertificate']['publishDate']) ?? null
          : null,
    );
  }
}
