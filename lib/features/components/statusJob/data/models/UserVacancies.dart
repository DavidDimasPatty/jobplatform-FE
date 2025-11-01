class UserVacancies {
  final String? id;
  final String? idUserVacancy;
  final int? status;
  final String? alasanReject;
  final DateTime? addTime;
  final String? addId;
  final DateTime? updTime;
  final String? updId;
  final bool? isAccept;
  final double? gajiMin;
  final double? gajiMax;
  final String? sistemKerja;
  final String? tipeKerja;

  UserVacancies({
    this.id,
    this.idUserVacancy,
    this.status,
    this.alasanReject,
    this.addTime,
    this.addId,
    this.updTime,
    this.updId,
    this.isAccept,
    this.gajiMax,
    this.gajiMin,
    this.sistemKerja,
    this.tipeKerja,
  });

  factory UserVacancies.fromJson(Map<String, dynamic> json) {
    return UserVacancies(
      id: json["_id"] ?? null,
      idUserVacancy: json["idUserVacancy"] ?? null,
      status: json["status"] ?? null,
      alasanReject:
          (json["alasanReject"] == null || json["alasanReject"] == "BsonNull")
          ? null
          : json["alasanReject"],
      addTime: json["addTime"] != null ? DateTime.parse(json["addTime"]) : null,
      addId: json["addId"] ?? null,
      updId: json["updId"] ?? null,
      updTime: json["updTime"] != null ? DateTime.parse(json["updTime"]) : null,
      isAccept: bool.tryParse(json["isAccept"].toString()) ?? null,
      gajiMax: json["gajiMax"] != null
          ? double.parse(json["gajiMax"].toString())
          : null,
      gajiMin: json["gajiMin"] != null
          ? double.parse(json["gajiMin"].toString())
          : null,
      sistemKerja: json["sistemKerja"] != null
          ? json["sistemKerja"].toString()
          : null,
      tipeKerja: json["tipeKerja"] != null
          ? json["tipeKerja"].toString()
          : null,
    );
  }
}
