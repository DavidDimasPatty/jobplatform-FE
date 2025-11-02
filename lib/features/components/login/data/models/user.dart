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
  final String? photoURL;

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
    this.photoURL,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["_id"],
      nama: json["nama"],
      email: json["email"],
      tanggalLahir: json["tanggalLahir"] != null
          ? DateTime.parse(json["tanggalLahir"])
          : null,
      tempatLahir: json["tempatLahir"],
      jenisKelamin: json["jenisKelamin"],
      lastLogin: json["lastLogin"] != null
          ? DateTime.parse(json["lastLogin"])
          : null,
      statusAccount: json["statusAccount"],
      addTime: json["addTime"] != null ? DateTime.parse(json["addTime"]) : null,
      updTime: json["updTime"] != null ? DateTime.parse(json["updTime"]) : null,
      noTelp: json["noTelp"],
      domisili: json["domisili"],
      photoURL: json["photoURL"] ?? null,
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
