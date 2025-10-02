class ProfileRequest {
  String idUser;
  String? nama;
  DateTime? tanggalLahir;
  String? tempatLahir;
  String? jenisKelamin;
  String? domisili;
  String? cv;
  String? headline;
  String? ringkasan;
  bool? visibility;
  int? seekStatus;
  String? linkPorto;

  ProfileRequest({
    required this.idUser,
    this.nama,
    this.tanggalLahir,
    this.tempatLahir,
    this.jenisKelamin,
    this.domisili,
    this.cv,
    this.headline,
    this.ringkasan,
    this.visibility,
    this.seekStatus,
    this.linkPorto
  });

  factory ProfileRequest.fromJson(Map<String, dynamic> json){
    return ProfileRequest(idUser: json['idUser']);
  }

  Map<String, dynamic> toJson() {
    return {
      "idUser": idUser,
      "nama": nama,
      "tanggalLahir": tanggalLahir?.toIso8601String(),
      "tempatLahir": tempatLahir,
      "jenisKelamin": jenisKelamin,
      "domisili": domisili,
      "cv": cv,
      "headline": headline,
      "ringkasan": ringkasan,
      "visibility": visibility,
      "seekStatus": seekStatus,
      "linkPorto": [linkPorto],
    };
  }
}
