class PreferenceProgressModel {
  String idUser;
  String? idPreference;
  String? lokasi;
  int? gajiMin;
  int? gajiMax;
  String? levelJabatan;
  String? tipePekerjaan;
  DateTime? dateWork;
  String? posisi;
  String? sistemKerja;

  PreferenceProgressModel({
    required this.idUser,
    this.idPreference,
    this.gajiMin,
    this.gajiMax,
    this.posisi,
    this.tipePekerjaan,
    this.sistemKerja,
    this.lokasi,
    this.levelJabatan,
    this.dateWork,
  });

  factory PreferenceProgressModel.fromJson(Map<String, dynamic> json) {
    return PreferenceProgressModel(
      idUser: json['idUser'],
      idPreference: json['idPreference'],
      gajiMin: json['gajiMin'],
      gajiMax: json['gajiMax'],
      posisi: json['posisi'],
      tipePekerjaan: json['tipePekerjaan'],
      sistemKerja: json['sistemKerja'],
      lokasi: json['lokasi'],
      levelJabatan: json['levelJabatan'],
      dateWork: DateTime.parse(json['dateWork']),
    );
  }
}
