import 'package:job_platform/features/components/statusJob/data/models/Companies.dart';
import 'package:job_platform/features/components/statusJob/data/models/CompanyVacancies.dart';
import 'package:job_platform/features/components/statusJob/data/models/StatusVacancy.dart';
import 'package:job_platform/features/components/statusJob/data/models/UserVacancies.dart';

class AllStatusModel {
  final CompanyVacancies? vacancy;
  final Companies? company;
  final UserVacancies? userVacancy;
  final List<StatusVacancy>? status;

  AllStatusModel({this.vacancy, this.company, this.userVacancy, this.status});

  factory AllStatusModel.fromJson(Map<String, dynamic> json) {
    return AllStatusModel(
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
