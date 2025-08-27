class KotaModel {
  final String code;
  final String nama;

  KotaModel({required this.code, required this.nama});

  factory KotaModel.fromJson(Map<String, dynamic> json) {
    return KotaModel(code: json["code"], nama: json["name"]);
  }
}
