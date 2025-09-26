class CertificateModel {
  String? idCertificate;
  String nama;
  String publisher;

  CertificateModel({
    this.idCertificate,
    required this.nama,
    required this.publisher,
  });

  factory CertificateModel.fromJson(Map<String, dynamic> json) {
    return CertificateModel(
      idCertificate: json['_id'],
      nama: json['nama'],
      publisher: json['publisher'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idCertificate': idCertificate,
      'nama': nama,
      'publisher': publisher,
    };
  }
}
