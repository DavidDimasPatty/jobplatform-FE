class SignupRequestModel {
  final String registerAs;
  final String email;
  final String nama;
  final String alamat;
  final String noTelp;
  final DateTime? tanggalLahir;
  final String? jenisKelamin;
  final String? domainPerusahaan;

  SignupRequestModel({
    required this.registerAs,
    required this.email,
    required this.nama,
    required this.alamat,
    required this.noTelp,
    this.tanggalLahir,
    this.jenisKelamin,
    this.domainPerusahaan,
  });

  Map<String, dynamic> toJson() {
    return {
      "registerAs": registerAs,
      "email": email,
      "nama": nama,
      "alamat": alamat,
      "noTelp": noTelp,
      "tanggalLahir": tanggalLahir!.toIso8601String(),
      "jenisKelamin": jenisKelamin,
    };
  }
}
