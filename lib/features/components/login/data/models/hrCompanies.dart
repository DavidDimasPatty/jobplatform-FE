import 'package:job_platform/features/components/login/data/models/company.dart';

class HrCompanies {
  final UserCompany userCompany;
  final Company company;

  HrCompanies({required this.userCompany, required this.company});

  factory HrCompanies.fromJson(Map<String, dynamic> json) {
    return HrCompanies(
      userCompany: UserCompany.fromJson(json['userCompany']),
      company: Company.fromJson(json['company']),
    );
  }

  Map<String, dynamic> toJson() {
    return {"userCompany": userCompany.toJson(), "company": company.toJson()};
  }
}

class UserCompany {
  final String? id;
  final String? idCompany;
  final String? idUser;
  final DateTime? addTime;
  final DateTime? updTime;
  final String? status;

  UserCompany({
    this.id,
    this.idCompany,
    this.idUser,
    this.addTime,
    this.updTime,
    this.status,
  });

  factory UserCompany.fromJson(Map<String, dynamic> json) {
    return UserCompany(
      id: json["_id"],
      idCompany: json["idCompany"],
      idUser: json["idUser"],
      addTime: json["addTime"] != null ? DateTime.parse(json["addTime"]) : null,
      updTime: json["updTime"] != null ? DateTime.parse(json["updTime"]) : null,
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "idCompany": idCompany,
      "idUser": idUser,
      "addTime": addTime?.toIso8601String(),
      "updTime": updTime?.toIso8601String(),
      "status": status,
    };
  }
}
