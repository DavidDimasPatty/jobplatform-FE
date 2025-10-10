class VacancyRequest {
  String idCompany;
  String? idCompanyVacancy;
  String? lokasi;
  String? namaPosisi;
  String? jabatan;
  int? gajiMin;
  int? gajiMax;
  String? tipeKerja;
  String? sistemKerja;

  VacancyRequest({
    required this.idCompany,
    this.idCompanyVacancy,
    this.gajiMin,
    this.gajiMax,
    this.namaPosisi,
    this.tipeKerja,
    this.sistemKerja,
    this.lokasi,
    this.jabatan,
  });

  factory VacancyRequest.fromJson(Map<String, dynamic> json) {
    return VacancyRequest(
      idCompany: json['idCompany'],
      idCompanyVacancy: json['idCompanyVacancy'],
      gajiMin: json['gajiMin'],
      gajiMax: json['gajiMax'],
      namaPosisi: json['namaPosisi'],
      tipeKerja: json['tipeKerja'],
      sistemKerja: json['sistemKerja'],
      lokasi: json['lokasi'],
      jabatan: json['jabatan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "idCompany": idCompany,
      "idCompanyVacancy": idCompanyVacancy,
      "gajiMin": gajiMin,
      "gajiMax": gajiMax,
      "namaPosisi": namaPosisi,
      "tipeKerja": tipeKerja,
      "sistemKerja": sistemKerja,
      "lokasi": lokasi,
      "jabatan": jabatan,
    };
  }
}
