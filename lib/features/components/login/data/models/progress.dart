class Progress {
  final LastSurvey? lastSurvey;
  final LastAdmin? lastAdmin;
  final String? stage;

  Progress({this.lastSurvey, this.lastAdmin, this.stage});

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      lastSurvey: json['lastSurvey'] != null
          ? LastSurvey.fromJson(json['lastSurvey'])
          : null,
      lastAdmin: json['lastAdmin'] != null
          ? LastAdmin.fromJson(json['lastAdmin'])
          : null,
      stage: json['stage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lastSurvey': lastSurvey?.toJson(),
      'lastAdmin': lastAdmin?.toJson(),
      'stage': stage,
    };
  }
}

class LastSurvey {
  final String? id;
  final String? idPerusahaan;
  final String? idSurveyer;
  final DateTime? dateSurvey;
  final String? statusSurvey;
  final DateTime? statusDate;
  final DateTime? addTime;
  final DateTime? updTime;
  final String? alasanReject;

  LastSurvey({
    this.id,
    this.idPerusahaan,
    this.idSurveyer,
    this.dateSurvey,
    this.statusSurvey,
    this.statusDate,
    this.addTime,
    this.updTime,
    this.alasanReject,
  });

  factory LastSurvey.fromJson(Map<String, dynamic> json) {
    return LastSurvey(
      id: json['_id'],
      idPerusahaan: json['idPerusahaan'],
      idSurveyer: json['idSurveyer'],
      dateSurvey: json['dateSurvey'] != null
          ? DateTime.parse(json['dateSurvey'])
          : null,
      statusSurvey: json['statusSurvey'],
      statusDate: json['statusDate'] != null
          ? DateTime.parse(json['statusDate'])
          : null,
      addTime: json['addTime'] != null ? DateTime.parse(json['addTime']) : null,
      updTime: json['updTime'] != null ? DateTime.parse(json['updTime']) : null,
      alasanReject: json['alasanReject'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'idPerusahaan': idPerusahaan,
      'idSurveyer': idSurveyer,
      'dateSurvey': dateSurvey?.toIso8601String(),
      'statusSurvey': statusSurvey,
      'statusDate': statusDate?.toIso8601String(),
      'addTime': addTime?.toIso8601String(),
      'updTime': updTime?.toIso8601String(),
      'alasanReject': alasanReject,
    };
  }
}

class LastAdmin {
  final String? id;
  final String? idPerusahaanSurvey;
  final String? idAdmin;
  final String? status;
  final DateTime? statusDate;
  final DateTime? addTime;
  final DateTime? updTime;
  final String? alasanReject;

  LastAdmin({
    this.id,
    this.idPerusahaanSurvey,
    this.idAdmin,
    this.status,
    this.statusDate,
    this.addTime,
    this.updTime,
    this.alasanReject,
  });

  factory LastAdmin.fromJson(Map<String, dynamic> json) {
    return LastAdmin(
      id: json['_id'],
      idPerusahaanSurvey: json['idPerusahaanSurvey'],
      idAdmin: json['idAdmin'],
      status: json['status'],
      statusDate: json['statusDate'] != null
          ? DateTime.parse(json['statusDate'])
          : null,
      addTime: json['addTime'] != null ? DateTime.parse(json['addTime']) : null,
      updTime: json['updTime'] != null ? DateTime.parse(json['updTime']) : null,
      alasanReject: json['alasanReject'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'idPerusahaanSurvey': idPerusahaanSurvey,
      'idAdmin': idAdmin,
      'status': status,
      'statusDate': statusDate?.toIso8601String(),
      'addTime': addTime?.toIso8601String(),
      'updTime': updTime?.toIso8601String(),
      'alasanReject': alasanReject,
    };
  }
}
