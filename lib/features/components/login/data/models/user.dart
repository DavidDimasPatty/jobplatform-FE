class UserModel {
  final String? id;
  final String? nama;
  final String? email;
  final DateTime? tanggalLahir;
  final String? tempatLahir;
  final String? jenisKelamin;
  final DateTime? lastLogin;
  final String? statusAccount;
  final DateTime? addTime;
  final DateTime? updTime;
  final String? noTelp;
  final String? domisili;

  UserModel({
    this.id,
    this.nama,
    this.email,
    this.tanggalLahir,
    this.tempatLahir,
    this.jenisKelamin,
    this.lastLogin,
    this.statusAccount,
    this.addTime,
    this.updTime,
    this.noTelp,
    this.domisili,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["_id"] != null ? json["_id"] : null,
      nama: json["nama"] != null ? json["nama"] : null,
      email: json["email"] != null ? json["email"] : null,
      tanggalLahir: json["tanggalLahir"] != null
          ? DateTime.parse(json["tanggalLahir"])
          : null,
      tempatLahir: json["tempatLahir"] != null ? json["tempatLahir"] : null,
      jenisKelamin: json["jenisKelamin"] != null ? json["jenisKelamin"] : null,
      lastLogin: json["lastLogin"] != null
          ? DateTime.parse(json["lastLogin"])
          : null,
      statusAccount: json["statusAccount"] != null
          ? json["statusAccount"]
          : null,
      addTime: json["addTime"] != null ? DateTime.parse(json["addTime"]) : null,
      updTime: json["updTime"] != null ? DateTime.parse(json["updTime"]) : null,
      noTelp: json["noTelp"] != null ? json["noTelp"] : null,
      domisili: json["domisili"] != null ? json["domisili"] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nama": nama,
      "email": email,
      "tanggalLahir": tanggalLahir?.toIso8601String(),
      "tempatLahir": tempatLahir,
      "jenisKelamin": jenisKelamin,
      "lastLogin": lastLogin?.toIso8601String(),
      "statusAccount": statusAccount,
      "addTime": addTime?.toIso8601String(),
      "updTime": updTime?.toIso8601String(),
      "noTelp": noTelp,
      "domisili": domisili,
    };
  }
}
