import 'package:job_platform/features/components/manageHRD/data/models/HRDData.dart';

class GetAllHRDTransaction {
  final String? id;
  final String? status;
  final String? idCompany;
  final DateTime? addTime;
  final DateTime? updTime;
  final HRDData? dataHRD;
  GetAllHRDTransaction({
    this.id,
    this.status,
    this.idCompany,
    this.addTime,
    this.updTime,
    this.dataHRD,
  });

  factory GetAllHRDTransaction.fromJson(Map<String, dynamic> json) {
    return GetAllHRDTransaction(
      id: json["_id"],
      status: json["status"],
      idCompany: json["idCompany"],
      addTime: json["addTime"] != null ? DateTime.parse(json["addTime"]) : null,
      updTime: json["updTime"] != null ? DateTime.parse(json["updTime"]) : null,
      dataHRD: json["dataHRD"] != null ? HRDData.fromJson(json) : null,
    );
  }

  Map<String, dynamic> toJsonDeleteHRD() {
    return {"id": id};
  }

  Map<String, dynamic> toJsonAddHRD(String email) {
    return {"idCompany": idCompany, "emailUser": email};
  }
}
