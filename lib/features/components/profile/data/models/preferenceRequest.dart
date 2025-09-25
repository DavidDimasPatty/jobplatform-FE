class PreferenceRequest {
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

  PreferenceRequest({
    required this.idUser,
    this.idPreference,
    this.gajiMin,
    this.gajiMax,
    this.posisi,
    this.tipePekerjaan,
    this.sistemKerja,
    this.lokasi,
    this.levelJabatan,
    this.dateWork
  });

  factory PreferenceRequest.fromJson(Map<String, dynamic> json) {
    return PreferenceRequest(
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

  Map<String, dynamic> toJson() {
    return {
      "idUser": idUser,
      "idPreference": idPreference,
      "gajiMin": gajiMin,
      "gajiMax": gajiMax,
      "posisi": posisi,
      "tipePekerjaan": tipePekerjaan,
      "sistemKerja": sistemKerja,
      "lokasi": lokasi,
      "levelJabatan": levelJabatan,
      "dateWork": dateWork?.toIso8601String(),
    };
  }
}
