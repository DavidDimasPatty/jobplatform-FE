class CandidateItems {
  String? id;
  String? nama;
  String? photoUrl;
  String? score;
  String? umur;
  String? domisili;

  CandidateItems({
    this.id,
    this.nama,
    this.photoUrl,
    this.score,
    this.domisili,
    this.umur,
  });

  // factory CertificateMV.fromJson(Map<String, dynamic> json) {
  //   return CertificateMV(
  //     json['userCertificate']['_id'] as String,
  //     json['certificate']['nama'] as String?,
  //     json['certificate']['publisher'] as String?,
  //     json['userCertificate']['publishDate'] != null ? DateTime.parse(json['userCertificate']['publishDate']) : null,
  //     json['userCertificate']['expiredDate'] != null ? DateTime.parse(json['userCertificate']['expiredDate']) : null,
  //     json['userCertificate']['deskripsi'] as String?,
  //     json['userCertificate']['code'] as String?,
  //     json['userCertificate']['codeURL'] as String?,
  //   );
  // }
}
