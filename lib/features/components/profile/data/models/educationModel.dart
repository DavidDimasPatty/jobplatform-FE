class EducationModel {
  String? idEducation;
  String nama;
  String lokasi;

  EducationModel({
    this.idEducation,
    required this.nama,
    required this.lokasi,
  });

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      idEducation: json['idEducation'],
      nama: json['nama'],
      lokasi: json['lokasi'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'idEducation': idEducation, 'nama': nama, 'lokasi': lokasi};
  }
}
