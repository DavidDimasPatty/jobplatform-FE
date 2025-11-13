class ProsesPerekrutan {
  final int? rekrutDiterima;
  final int? rekrutDitolak;
  final int? rekrutBerhasil;
  final int? rekrutPending;
  ProsesPerekrutan({
    this.rekrutDiterima,
    this.rekrutDitolak,
    this.rekrutBerhasil,
    this.rekrutPending,
  });

  factory ProsesPerekrutan.fromJson(Map<String, dynamic> json) {
    return ProsesPerekrutan(
      rekrutDitolak: json["rekrutDitolak"] != null
          ? int.parse(json["rekrutDitolak"].toString())
          : null,
      rekrutDiterima: json["rekrutDiterima"] != null
          ? int.parse(json["rekrutDiterima"].toString())
          : null,
      rekrutBerhasil: json["rekrutBerhasil"] != null
          ? int.parse(json["rekrutBerhasil"].toString())
          : null,
      rekrutPending: json["rekrutPending"] != null
          ? int.parse(json["rekrutPending"].toString())
          : null,
    );
  }
}
