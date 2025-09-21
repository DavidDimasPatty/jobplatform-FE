class SkillModel {
  final String idSkill;
  final String nama;
  final String tingkat;

  SkillModel({
    required this.idSkill,
    required this.nama,
    required this.tingkat,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      idSkill: json['idSkill'],
      nama: json['nama'],
      tingkat: json['tingkat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idSkill': idSkill,
      'nama': nama,
      'tingkat': tingkat,
    };
  }
}