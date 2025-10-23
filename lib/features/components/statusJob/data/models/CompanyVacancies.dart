class CompanyVacancies {
  final String? id;
  final String? idCompany;
  final String? namaPosisi;
  final double? gajiMin;
  final double? gajiMax;
  final String? sistemKerja;
  final String? tipeKerja;
  final String? jabatan;
  final String? lokasi;
  final DateTime? addTime;
  final DateTime? updTime;

  CompanyVacancies({
    this.id,
    this.idCompany,
    this.namaPosisi,
    this.gajiMin,
    this.gajiMax,
    this.sistemKerja,
    this.tipeKerja,
    this.jabatan,
    this.lokasi,
    this.addTime,
    this.updTime,
  });

  factory CompanyVacancies.fromJson(Map<String, dynamic> json) {
    return CompanyVacancies(
      id: json["id"] ?? null,
      idCompany: json["idCompany"] ?? null,
      namaPosisi: json["namaPosisi"] ?? null,
      gajiMin: json["gajiMin"] != null ? double.parse(json["gajiMin"]) : null,
      gajiMax: json["gajiMax"] != null ? double.parse(json["gajiMax"]) : null,
      sistemKerja: json["sistemKerja"] ?? null,
      tipeKerja: json["tipeKerja"] ?? null,
      jabatan: json["jabatan"] ?? null,
      lokasi: json["lokasi"] ?? null,
      addTime: json["addTime"] != null ? DateTime.parse(json["addTime"]) : null,
      updTime: json["updTime"] != null ? DateTime.parse(json["updTime"]) : null,
    );
  }
}
