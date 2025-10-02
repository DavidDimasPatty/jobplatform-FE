class Profiledata {
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
  final String domisili;
  final String cv;
  final String headline;
  final String photoURL;
  final String ringkasan;
  final bool isVisible;
  final int seekStatus;
  final bool privacy;

  Profiledata({
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
    this.domisili = '',
    this.cv = '',
    this.headline = '',
    this.photoURL = '',
    this.ringkasan = '',
    this.isVisible = true,
    this.seekStatus = 0,
    this.privacy = false
  });

  factory Profiledata.fromJson(Map<String, dynamic> json) {
    return Profiledata(
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
      tanggalLahir: DateTime.parse(json['tanggalLahir'] ?? DateTime.now().toString()),
      tempatLahir: json['tempatLahir'] ?? '',
      jenisKelamin: json['jenisKelamin'] ?? '',
      lastLogin: DateTime.parse(json['lastLogin'] ?? DateTime.now().toString()),
      statusAccount: json['statusAccount'] ?? '',
      addTime: DateTime.parse(json['addTime'] ?? DateTime.now().toString()),
      updTime: DateTime.parse(json['updTime'] ?? DateTime.now().toString()),
      noTelp: json['noTelp'] ?? '',
      domisili: json['domisili'] ?? '',
      cv: json['cv'] ?? '',
      headline: json['headline'] ?? '',
      photoURL: json['photoURL'] ?? '',
      ringkasan: json['ringkasan'] ?? '',
      isVisible: json['visibility'] ?? true,
      seekStatus: json['seekStatus'] ?? 0,
      privacy: json['privacy'] ?? false,
    );
  }
}
