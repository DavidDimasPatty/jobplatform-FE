class SettingModel {
  final String? id;
  final String? nama;
  final String? alamat;
  final String? domain;
  final DateTime? addTime;
  final DateTime? updTime;
  final String? noTelp;
  final DateTime? lastLogin;
  final String? email;
  final String? statusAccount;

  SettingModel({
    this.id,
    this.nama,
    this.alamat,
    this.domain,
    this.addTime,
    this.updTime,
    this.noTelp,
    this.lastLogin,
    this.email,
    this.statusAccount,
  });

  factory SettingModel.fromJson(Map<String, dynamic> json) {
    return SettingModel(
      id: json["_id"],
      nama: json["nama"],
      alamat: json["alamat"],
      domain: json["domain"],
      addTime: json["addTime"] != null ? DateTime.parse(json["addTime"]) : null,
      updTime: json["updTime"] != null ? DateTime.parse(json["updTime"]) : null,
      noTelp: json["noTelp"],
      lastLogin: json["lastLogin"] != null
          ? DateTime.parse(json["lastLogin"])
          : null,
      email: json["email"],
      statusAccount: json["statusAccount"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "nama": nama,
      "alamat": alamat,
      "domain": domain,
      "addTime": addTime?.toIso8601String(),
      "updTime": updTime?.toIso8601String(),
      "noTelp": noTelp,
      "lastLogin": lastLogin?.toIso8601String(),
      "email": email,
      "statusAccount": statusAccount,
    };
  }
}
