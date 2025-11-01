class WorkExperienceProgressModel {
  String? idExperience;
  String? namaPerusahaan;
  String? industri;
  String? lokasi;
  bool? isActive;
  String? namaJabatan;
  DateTime? startDate;
  DateTime? endDate;
  String? tipeKaryawan;
  String? bidang;

  WorkExperienceProgressModel({
    this.idExperience,
    this.namaPerusahaan,
    this.industri,
    this.lokasi,
    this.isActive,
    this.namaJabatan,
    this.startDate,
    this.endDate,
    this.tipeKaryawan,
    this.bidang,
  });

  factory WorkExperienceProgressModel.fromJson(Map<String, dynamic> json) {
    return WorkExperienceProgressModel(
      idExperience: json['experience'] != null
          ? json["experience"]["_id"] ?? null
          : null,
      namaPerusahaan: json['experience'] != null
          ? json["experience"]["namaPerusahaan"] ?? null
          : null,
      bidang: json['userExperience'] != null
          ? json["userExperience"]["bidang"] ?? null
          : null,
      industri: json['experience'] != null
          ? json["experience"]["industri"] ?? null
          : null,
      endDate: json['userExperience'] != null
          ? json["userExperience"]["endDate"] != null
                ? DateTime.tryParse(json["userExperience"]["endDate"]) ?? null
                : null
          : null,
      isActive: json['userExperience'] != null
          ? json["userExperience"]["isActive"] != null
                ? bool.tryParse(json['userExperience']["isActive"].toString())
                : null
          : null,
      lokasi: json['experience'] != null
          ? json["experience"]["lokasi"] ?? null
          : null,
      namaJabatan: json['userExperience'] != null
          ? json["userExperience"]["namaJabatan"] ?? null
          : null,
      startDate: json['userExperience'] != null
          ? DateTime.tryParse(json["userExperience"]["startDate"]) ?? null
          : null,
      tipeKaryawan: json['userExperience'] != null
          ? json["userExperience"]["tipeKaryawan"] ?? null
          : null,
    );
  }
}
