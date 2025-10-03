import 'package:job_platform/features/components/profile/data/models/skillModel.dart';

class SkillRequest {
  final String idUser;
  final List<SkillModel>? skill;

  SkillRequest({required this.idUser, this.skill});

  Map<String, dynamic> toJson() {
    return {'idUser': idUser, 'skill': skill};
  }
}
