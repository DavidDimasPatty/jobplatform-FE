class SkillProgressModel {
  final String? idSkill;
  final String nama;

  SkillProgressModel({this.idSkill, required this.nama});

  factory SkillProgressModel.fromJson(Map<String, dynamic> json) {
    return SkillProgressModel(
      idSkill: json["skill"] != null ? json["skill"]['_id'] ?? null : null,
      nama: json["skill"] != null ? json["skill"]['nama'] ?? null : null,
    );
  }
}
