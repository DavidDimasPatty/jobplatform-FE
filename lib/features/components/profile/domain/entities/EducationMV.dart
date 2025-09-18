class EducationMV {
  String id;
  String? nama;
  String? tingkat;
  DateTime? startDate;
  DateTime? endDate;
  String? deskripsi;
  String? penjurusan;
  String? gpa;

  EducationMV(
    this.id,
    this.nama,
    this.tingkat,
    this.startDate,
    this.endDate,
    this.deskripsi,
    this.penjurusan,
    this.gpa,
  );

  factory EducationMV.fromJson(Map<String, dynamic> json) {
    return EducationMV(
      json['userEducation']['_id'],
      json['education']['nama'],
      json['userEducation']['tingkat'],
      json['userEducation']['startDate'] != null ? DateTime.parse(json['userEducation']['startDate']) : null,
      json['userEducation']['endDate'] != null ? DateTime.parse(json['userEducation']['endDate']) : null,
      json['userEducation']['deskripsi'],
      json['userEducation']['penjurusan'],
      json['userEducation']['gpa'],
    );
  }
}
