class WorkExperienceModel {
  String? idExperience;
  String namaPerusahaan;
  String industri;
  String lokasi;

  WorkExperienceModel({
    this.idExperience,
    required this.namaPerusahaan,
    required this.industri,
    required this.lokasi,
  });

  factory WorkExperienceModel.fromJson(Map<String, dynamic> json) {
    return WorkExperienceModel(
      idExperience: json['_id'],
      namaPerusahaan: json['namaPerusahaan'],
      industri: json['industri'],
      lokasi: json['lokasi'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "idExperience": idExperience,
      "namaPerusahaan": namaPerusahaan,
      "industri": industri,
      "lokasi": lokasi,
    };
  }
}
