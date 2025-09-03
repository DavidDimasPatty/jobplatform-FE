class CompanyModel {
  final String id;
  final String nama;
  final String alamat;
  final String domain;
  final String noTelp;
  final String email;
  final DateTime lastLogin;
  final String statusAccount;
  final DateTime addTime;
  final DateTime? updTime;

  CompanyModel({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.domain,
    required this.noTelp,
    required this.email,
    required this.lastLogin,
    required this.statusAccount,
    required this.addTime,
    this.updTime,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json["_id"],
      nama: json["nama"],
      alamat: json["alamat"],
      domain: json["domain"],
      noTelp: json["noTelp"],
      email: json["email"],
      lastLogin: DateTime.parse(json["lastLogin"]),
      statusAccount: json["statusAccount"],
      addTime: DateTime.parse(json["addTime"]),
      updTime: json["updTime"] != null ? DateTime.parse(json["updTime"]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nama": nama,
      "alamat": alamat,
      "domain": domain,
      "noTelp": noTelp,
      "email": email,
      "lastLogin": lastLogin.toIso8601String(),
      "statusAccount": statusAccount,
      "addTime": addTime.toIso8601String(),
      "updTime": updTime?.toIso8601String(),
    };
  }
}
