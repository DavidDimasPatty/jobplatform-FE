import 'package:job_platform/features/components/profile/domain/entities/ProfileData.dart';
import 'package:job_platform/features/components/statusJob/data/models/CompanyVacancies.dart';
import 'package:job_platform/features/components/statusJob/data/models/StatusVacancy.dart';
import 'package:job_platform/features/components/statusJob/data/models/UserVacancies.dart';

class AllProgressModel {
  final Profiledata? dataUser;
  final CompanyVacancies? vacancy;
  final UserVacancies? userVacancy;
  final List<StatusVacancy>? status;

  AllProgressModel({
    this.dataUser,
    this.vacancy,
    this.userVacancy,
    this.status,
  });

  factory AllProgressModel.fromJson(Map<String, dynamic> json) {
    return AllProgressModel(
      vacancy: json["vacancy"] != null
          ? CompanyVacancies.fromJson(json["vacancy"])
          : null,
      dataUser: json["user"] != null
          ? Profiledata.fromJson(json["user"])
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

  // Map<String, dynamic> toJson() {
  //   return {
  //     "_id": id,
  //     "nama": nama,
  //     "alamat": alamat,
  //     "domain": domain,
  //     "addTime": addTime?.toIso8601String(),
  //     "updTime": updTime?.toIso8601String(),
  //     "noTelp": noTelp,
  //     "lastLogin": lastLogin?.toIso8601String(),
  //     "email": email,
  //     "statusAccount": statusAccount,
  //   };
  // }
}
