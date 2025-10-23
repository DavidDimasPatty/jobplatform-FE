class EducationProgressModel {
  String? idEducation;
  String? nama;
  String? lokasi;
  bool? isActive;
  String? gpa;
  String? penjurusan;
  DateTime? startDate;
  DateTime? endDate;
  String? tingkat;

  EducationProgressModel({
    this.idEducation,
    this.nama,
    this.lokasi,
    this.isActive,
    this.gpa,
    this.penjurusan,
    this.startDate,
    this.endDate,
    this.tingkat,
  });

  factory EducationProgressModel.fromJson(Map<String, dynamic> json) {
    return EducationProgressModel(
      idEducation: json['education'] != null
          ? json['education']['_id'] ?? null
          : null,
      nama: json['education'] != null
          ? json['education']['nama'] ?? null
          : null,
      lokasi: json['education'] != null
          ? json['education']['lokasi'] ?? null
          : null,
      gpa: json['userEducation'] != null
          ? json['userEducation']['gpa'] ?? null
          : null,
      endDate: json['userEducation'] != null
          ? DateTime.tryParse(json['userEducation']['endDate']) ?? null
          : null,
      isActive: json['userEducation'] != null
          ? bool.tryParse(json['userEducation']['isActive']) ?? null
          : null,
      penjurusan: json['userEducation'] != null
          ? json['userEducation']['penjurusan'] ?? null
          : null,
      startDate: json['userEducation'] != null
          ? DateTime.tryParse(json['userEducation']['startDate']) ?? null
          : null,
      tingkat: json['userEducation'] != null
          ? json['userEducation']['tingkat'] ?? null
          : null,
    );
  }
}
