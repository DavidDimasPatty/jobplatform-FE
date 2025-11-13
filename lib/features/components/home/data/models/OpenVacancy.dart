class OpenVacancy {
  final String? namaPosisi;
  final String? jabatan;
  final String? tipeKerja;
  OpenVacancy({this.namaPosisi, this.jabatan, this.tipeKerja});

  factory OpenVacancy.fromJson(Map<String, dynamic> json) {
    return OpenVacancy(
      namaPosisi: json["namaPosisi"] ?? "",
      jabatan: json["jabatan"] ?? "",
      tipeKerja: json["tipeKerja"] ?? "",
    );
  }
}
