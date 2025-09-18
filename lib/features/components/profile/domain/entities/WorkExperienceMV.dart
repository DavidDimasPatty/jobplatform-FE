class WorkexperienceMV {
  String id;
  String? namaPerusahaan;
  String? namaJabatan;
  DateTime? startDate;
  DateTime? endDate;
  String? deskripsi;
  String? bidang;
  String? industri;
  String? lokasi;
  String? sistemKerja;
  String? tipeKaryawan;

  WorkexperienceMV(
    this.id,
    this.namaPerusahaan,
    this.namaJabatan,
    this.startDate,
    this.endDate,
    this.deskripsi,
    this.bidang,
    this.industri,
    this.lokasi,
    this.sistemKerja,
    this.tipeKaryawan,
  );

  factory WorkexperienceMV.fromJson(Map<String, dynamic> json) {
    return WorkexperienceMV(
      json['userExperience']['_id'],
      json['experience']['namaPerusahaan'],
      json['userExperience']['namaJabatan'],
      json['userExperience']['startDate'] != null ? DateTime.parse(json['userExperience']['startDate']) : null,
      json['userExperience']['endDate'] != null ? DateTime.parse(json['userExperience']['endDate']) : null,
      json['userExperience']['deskripsi'],
      json['userExperience']['bidang'],
      json['experience']['industri'],
      json['experience']['lokasi'],
      json['userExperience']['sistemKerja'],
      json['userExperience']['tipeKaryawan'],
    );
  }
}
