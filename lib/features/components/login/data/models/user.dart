import 'dart:ffi';

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
  final bool? is2FA;
  final bool? isNotifInternal;
  final bool? isNotifExternal;
  final bool? isPremium;
  final bool? isDarkMode;
  final String? language;
  final String? fontSize;

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
    this.is2FA,
    this.isNotifInternal,
    this.isNotifExternal,
    this.isPremium,
    this.isDarkMode,
    this.language,
    this.fontSize,
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
      is2FA: json["is2FA"] != null ? bool.parse(json["is2FA"]) : false,
      isDarkMode: json["isDarkMode"] != null
          ? bool.parse(json["isDarkMode"])
          : false,
      isNotifExternal: json["isNotifExternal"] != null
          ? bool.parse(json["isNotifExternal"])
          : false,
      isNotifInternal: json["isNotifInternal"] != null
          ? bool.parse(json["isNotifInternal"])
          : false,
      isPremium: json["isPremium"] != null
          ? bool.parse(json["isPremium"])
          : false,
      language: json["language"] ?? null,
      fontSize: json["fontSize"] ?? null,
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
