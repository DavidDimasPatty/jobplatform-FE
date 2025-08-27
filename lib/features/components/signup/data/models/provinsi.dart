class ProvinsiModel {
  final String code;
  final String nama;

  ProvinsiModel({required this.code, required this.nama});

  factory ProvinsiModel.fromJson(Map<String, dynamic> json) {
    return ProvinsiModel(code: json["code"], nama: json["name"]);
  }
}
