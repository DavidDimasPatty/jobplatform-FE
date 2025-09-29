import 'package:job_platform/features/components/profile/data/models/skillModel.dart';

class SkillMV {
  String id;
  String? source;
  String? idSource;
  SkillModel skill;

  SkillMV(
    this.id,
    this.source,
    this.idSource,
    this.skill,
  );

  factory SkillMV.fromJson(Map<String, dynamic> json) {
    return SkillMV(
      json['userSkill']['_id'] as String,
      json['userSkill']['source'] as String,
      json['userSkill']['idSource'] as String,
      SkillModel.fromJson(json['skill'])
    );
  }
}
