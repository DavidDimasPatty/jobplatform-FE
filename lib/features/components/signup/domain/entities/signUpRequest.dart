class SignupRequestModel {
  final String registerAs;
  final String email;
  final String nama;
  final String? tempatLahir;
  final String noTelp;
  final DateTime? tanggalLahir;
  final String? jenisKelamin;
  final String? domainPerusahaan;
  final String? domisili;
  final String? alamat;

  SignupRequestModel({
    required this.registerAs,
    required this.email,
    required this.nama,
    this.tempatLahir,
    required this.noTelp,
    this.tanggalLahir,
    this.jenisKelamin,
    this.domainPerusahaan,
    this.domisili,
    this.alamat,
  });

  Map<String, dynamic> toJson() {
    return {
      "registerAs": registerAs,
      "email": email,
      "nama": nama,
      "tempatLahir": tempatLahir,
      "noTelp": noTelp,
      "tanggalLahir": tanggalLahir!.toIso8601String(),
      "jenisKelamin": jenisKelamin,
      "domisili": domisili,
      "tempatLahir": tempatLahir,
    };
  }
}
