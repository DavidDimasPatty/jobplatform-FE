class SkillMV {
  String id;
  String? nama;
  String? tingkat;
  String? status;

  SkillMV(
    this.id,
    this.nama,
    this.tingkat,
    this.status,
  );

  factory SkillMV.fromJson(Map<String, dynamic> json) {
    return SkillMV(
      json['userSkill']['_id'] as String,
      json['skill']['nama'] as String?,
      json['userSkill']['tingkat'] as String?,
      json['skill']['status'] as String?,
    );
  }
}
