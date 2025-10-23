import 'package:job_platform/features/components/statusJob/data/models/Companies.dart';
import 'package:job_platform/features/components/statusJob/data/models/CompanyVacancies.dart';
import 'package:job_platform/features/components/statusJob/data/models/StatusVacancy.dart';
import 'package:job_platform/features/components/statusJob/data/models/UserVacancies.dart';

class DetailStatusModel {
  final CompanyVacancies? vacancy;
  final Companies? company;
  final UserVacancies? userVacancy;
  final List<StatusVacancy>? status;

  DetailStatusModel({
    this.vacancy,
    this.company,
    this.userVacancy,
    this.status,
  });

  factory DetailStatusModel.fromJson(Map<String, dynamic> json) {
    return DetailStatusModel(
      vacancy: json["vacancy"] != null
          ? CompanyVacancies.fromJson(json["vacancy"])
          : null,
      company: json["company"] != null
          ? Companies.fromJson(json["company"])
          : null,
      userVacancy: json["userVacancy"] != null
          ? UserVacancies.fromJson(json["userVacancy"])
          : null,
      status: json["status"] != null
          ? List<StatusVacancy>.from(
              json["status"].map((x) => StatusVacancy.fromJson(x)),
            )
          : null,
    );
  }
}
