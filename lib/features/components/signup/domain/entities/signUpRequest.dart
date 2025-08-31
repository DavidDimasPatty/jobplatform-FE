class SignupRequestModel {
  final String registerAs;
  final String email;
  final String nama;
  final String alamat;
  final String noTelp;
  final DateTime tanggalLahir;
  final String jenisKelamin;

  SignupRequestModel({
    required this.registerAs,
    required this.email,
    required this.nama,
    required this.alamat,
    required this.tanggalLahir,
    required this.noTelp,
    required this.jenisKelamin,
  });

  Map<String, dynamic> toJson() {
    return {
      "registerAs": registerAs,
      "email": email,
      "nama": nama,
      "alamat": alamat,
      "noTelp": noTelp,
      "tanggalLahir": tanggalLahir.toIso8601String(),
      "jenisKelamin": jenisKelamin,
    };
  }
}
