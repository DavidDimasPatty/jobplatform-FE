class SkillModel {
  final String? idSkill;
  final String nama;

  SkillModel({this.idSkill, required this.nama});

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(idSkill: json['idSkill'], nama: json['nama']);
  }

  Map<String, dynamic> toJson() {
    return {'idSkill': idSkill, 'nama': nama};
  }
}
