class Company {
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

  Company({
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

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json["_id"] != null ? json["_id"] : null,
      nama: json["nama"] != null ? json["nama"] : null,
      alamat: json["alamat"] != null ? json["alamat"] : null,
      domain: json["domain"] != null ? json["domain"] : null,
      addTime: json["addTime"] != null ? DateTime.parse(json["addTime"]) : null,
      updTime: json["updTime"] != null ? DateTime.parse(json["updTime"]) : null,
      noTelp: json["noTelp"] != null ? json["noTelp"] : null,
      lastLogin: json["lastLogin"] != null
          ? DateTime.parse(json["lastLogin"])
          : null,
      email: json["email"] != null ? json["email"] : null,
      statusAccount: json["statusAccount"] != null
          ? json["statusAccount"]
          : null,
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
