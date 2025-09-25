class WorkexperienceMV {
  String id;
  String idUser;
  String idExperience;
  String? namaPerusahaan;
  String? industri;
  String? lokasi;
  String? namaJabatan;
  String? deskripsi;
  String? bidang;
  String? sistemKerja;
  String? tipeKaryawan;
  DateTime? startDate;
  DateTime? endDate;

  WorkexperienceMV(
    this.id,
    this.idUser,
    this.idExperience,
    this.namaPerusahaan,
    this.industri,
    this.lokasi,
    this.namaJabatan,
    this.deskripsi,
    this.bidang,
    this.sistemKerja,
    this.tipeKaryawan,
    this.startDate,
    this.endDate,
  );

  factory WorkexperienceMV.fromJson(Map<String, dynamic> json) {
    return WorkexperienceMV(
      json['userExperience']['_id'],
      json['userExperience']['idUser'],
      json['userExperience']['idExperience'],
      json['experience']['namaPerusahaan'],
      json['experience']['industri'],
      json['experience']['lokasi'],
      json['userExperience']['namaJabatan'],
      json['userExperience']['deskripsi'],
      json['userExperience']['bidang'],
      json['userExperience']['sistemKerja'],
      json['userExperience']['tipeKaryawan'],
      json['userExperience']['startDate'] != null ? DateTime.parse(json['userExperience']['startDate']) : null,
      json['userExperience']['endDate'] != null ? DateTime.parse(json['userExperience']['endDate']) : null,
    );
  }
}
