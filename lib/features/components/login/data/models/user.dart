class UserModel {
  final String nama;
  final String email;
  final DateTime tanggalLahir;
  final String tempatLahir;
  final String jenisKelamin;
  final DateTime lastLogin;
  final String statusAccount;
  final DateTime addTime;
  final DateTime updTime;
  final String noTelp;

  UserModel({
    required this.nama,
    required this.email,
    required this.tanggalLahir,
    required this.tempatLahir,
    required this.jenisKelamin,
    required this.lastLogin,
    required this.statusAccount,
    required this.addTime,
    required this.updTime,
    required this.noTelp,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      nama: json["nama"],
      email: json["email"],
      tanggalLahir: DateTime.parse(json["tanggalLahir"]),
      tempatLahir: json["tempatLahir"],
      jenisKelamin: json["jenisKelamin"],
      lastLogin: DateTime.parse(json["lastLogin"]),
      statusAccount: json["statusAccount"],
      addTime: DateTime.parse(json["addTime"]),
      updTime: DateTime.parse(json["updTime"]),
      noTelp: json["noTelp"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "nama": nama,
      "email": email,
      "tanggalLahir": tanggalLahir.toIso8601String(),
      "tempatLahir": tempatLahir,
      "jenisKelamin": jenisKelamin,
      "lastLogin": lastLogin.toIso8601String(),
      "statusAccount": statusAccount,
      "addTime": addTime.toIso8601String(),
      "updTime": updTime.toIso8601String(),
      "noTelp": noTelp,
    };
  }
}
