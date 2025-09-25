class EducationMV {
  String id;
  String idUser;
  String idEducation;
  String? nama;
  String? lokasi;
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
    this.nama,
    this.lokasi,
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
      json['education']['nama'],
      json['education']['lokasi'],
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
