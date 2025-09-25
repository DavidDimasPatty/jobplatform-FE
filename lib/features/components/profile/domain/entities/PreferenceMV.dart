class PreferenceMV {
  String id;
  String idUser;
  String? lokasi;
  String? posisi;
  String? levelJabatan;
  int? gajiMin;
  int? gajiMax;
  String? tipePekerjaan;
  String? sistemKerja;
  DateTime? dateWork;

  PreferenceMV(
    this.id,
    this.idUser,
    this.lokasi,
    this.posisi,
    this.levelJabatan,
    this.gajiMin,
    this.gajiMax,
    this.tipePekerjaan,
    this.sistemKerja,
    this.dateWork,
  );

  factory PreferenceMV.fromJson(Map<String, dynamic> json) {
    return PreferenceMV(
      json['_id'] as String,
      json['idUser'] as String,
      json['lokasi'] as String?,
      json['posisi'] as String?,
      json['levelJabatan'] as String?,
      json['gajiMin'] as int?,
      json['gajiMax'] as int?,
      json['tipePekerjaan'] as String?,
      json['sistemKerja'] as String?,
      json['dateWork'] != null ? DateTime.parse(json['dateWork']) : null,
    );
  }
}
