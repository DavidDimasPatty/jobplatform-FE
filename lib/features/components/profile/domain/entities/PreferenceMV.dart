class PreferenceMV {
  String id;
  String? lokasi;
  String? industri;
  String? levelJabatan;
  int? gajiMin;
  int? gajiMax;
  String? tipePekerjaan;
  DateTime? dateWork;

  PreferenceMV(
    this.id,
    this.lokasi,
    this.industri,
    this.levelJabatan,
    this.gajiMin,
    this.gajiMax,
    this.tipePekerjaan,
    this.dateWork,
  );

  factory PreferenceMV.fromJson(Map<String, dynamic> json) {
    return PreferenceMV(
      json['userPreference']['_id'] as String,
      json['preference']['lokasi'] as String?,
      json['preference']['industri'] as String?,
      json['preference']['levelJabatan'] as String?,
      json['preference']['gajiMin'] as int?,
      json['preference']['gajiMax'] as int?,
      json['preference']['tipePekerjaan'] as String?,
      json['preference']['dateWork'] != null ? DateTime.parse(json['preference']['dateWork']) : null,
    );
  }
}
