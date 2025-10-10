class VacancyData {
  String id;
  String idCompany;
  String? lokasi;
  String? namaPosisi;
  String? jabatan;
  int? gajiMin;
  int? gajiMax;
  String? tipeKerja;
  String? sistemKerja;

  VacancyData(
    this.id,
    this.idCompany,
    this.lokasi,
    this.namaPosisi,
    this.jabatan,
    this.gajiMin,
    this.gajiMax,
    this.tipeKerja,
    this.sistemKerja,
  );

  factory VacancyData.fromJson(Map<String, dynamic> json) {
    return VacancyData(
      json['_id'] as String,
      json['idCompany'] as String,
      json['lokasi'] as String?,
      json['namaPosisi'] as String?,
      json['jabatan'] as String?,
      json['gajiMin'] as int?,
      json['gajiMax'] as int?,
      json['tipeKerja'] as String?,
      json['sistemKerja'] as String?,
    );
  }
}
