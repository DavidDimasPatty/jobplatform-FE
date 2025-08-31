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
  final String id;
  final String idCompany;
  final String idUser;
  final DateTime addTime;
  final DateTime updTime;
  final String status;

  UserCompany({
    required this.id,
    required this.idCompany,
    required this.idUser,
    required this.addTime,
    required this.updTime,
    required this.status,
  });

  factory UserCompany.fromJson(Map<String, dynamic> json) {
    return UserCompany(
      id: json['_id'],
      idCompany: json['idCompany'],
      idUser: json['idUser'],
      addTime: DateTime.parse(json['addTime']),
      updTime: DateTime.parse(json['updTime']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "idCompany": idCompany,
      "idUser": idUser,
      "addTime": addTime.toIso8601String(),
      "updTime": updTime.toIso8601String(),
      "status": status,
    };
  }
}
