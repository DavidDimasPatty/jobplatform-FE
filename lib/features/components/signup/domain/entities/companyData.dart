class CompanyData {
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

  CompanyData({
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
}
