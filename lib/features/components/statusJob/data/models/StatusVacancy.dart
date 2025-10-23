import 'dart:ffi';

class StatusVacancy {
  final String? id;
  final String? idUserVacancy;
  final int? status;
  final String? alasanReject;
  final DateTime? addTime;
  final String? addId;
  final DateTime? updTime;
  final String? updId;

  StatusVacancy({
    this.id,
    this.idUserVacancy,
    this.status,
    this.alasanReject,
    this.addTime,
    this.addId,
    this.updTime,
    this.updId,
  });

  factory StatusVacancy.fromJson(Map<String, dynamic> json) {
    return StatusVacancy(
      id: json["id"] ?? null,
      idUserVacancy: json["idUserVacancy"] ?? null,
      status: json["status"] != null ? int.parse(json["status"]) : null,
      alasanReject: json["alasanReject"] ?? null,
      addTime: json["addTime"] != null ? DateTime.parse(json["addTime"]) : null,
      addId: json["addId"] ?? null,
      updId: json["updId"] ?? null,
      updTime: json["updTime"] != null ? DateTime.parse(json["updTime"]) : null,
    );
  }
}
