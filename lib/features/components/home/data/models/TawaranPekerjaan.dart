class TawaranPekerjaan {
  final String? id;
  final String? tipeKerja;
  final String? namaPosisi;
  final String? jabatan;
  final String? namaPerusahaan;
  final String? status;
  final String? urlPhoto;
  TawaranPekerjaan({
    this.id,
    this.tipeKerja,
    this.namaPosisi,
    this.jabatan,
    this.namaPerusahaan,
    this.status,
    this.urlPhoto,
  });

  factory TawaranPekerjaan.fromJson(Map<String, dynamic> json) {
    return TawaranPekerjaan(
      tipeKerja: json["tipeKerja"] ?? "",
      namaPosisi: json["namaPosisi"] ?? "",
      jabatan: json["jabatan"] ?? "",
      namaPerusahaan: json["namaPerusahaan"] ?? "",
      status: json["status"] ?? "",
      urlPhoto: json["urlPhoto"] ?? "",
    );
  }
}
