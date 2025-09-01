class KotaModel {
  final String id;
  final String nama;

  KotaModel({required this.id, required this.nama});

  factory KotaModel.fromJson(Map<String, dynamic> json) {
    return KotaModel(id: json["id"], nama: json["name"]);
  }
}
