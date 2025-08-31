class Progress {
  final LastSurvey lastSurvey;
  final LastAdmin lastAdmin;
  final String stage;

  Progress({
    required this.lastSurvey,
    required this.lastAdmin,
    required this.stage,
  });

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      lastSurvey: LastSurvey.fromJson(json['lastSurvey']),
      lastAdmin: LastAdmin.fromJson(json['lastAdmin']),
      stage: json['stage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lastSurvey': lastSurvey.toJson(),
      'lastAdmin': lastAdmin.toJson(),
      'stage': stage,
    };
  }
}

class LastSurvey {
  final ObjectId id;
  final ObjectId idPerusahaan;
  final ObjectId idSurveyer;
  final DateTime dateSurvey;
  final String statusSurvey;
  final DateTime statusDate;
  final DateTime addTime;
  final DateTime updTime;
  final String alasanReject;

  LastSurvey({
    required this.id,
    required this.idPerusahaan,
    required this.idSurveyer,
    required this.dateSurvey,
    required this.statusSurvey,
    required this.statusDate,
    required this.addTime,
    required this.updTime,
    required this.alasanReject,
  });

  factory LastSurvey.fromJson(Map<String, dynamic> json) {
    return LastSurvey(
      id: ObjectId.fromJson(json['_id']),
      idPerusahaan: ObjectId.fromJson(json['idPerusahaan']),
      idSurveyer: ObjectId.fromJson(json['idSurveyer']),
      dateSurvey: DateTime.parse(json['dateSurvey']),
      statusSurvey: json['statusSurvey'],
      statusDate: DateTime.parse(json['statusDate']),
      addTime: DateTime.parse(json['addTime']),
      updTime: DateTime.parse(json['updTime']),
      alasanReject: json['alasanReject'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id.toJson(),
      'idPerusahaan': idPerusahaan.toJson(),
      'idSurveyer': idSurveyer.toJson(),
      'dateSurvey': dateSurvey.toIso8601String(),
      'statusSurvey': statusSurvey,
      'statusDate': statusDate.toIso8601String(),
      'addTime': addTime.toIso8601String(),
      'updTime': updTime.toIso8601String(),
      'alasanReject': alasanReject,
    };
  }
}

class LastAdmin {
  final ObjectId id;
  final ObjectId idPerusahaanSurvey;
  final ObjectId idAdmin;
  final String status;
  final DateTime statusDate;
  final DateTime addTime;
  final DateTime updTime;
  final String alasanReject;

  LastAdmin({
    required this.id,
    required this.idPerusahaanSurvey,
    required this.idAdmin,
    required this.status,
    required this.statusDate,
    required this.addTime,
    required this.updTime,
    required this.alasanReject,
  });

  factory LastAdmin.fromJson(Map<String, dynamic> json) {
    return LastAdmin(
      id: ObjectId.fromJson(json['_id']),
      idPerusahaanSurvey: ObjectId.fromJson(json['idPerusahaanSurvey']),
      idAdmin: ObjectId.fromJson(json['idAdmin']),
      status: json['status'],
      statusDate: DateTime.parse(json['statusDate']),
      addTime: DateTime.parse(json['addTime']),
      updTime: DateTime.parse(json['updTime']),
      alasanReject: json['alasanReject'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id.toJson(),
      'idPerusahaanSurvey': idPerusahaanSurvey.toJson(),
      'idAdmin': idAdmin.toJson(),
      'status': status,
      'statusDate': statusDate.toIso8601String(),
      'addTime': addTime.toIso8601String(),
      'updTime': updTime.toIso8601String(),
      'alasanReject': alasanReject,
    };
  }
}

class ObjectId {
  final int timestamp;
  final DateTime creationTime;

  ObjectId({required this.timestamp, required this.creationTime});

  factory ObjectId.fromJson(Map<String, dynamic> json) {
    return ObjectId(
      timestamp: json['timestamp'],
      creationTime: DateTime.parse(json['creationTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'creationTime': creationTime.toIso8601String(),
    };
  }
}
